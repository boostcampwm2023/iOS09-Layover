import { Module } from '@nestjs/common';
import { BoardController } from './board.controller';
import { BoardService } from './board.service';
import { DatabaseModule } from '../database/database.module';
import { boardProvider } from './board.provider';
import { MemberModule } from '../member/member.module';
import { VideoModule } from '../video/video.module';
import { TagModule } from '../tag/tag.module';

@Module({
  imports: [DatabaseModule, MemberModule, VideoModule, TagModule],
  providers: [...boardProvider, BoardService],
  exports: [BoardService],
  controllers: [BoardController],
})
export class BoardModule {}
