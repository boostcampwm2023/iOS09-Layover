import { Module } from '@nestjs/common';
import { ReportController } from './report.controller';
import { reportProvider } from './report.provider';
import { ReportService } from './report.service';

@Module({
  controllers: [ReportController],
  providers: [...reportProvider, ReportService],
})
export class ReportModule {}
