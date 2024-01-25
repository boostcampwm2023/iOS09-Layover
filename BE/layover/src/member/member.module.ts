import { Module, forwardRef } from '@nestjs/common';
import { DatabaseModule } from '../database/database.module';
import { memberProviders } from './member.providers';
import { MemberService } from './member.service';
import { MemberController } from './member.controller';
import { MemberRepository } from './member.repository';
import { BoardModule } from 'src/board/board.module';
import { ReportModule } from 'src/report/report.module';
import { RedisModule } from 'src/redis/redis.module';
import { HttpModule } from '@nestjs/axios';

@Module({
  imports: [DatabaseModule, forwardRef(() => BoardModule), forwardRef(() => ReportModule), RedisModule, HttpModule],
  providers: [...memberProviders, MemberService, MemberRepository],
  exports: [MemberService],
  controllers: [MemberController],
})
export class MemberModule {}
