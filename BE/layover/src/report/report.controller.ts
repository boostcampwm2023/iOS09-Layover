import { Body, Controller, Post } from '@nestjs/common';
import { CustomHeader } from 'src/pipes/custom-header.decorator';
import { JwtValidationPipe } from 'src/pipes/jwt.validation.pipe';
import { ReportService } from './report.service';

@Controller('report')
export class ReportController {
  constructor(private readonly reportService: ReportService) {}

  @Post()
  receiveReport(@CustomHeader(new JwtValidationPipe()) payload, @Body('reportType') reportType: string) {
    const id = payload.memberId;
    this.reportService.insertReport(id, reportType);
  }
}
