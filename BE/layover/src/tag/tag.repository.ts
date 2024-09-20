import { Inject } from '@nestjs/common';
import { Repository } from 'typeorm';
import { Tag } from './tag.entity';
import { Board } from '../board/board.entity';

export class TagRepository {
  constructor(@Inject('TAG_REPOSITORY') private tagRepository: Repository<Tag>) {}

  async saveTag(board: Board, tagname: string) {
    await this.tagRepository.save({ board: board, tagname: tagname });
  }
}
