import { HttpStatus } from '@nestjs/common';
import { getSchemaPath } from '@nestjs/swagger';
import { TokenResDto } from './dtos/token-res.dto';
import { CheckSignupResDto } from './dtos/check-signup-res-dto';

export const OAUTH_SWAGGER = {
  PROCESS_KAKAO_LOGIN_SUCCESS: {
    status: HttpStatus.OK,
    description: '카카오 로그인 성공',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'SUCCESS' },
        message: { type: 'string', example: '성공' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(TokenResDto) },
      },
    },
  },
  PROCESS_APPLE_LOGIN_SUCCESS: {
    status: HttpStatus.OK,
    description: '애플 로그인 성공',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'SUCCESS' },
        message: { type: 'string', example: '성공' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(TokenResDto) },
      },
    },
  },
  PROCESS_KAKAO_SIGNUP_SUCCESS: {
    status: HttpStatus.OK,
    description: '카카오 회원가입 성공',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'SUCCESS' },
        message: { type: 'string', example: '성공' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(TokenResDto) },
      },
    },
  },
  PROCESS_APPLE_SIGNUP_SUCCESS: {
    status: HttpStatus.OK,
    description: '애플 회원가입 성공',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'SUCCESS' },
        message: { type: 'string', example: '성공' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(TokenResDto) },
      },
    },
  },
  RENEW_TOKENS_SUCCESS: {
    status: HttpStatus.OK,
    description: '토큰 재발급 성공',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'SUCCESS' },
        message: { type: 'string', example: '성공' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(TokenResDto) },
      },
    },
  },
  CHECK_SIGNUP_SUCCESS: {
    status: HttpStatus.OK,
    description: '회원가입 여부 확인 성공',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'SUCCESS' },
        message: { type: 'string', example: '성공' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(CheckSignupResDto) },
      },
    },
  },
};
