import { Module } from '@nestjs/common';
import { OauthController } from './oauth.controller';
import { HttpModule } from '@nestjs/axios';
import { Member } from 'src/database/member/member.entity';

@Module({
  imports: [HttpModule, Member],
  controllers: [OauthController],
})
export class OauthModule {}
