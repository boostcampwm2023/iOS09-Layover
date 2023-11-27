import { ArgumentsHost, Catch, ExceptionFilter, HttpException, HttpStatus } from '@nestjs/common';
import { Response } from 'express';
import { ECustomCode } from './ecustom-code.jenum';
import { ApiProperty } from '@nestjs/swagger';

export class CustomResponse extends HttpException {
  @ApiProperty({
    example: 'LAYOVER01',
    description: '커스텀 코드',
  })
  customCode: string;
  @ApiProperty({
    description: '응답 데이터',
  })
  data?: any;

  constructor(customException: ECustomCode, data?: any) {
    super(customException.message, customException.statusCode);
    this.customCode = customException.customCode;
    this.data = data;
  }
}

@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  catch(exception: any, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response: Response = ctx.getResponse<Response>();

    let customCode: string;
    let statusCode: HttpStatus;

    if (exception instanceof CustomResponse) {
      customCode = exception.customCode;
      statusCode = exception.getStatus();
    } else if (exception instanceof HttpException) {
      customCode = 'NEST_OFFER_EXCEPTION';
      statusCode = exception.getStatus();
    } else {
      customCode = 'INTERNAL_SERVER_ERROR';
      statusCode = HttpStatus.INTERNAL_SERVER_ERROR;
    }

    response.status(statusCode).json({
      customCode: customCode,
      message: exception.message,
      statusCode: statusCode,
      data: exception.data,
    });
  }
}
