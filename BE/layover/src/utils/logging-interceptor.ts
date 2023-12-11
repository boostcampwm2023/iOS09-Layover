import { CallHandler, ExecutionContext, Injectable, Logger, NestInterceptor } from '@nestjs/common';
import { catchError, from, Observable, tap } from 'rxjs';
import { EMessage } from '../response/ecustom-code.jenum';
import axios from 'axios';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  private readonly logger = new Logger(LoggingInterceptor.name);

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const req = context.switchToHttp().getRequest();
    const { method, url, body, query } = req;
    const errorWebHook: string = process.env.ERR_WEB_HOOK;
    this.logger.log(`[IN] ${method} ${url} ${JSON.stringify(body)} ${JSON.stringify(query)}`);

    return next.handle().pipe(
      tap(), // 응답이 정상적으로 끝나면 tap 안에서 수행되지만, exception 을 날리므로 error 로 처리해야함.
      catchError((exception) => from(this.handleException(exception, method, url, errorWebHook))),
    );
  }

  async handleException(exception, method, url, errorWebHook) {
    if (exception.message !== EMessage.SUCCESS) {
      this.logger.error(`[OUT] ${method} ${url}: ${exception.message}`);
      await axios.post(errorWebHook, {
        embeds: [
          {
            title: `[${method}] ${url}`,
            description: exception.message,
            color: 16711680,
          },
        ],
      });
    } else {
      this.logger.log(`[OUT] ${method} ${url}: ${exception.message}`);
    }
    throw exception;
  }
}
