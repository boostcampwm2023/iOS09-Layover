import { Module } from '@nestjs/common';
import { OauthController } from './oauth.controller';
import { HttpModule } from '@nestjs/axios';
import { OauthService } from './oauth.service';
import { MemberModule } from 'src/database/member/member.module';
import { JwtModule } from '@nestjs/jwt';
import { RedisModule } from 'src/redis/redis.module';

@Module({
  imports: [
    HttpModule,
    MemberModule,
    JwtModule.register({
      signOptions: { algorithm: 'HS256' },
      secret: process.env.JWT_SECRET_KEY,
    }),
    RedisModule,
  ],
  controllers: [OauthController],
  providers: [OauthService],
})
export class OauthModule {}
