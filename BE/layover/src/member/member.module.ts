import { Module } from '@nestjs/common';
import { DatabaseModule } from '../database/database.module';
import { memberProviders } from './member.providers';
import { MemberService } from './member.service';

@Module({
  imports: [DatabaseModule],
  providers: [...memberProviders, MemberService],
  exports: [MemberService],
})
export class MemberModule {}
