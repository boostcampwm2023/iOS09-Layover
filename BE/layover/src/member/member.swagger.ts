import { HttpStatus } from '@nestjs/common';
import { getSchemaPath } from '@nestjs/swagger';
import { CheckUsernameResDto } from './dtos/check-username-res.dto';
import { UsernameResDto } from './dtos/username-res.dto';
import { IntroduceResDto } from './dtos/introduce-res.dto';
import { DeleteMemberResDto } from './dtos/delete-member-res.dto';
import { MemberInfosResDto } from './dtos/member-infos-res.dto';
import { PreSignedUrlResDto } from '../utils/pre-signed-url-res.dto';

export const MEMBER_SWAGGER = {
  CHECK_USER_NAME_SUCCESS: {
    status: HttpStatus.OK,
    description: '닉네임 검증 결과',
    schema: {
      type: 'object',
      properties: {
        message: { type: 'boolean', example: '요청이 성공적으로 처리되었습니다.' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(CheckUsernameResDto) },
      },
    },
  },

  UPDATE_USER_NAME_SUCCESS: {
    status: HttpStatus.OK,
    description: '닉네임 수정 결과',
    schema: {
      type: 'object',
      properties: {
        message: { type: 'boolean', example: '요청이 성공적으로 처리되었습니다.' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(UsernameResDto) },
      },
    },
  },

  UPDATE_INTRODUCE_SUCCESS: {
    status: HttpStatus.OK,
    description: '자기소개 수정 결과',
    schema: {
      type: 'object',
      properties: {
        message: { type: 'boolean', example: '요청이 성공적으로 처리되었습니다.' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(IntroduceResDto) },
      },
    },
  },

  DELETE_MEMBER_SUCCESS: {
    status: HttpStatus.OK,
    description: '삭제된 회원 정보(닉네임)',
    schema: {
      type: 'object',
      properties: {
        message: { type: 'boolean', example: '요청이 성공적으로 처리되었습니다.' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(DeleteMemberResDto) },
      },
    },
  },

  GET_UPLOAD_PROFILE_PRESIGNED_URL_SUCCESS: {
    status: HttpStatus.OK,
    description: '프로필 이미지 업로드용 presigned url',
    schema: {
      type: 'object',
      properties: {
        message: { type: 'boolean', example: '요청이 성공적으로 처리되었습니다.' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(PreSignedUrlResDto) },
      },
    },
  },

  UPDATE_PROFILE_IMAGE_TO_DEFAULT_SUCCESS: {
    status: HttpStatus.OK,
    description: '프로필 이미지가 기본 이미지로 변경',
    schema: {
      type: 'object',
      properties: {
        message: { type: 'boolean', example: '요청이 성공적으로 처리되었습니다.' },
        statusCode: { type: 'number', example: HttpStatus.OK },
      },
    },
  },

  GET_MEMBER_INFOS_SUCCESS: {
    status: HttpStatus.OK,
    description: '회원 정보들',
    schema: {
      type: 'object',
      properties: {
        message: { type: 'boolean', example: '요청이 성공적으로 처리되었습니다.' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(MemberInfosResDto) },
      },
    },
  },
};
