import { Body, Controller, Post } from '@nestjs/common';
import { CustomHeader } from 'src/pipes/custom-header.decorator';
import { JwtValidationPipe } from 'src/pipes/jwt.validation.pipe';
import { ReportService } from './report.service';
import { tokenPayload } from 'src/utils/interfaces/token.payload';
import { CustomResponse } from 'src/response/custom-response';
import { ECustomCode } from 'src/response/ecustom-code.jenum';
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { SWAGGER } from 'src/utils/swaggerUtils';
import { ReportResDto } from './dtos/report-res.dto';
import { ReportDto } from './dtos/report.dto';
import { REPORT_SWAGGER } from './report.swagger';

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
  @ApiResponse(REPORT_SWAGGER.RECEIVE_REPORT_SUCCESS)
  @ApiBearerAuth('token')
  @Post()
  async receiveReport(@CustomHeader(new JwtValidationPipe()) payload: tokenPayload, @Body() body: ReportDto) {
    const responseData: ReportResDto = await this.reportService.createReport(
      payload.memberId,
      body.boardId,
      body.reportType,
    );

    throw new CustomResponse(ECustomCode.SUCCESS, responseData);
  }
}
