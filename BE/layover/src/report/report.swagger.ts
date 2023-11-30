import { HttpStatus } from '@nestjs/common';
import { getSchemaPath } from '@nestjs/swagger';
import { ReportResDto } from './dtos/report-res.dto';

export const REPORT_SWAGGER = {
  RECEIVE_REPORT_SUCCESS: {
    status: HttpStatus.OK,
    description: '신고 요청 성공',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'SUCCESS' },
        message: { type: 'string', example: '성공' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(ReportResDto) },
      },
    },
  },
};
