import { Module } from '@nestjs/common';
import { OauthController } from './oauth.controller';
import { HttpModule } from '@nestjs/axios';
import { OauthService } from './oauth.service';
import { MemberModule } from 'src/member/member.module';
import { JwtModule } from '@nestjs/jwt';
import { RedisModule } from 'src/redis/redis.module';
import { ConfigModule } from '@nestjs/config';
import { BoardModule } from 'src/board/board.module';

@Module({
  imports: [
    ConfigModule.forRoot(),
    HttpModule,
    MemberModule,
    BoardModule,
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
