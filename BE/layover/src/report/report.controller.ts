import { Body, Controller, HttpStatus, Post } from '@nestjs/common';
import { CustomHeader } from 'src/pipes/custom-header.decorator';
import { JwtValidationPipe } from 'src/pipes/jwt.validation.pipe';
import { ReportService } from './report.service';
import { tokenPayload } from 'src/utils/interfaces/token.payload';
import { CustomResponse } from 'src/response/custom-response';
import { ECustomCode } from 'src/response/ecustom-code.jenum';
import { ApiHeader, ApiOperation, ApiResponse, ApiTags, getSchemaPath } from '@nestjs/swagger';
import { SWAGGER } from 'src/utils/swaggerUtils';
import { ReportResDto } from './dtos/report-res.dto';

@ApiTags('Report API')
@Controller('report')
@ApiResponse(SWAGGER.SERVER_CUSTOM_RESPONSE)
@ApiResponse(SWAGGER.HTTP_ERROR_RESPONSE)
@ApiResponse(SWAGGER.INTERNAL_SERVER_ERROR_RESPONSE)
@ApiResponse(SWAGGER.ACCESS_TOKEN_TIMEOUT_RESPONSE)
export class ReportController {
  constructor(private readonly reportService: ReportService) {}

  @ApiOperation({
    summary: '신고 요청',
    description: '특정 게시글을 신고합니다.',
  })
  @ApiResponse({
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
  })
  @ApiHeader(SWAGGER.AUTHORIZATION_HEADER)
  @Post()
  receiveReport(@CustomHeader(new JwtValidationPipe()) payload: tokenPayload, @Body() body) {
    const id = payload.memberId;
    const boardId = body.boardId;
    const reportType = body.reportType;
    this.reportService.insertReport(id, boardId, reportType);

    throw new CustomResponse(ECustomCode.SUCCESS, new ReportResDto(boardId, reportType));
  }
}
