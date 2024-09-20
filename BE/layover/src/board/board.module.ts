import { Module, forwardRef } from '@nestjs/common';
import { BoardController } from './board.controller';
import { BoardService } from './board.service';
import { DatabaseModule } from '../database/database.module';
import { boardProvider } from './board.provider';
import { MemberModule } from '../member/member.module';
import { TagModule } from '../tag/tag.module';
import { BoardRepository } from './board.repository';

@Module({
  imports: [DatabaseModule, forwardRef(() => MemberModule), TagModule],
  providers: [BoardService, BoardRepository, ...boardProvider],
  exports: [BoardService],
  controllers: [BoardController],
})
export class BoardModule {}
