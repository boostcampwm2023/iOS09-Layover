import { ArgumentsHost, Catch, ExceptionFilter, HttpException, HttpStatus } from '@nestjs/common';
import { Response } from 'express';
import { ECustomCode } from './ecustom-code.jenum';
import { ApiProperty } from '@nestjs/swagger';

export class CustomResponse extends HttpException {
  @ApiProperty({
    description: '응답 데이터',
  })
  data?: any;

  constructor(customException: ECustomCode, data?: any) {
    super(customException.message, customException.statusCode);
    this.data = data;
  }
}

@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  catch(exception: any, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response: Response = ctx.getResponse<Response>();

    let statusCode: HttpStatus;

    if (exception instanceof CustomResponse) {
      statusCode = exception.getStatus();
    } else if (exception instanceof HttpException) {
      statusCode = exception.getStatus();
    } else {
      statusCode = HttpStatus.INTERNAL_SERVER_ERROR;
    }

    response.status(statusCode).json({
      message: exception.message,
      statusCode: statusCode,
      data: exception.data,
    });
  }
}
