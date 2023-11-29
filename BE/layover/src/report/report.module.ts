import { Module } from '@nestjs/common';
import { ReportController } from './report.controller';
import { reportProviders } from './report.provider';
import { ReportService } from './report.service';
import { MemberModule } from 'src/member/member.module';

@Module({
  imports: [MemberModule],
  controllers: [ReportController],
  providers: [...reportProviders, ReportService],
})
export class ReportModule {}
