import { Board } from './board.entity';
import { Repository } from 'typeorm';
import { Inject } from '@nestjs/common';

export type boardStatus = 'RUNNING' | 'WAITING' | 'FAILURE' | 'COMPLETE' | 'DELETED' | 'INACTIVE';

export class BoardRepository {
  constructor(@Inject('BOARD_REPOSITORY') private boardRepository: Repository<Board>) {}

  async saveBoard(board: Board): Promise<Board> {
    return await this.boardRepository.save(board);
  }

  async countCompletedBoards() {
    return await this.boardRepository.createQueryBuilder('board').where("board.status = 'COMPLETE'").getCount();
  }

  async findBoardsRandomly(itemsPerPage: number, offset: number) {
    return await this.boardRepository
      .createQueryBuilder('board')
      .leftJoinAndSelect('board.member', 'member')
      .leftJoinAndSelect('board.tags', 'tag')
      .where("board.status = 'COMPLETE'")
      .skip(offset)
      .take(itemsPerPage)
      .getMany();
  }

  async findBoardsByMap(latitude: number, longitude: number) {
    return await this.boardRepository
      .createQueryBuilder('board')
      .leftJoinAndSelect('board.member', 'member')
      .leftJoinAndSelect('board.tags', 'tag')
      .where(`ST_Distance_Sphere(point(:longitude, :latitude), point(board.longitude, board.latitude)) < :distance`, {
        longitude,
        latitude,
        distance: 10000, // 10km
      })
      .andWhere("board.status = 'COMPLETE'")
      .getMany();
  }

  async findBoardsByTag(tag: string, itemsPerPage: number, offset: number) {
    return await this.boardRepository
      .createQueryBuilder('board')
      .leftJoinAndSelect('board.member', 'member')
      .leftJoinAndSelect('board.tags', 'tag')
      .where('tag.tagname = :tag', { tag })
      .andWhere("board.status = 'COMPLETE'")
      .skip(offset)
      .take(itemsPerPage)
      .getMany();
  }

  async findBoardsByIds(boardIds: number[]) {
    return await this.boardRepository
      .createQueryBuilder('board')
      .leftJoinAndSelect('board.member', 'member')
      .leftJoinAndSelect('board.tags', 'tag')
      .whereInIds(boardIds)
      .getMany();
  }

  async findBoardsByProfile(id: number, itemsPerPage: number, offset: number) {
    return await this.boardRepository
      .createQueryBuilder('board')
      .leftJoinAndSelect('board.member', 'member')
      .leftJoinAndSelect('board.tags', 'tag')
      .where("board.status = 'COMPLETE'")
      .andWhere('member.id = :id', { id })
      .skip(offset)
      .take(itemsPerPage)
      .getMany();
  }

  async findOneById(id: number) {
    return await this.boardRepository.findOne({ where: { id: id } });
  }

  async updateStatusById(id: number, status: string) {
    await this.boardRepository.update({ id: id }, { status: status });
  }

  async updateStatusByFilename(filename: string, status: string) {
    await this.boardRepository.update({ filename: filename }, { status: status });
  }

  async updateEncodedVideoUrlByFilename(filename: string, encoded_video_url: string) {
    await this.boardRepository.update({ filename: filename }, { encoded_video_url: encoded_video_url });
  }

  async updateBoardsStatusByMemberId(id: number, status: boardStatus) {
    await this.boardRepository.update({ member: { id: id } }, { status: status });
  }
}
