import { Module } from '@nestjs/common';
import { DatabaseModule } from '../database/database.module';
import { memberProviders } from './member.providers';
import { MemberService } from './member.service';
import { MemberController } from './member.controller';

@Module({
  imports: [DatabaseModule],
  providers: [...memberProviders, MemberService],
  exports: [MemberService],
  controllers: [MemberController],
})
export class MemberModule {}
