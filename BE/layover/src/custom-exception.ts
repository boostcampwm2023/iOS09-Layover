import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { Enum, EnumType } from 'ts-jenum';
import { Response } from 'express';

export const enum CustomCode {
  'OAUTH01' = 'OAUTH01',
  'JWT01' = 'JWT01',
  'JWT02' = 'JWT02',
  'NEST_OFFER' = 'NEST_OFFER',
  'INTERNAL_SERVER_ERROR' = 'INTERNAL_SERVER_ERROR',
}

@Enum('customCode')
export class ECustomException extends EnumType<ECustomException>() {
  static readonly OAUTH01 = new ECustomException(
    HttpStatus.UNAUTHORIZED,
    CustomCode.OAUTH01,
    '회원가입이 되지 않은 유저입니다.',
  );

  static readonly JWT01 = new ECustomException(
    HttpStatus.UNAUTHORIZED,
    CustomCode.JWT01,
    '유효하지 않은 토큰입니다.',
  );

  static readonly JWT02 = new ECustomException(
    HttpStatus.UNAUTHORIZED,
    CustomCode.JWT02,
    '토큰 만료기간이 경과하였습니다.',
  );

  private constructor(
    readonly statusCode: HttpStatus,
    readonly customCode: CustomCode,
    readonly message: string,
  ) {
    super();
  }
}

export class CustomException extends HttpException {
  customCode: CustomCode;
  data?: any;

  constructor(customException: ECustomException, data?: any) {
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

    let customCode: CustomCode;
    let statusCode: HttpStatus;

    if (exception instanceof CustomException) {
      customCode = exception.customCode;
      statusCode = exception.getStatus();
    } else if (exception instanceof HttpException) {
      customCode = CustomCode.NEST_OFFER;
      statusCode = exception.getStatus();
    } else {
      customCode = CustomCode.INTERNAL_SERVER_ERROR;
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
