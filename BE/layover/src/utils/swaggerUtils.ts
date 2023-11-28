import { HttpStatus } from '@nestjs/common';

export const SWAGGER = {
  BAD_REQUEST_RESPONSE: {
    status: HttpStatus.BAD_REQUEST,
    description: 'Client의 요청이 잘못된 경우',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'OAUTH__' },
        message: { type: 'string', example: '응답코드에 맞는 메시지' },
        statusCode: { type: 'number', example: HttpStatus.BAD_REQUEST },
      },
    },
  },

  HTTP_ERROR_RESPONSE: {
    status: HttpStatus.NOT_FOUND,
    description: '예상치 못한 Http Exception',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'NEST_OFFER_EXCEPTION' },
        message: { type: 'string', example: 'message from nest' },
        statusCode: { type: 'number', example: HttpStatus.NOT_FOUND },
      },
    },
  },

  INTERNAL_SERVER_ERROR_RESPONSE: {
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: '예상치 못한 서버 Exception',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'INTERNAL_SERVER_ERROR' },
        message: { type: 'string', example: 'message from nest' },
        statusCode: { type: 'number', example: HttpStatus.INTERNAL_SERVER_ERROR },
      },
    },
  },

  NOT_OUR_MEMBER_RESPONSE: {
    status: HttpStatus.UNAUTHORIZED,
    description: '회원가입 되지 않은 유저',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'OAUTH01' },
        message: { type: 'string', example: '회원가입이 되지 않은 유저입니다.' },
        statusCode: { type: 'number', example: HttpStatus.UNAUTHORIZED },
      },
    },
  },

  REFRESH_TOKEN_TIMEOUT_RESPONSE: {
    status: HttpStatus.UNAUTHORIZED,
    description: '리프레시 토큰 유효기간 만료',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'JWT02' },
        message: { type: 'string', example: '토큰 만료기간이 경과하였습니다.' },
        statusCode: { type: 'number', example: HttpStatus.UNAUTHORIZED },
      },
    },
  },

  ACCESS_TOKEN_TIMEOUT_RESPONSE: {
    status: HttpStatus.UNAUTHORIZED,
    description: '엑세스 토큰 유효기간 만료',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'JWT02' },
        message: { type: 'string', example: '토큰 만료기간이 경과하였습니다.' },
        statusCode: { type: 'number', example: HttpStatus.UNAUTHORIZED },
      },
    },
  },

  AUTHORIZATION_HEADER: {
    name: 'Authorization',
    description: 'Bearer {token}',
  },
};
/*
@ApiHeaders([
  {
    name: 'Authorization',
    description: 'Bearer {token}',
  },
])
*/
