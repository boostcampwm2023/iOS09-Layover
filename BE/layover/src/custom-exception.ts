import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { Enum, EnumType } from 'ts-jenum';
import { Response } from 'express';

export const enum ErrCode {
  'OAUTH01' = 'OAUTH01',
  'NEST_OFFER' = 'NEST_OFFER',
  'INTERNAL_SERVER_ERROR' = 'INTERNAL_SERVER_ERROR',
}

@Enum('customException')
export class ECustomException extends EnumType<ECustomException>() {
  static readonly OAUTH01 = new ECustomException(
    HttpStatus.UNAUTHORIZED,
    ErrCode.OAUTH01,
    '회원가입이 되지 않은 유저입니다.',
  );

  private constructor(
    readonly statusCode: HttpStatus,
    readonly customCode: ErrCode,
    readonly message: string,
  ) {
    super();
  }
}

export class CustomException extends HttpException {
  customCode: ErrCode;

  constructor(customException: ECustomException) {
    super(customException.message, customException.statusCode);
    this.customCode = customException.customCode;
  }
}

@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  catch(exception: any, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response: Response = ctx.getResponse<Response>();

    let customCode: ErrCode;
    let statusCode: HttpStatus;

    if (exception instanceof CustomException) {
      customCode = exception.customCode;
      statusCode = exception.getStatus();
    } else if (exception instanceof HttpException) {
      customCode = ErrCode.NEST_OFFER;
      statusCode = exception.getStatus();
    } else {
      customCode = ErrCode.INTERNAL_SERVER_ERROR;
      statusCode = HttpStatus.INTERNAL_SERVER_ERROR;
    }

    response.status(statusCode).json({
      customCode,
      message: exception.message,
    });
  }
}
