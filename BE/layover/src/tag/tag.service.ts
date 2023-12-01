import { Inject, Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { Tag } from './tag.entity';
import { Board } from '../board/board.entity';

@Injectable()
export class TagService {
  constructor(@Inject('TAG_REPOSITORY') private tagRepository: Repository<Tag>) {}

  async findByBoardId(boardId: number): Promise<Tag[]> {
    return await this.tagRepository.find({ where: { board: { id: boardId } } });
  }

  async saveTag(board: Board, tagname: string): Promise<void> {
    await this.tagRepository.save({ board: board, tagname: tagname });
  }
}
