import { Body, Controller, Post } from '@nestjs/common';
import { CustomHeader } from 'src/pipes/custom-header.decorator';
import { JwtValidationPipe } from 'src/pipes/jwt.validation.pipe';
import { ReportService } from './report.service';
import { tokenPayload } from 'src/utils/interfaces/token.payload';

@Controller('report')
export class ReportController {
  constructor(private readonly reportService: ReportService) {}

  @Post()
  receiveReport(@CustomHeader(new JwtValidationPipe()) payload: tokenPayload, @Body('reportType') reportType: string) {
    const id = payload.memberId;
    this.reportService.insertReport(id, reportType);
  }
}
