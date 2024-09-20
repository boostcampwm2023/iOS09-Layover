import { Injectable } from '@nestjs/common';
import { Board } from '../board/board.entity';
import { TagRepository } from './tag.repository';

@Injectable()
export class TagService {
  constructor(private tagRepository: TagRepository) {}

  async createTag(board: Board, tagname: string): Promise<void> {
    await this.tagRepository.saveTag(board, tagname);
  }
}
