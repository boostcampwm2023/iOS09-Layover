import { HttpStatus } from '@nestjs/common';

export const SWAGGER = {
  SERVER_CUSTOM_RESPONSE: {
    status: 0,
    description: '서버에서 처리한 예외',
    schema: {
      type: 'object',
      properties: {
        message: { type: 'string', example: '서버에서 처리한 예외' },
        statusCode: { type: 'number', example: '000' },
      },
    },
  },

  HTTP_ERROR_RESPONSE: {
    status: 0,
    description: '예상치 못한 Http Exception',
    schema: {
      type: 'object',
      properties: {
        message: { type: 'string', example: 'message from nest' },
        statusCode: { type: 'number', example: '000' },
      },
    },
  },

  INTERNAL_SERVER_ERROR_RESPONSE: {
    status: HttpStatus.INTERNAL_SERVER_ERROR,
    description: '예상치 못한 서버 Exception',
    schema: {
      type: 'object',
      properties: {
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
        message: { type: 'string', example: '토큰 만료기간이 경과하였습니다.' },
        statusCode: { type: 'number', example: HttpStatus.UNAUTHORIZED },
      },
    },
  },

  AUTHORIZATION_HEADER: {
    name: 'Authorization',
    description: 'Bearer {token}',
    required: true,
  },

  TAG_QUERY_STRING: { name: 'tag', required: true, description: '조회할 태그 이름' },
  MEMBER_ID_QUERY_STRING: { name: 'memberId', required: false, description: '회원 아이디 (생략하면 본인 정보 요청)' },
  CURSOR_QUERY_STRING: {
    name: 'cursor',
    type: 'number',
    required: false,
    description: '커서페이징에 사용될 값 (비우면 홈에서는 랜덤, 태그와 프로필에서는 최근값을 가져온다.)',
  },
};
