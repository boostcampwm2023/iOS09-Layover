import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { DatabaseModule } from './database/database.module';
import { OauthModule } from './oauth/oauth.module';
import { ServeStaticModule } from '@nestjs/serve-static';
import { join } from 'path';
import { BoardModule } from './board/board.module';
import { VideoModule } from './video/video.module';

@Module({
  imports: [DatabaseModule, OauthModule, ServeStaticModule.forRoot({ rootPath: join(__dirname, '..', 'public') }), BoardModule, VideoModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
