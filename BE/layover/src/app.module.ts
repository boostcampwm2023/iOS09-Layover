import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { DatabaseModule } from './database/database.module';
import { OauthModule } from './oauth/oauth.module';
import { ServeStaticModule } from '@nestjs/serve-static';
import { join } from 'path';
import { BoardModule } from './board/board.module';
import { TagModule } from './tag/tag.module';
import { ReportModule } from './report/report.module';
import { LoggingInterceptor } from './utils/logging-interceptor';
import { APP_INTERCEPTOR } from '@nestjs/core';

@Module({
  imports: [
    DatabaseModule,
    OauthModule,
    ServeStaticModule.forRoot({ rootPath: join(__dirname, '..', 'public') }),
    BoardModule,
    TagModule,
    ReportModule,
  ],
  controllers: [AppController],
  providers: [
    AppService,
    {
      provide: APP_INTERCEPTOR,
      useClass: LoggingInterceptor,
    },
  ],
})
export class AppModule {}
