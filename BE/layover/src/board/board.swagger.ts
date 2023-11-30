import { HttpStatus } from '@nestjs/common';
import { getSchemaPath } from '@nestjs/swagger';
import { CreateBoardResDto } from './dtos/create-board-res.dto';
import { PresignedUrlResDto } from './dtos/presigned-url-res.dto';
import { BoardsResDto } from './dtos/boards-res.dto';

export const BOARD_SWAGGER = {
  CREATE_BOARD_SUCCESS: {
    status: HttpStatus.OK,
    description: '게시글 생성 성공',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'SUCCESS' },
        message: { type: 'string', example: '성공' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(CreateBoardResDto) },
      },
    },
  },

  GET_PRESIGNED_URL_SUCCESS: {
    status: HttpStatus.OK,
    description: 'presigned url 요청 성공',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'SUCCESS' },
        message: { type: 'string', example: '성공' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(PresignedUrlResDto) },
      },
    },
  },

  GET_BOARD_SUCCESS: {
    status: HttpStatus.OK,
    description: '홈 화면 게시글 조회 성공',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'SUCCESS' },
        message: { type: 'string', example: '성공' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { type: 'array', items: { $ref: getSchemaPath(BoardsResDto) } },
      },
    },
  },
};
