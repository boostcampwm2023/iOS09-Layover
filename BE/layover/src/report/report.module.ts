import { Module, forwardRef } from '@nestjs/common';
import { ReportController } from './report.controller';
import { reportProviders } from './report.provider';
import { ReportService } from './report.service';
import { MemberModule } from 'src/member/member.module';
import { DatabaseModule } from 'src/database/database.module';
import { BoardModule } from 'src/board/board.module';

@Module({
  imports: [DatabaseModule, forwardRef(() => MemberModule), BoardModule],
  controllers: [ReportController],
  providers: [...reportProviders, ReportService],
  exports: [ReportService],
})
export class ReportModule {}
