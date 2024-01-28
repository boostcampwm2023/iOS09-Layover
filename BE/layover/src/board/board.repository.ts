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

  async getLastId() {
    const lastRow = await this.boardRepository
      .createQueryBuilder('board')
      .select('board.id')
      .where("board.status = 'COMPLETE'")
      .orderBy('board.id', 'DESC')
      .limit(1)
      .getOne();

    return lastRow.id;
  }

  async getAllCompleteVideo() {
    return await this.boardRepository
      .createQueryBuilder('board')
      .leftJoinAndSelect('board.member', 'member')
      .leftJoinAndSelect('board.tags', 'tag')
      .where("board.status = 'COMPLETE'")
      .getMany();
  }

  async findBoardsHome(itemsPerPage: number, cursor: number) {
    return await this.boardRepository
      .createQueryBuilder('board')
      .leftJoinAndSelect('board.member', 'member')
      .leftJoinAndSelect('board.tags', 'tag')
      .where("board.status = 'COMPLETE'")
      .andWhere('board.id > :id', { id: cursor }) //cursor paging (random 은 id 오름차순으로 가져오기?)
      .take(itemsPerPage)
      .getMany();
  }

  // 인코딩 되기전, 되는 중 상태 게시글도 가져온다.
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
      .andWhere("board.status IN ('COMPLETE', 'WAITING', 'RUNNING')")
      .getMany();
  }

  async findBoardsByTagWithCursor(tag: string, itemsPerPage: number, cursor: number) {
    return await this.boardRepository
      .createQueryBuilder('board')
      .leftJoinAndSelect('board.member', 'member')
      .leftJoinAndSelect('board.tags', 'tag')
      .where('tag.tagname = :tag', { tag })
      .andWhere("board.status = 'COMPLETE'")
      .andWhere('board.id < :id', { id: cursor }) //cursor paging
      .take(itemsPerPage)
      .getMany();
  }
  async findBoardsByTag(tag: string, itemsPerPage: number) {
    return await this.boardRepository
      .createQueryBuilder('board')
      .leftJoinAndSelect('board.member', 'member')
      .leftJoinAndSelect('board.tags', 'tag')
      .where('tag.tagname = :tag', { tag })
      .andWhere("board.status = 'COMPLETE'")
      .orderBy('board.date_created', 'DESC') // cursor 가 있을 경우에는 필요 없을듯 (없으면 DESC 로 itemsPerPage 가져오기)
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

  async findBoardsByProfileWithCursor(id: number, itemsPerPage: number, cursor: number) {
    return await this.boardRepository
      .createQueryBuilder('board')
      .leftJoinAndSelect('board.member', 'member')
      .leftJoinAndSelect('board.tags', 'tag')
      .where('member.id = :id', { id })
      .andWhere("board.status IN ('COMPLETE', 'WAITING', 'RUNNING')")
      .andWhere('board.id < :id', { id: cursor }) //cursor paging
      .take(itemsPerPage)
      .getMany();
  }

  async findBoardsByProfile(id: number, itemsPerPage: number) {
    return await this.boardRepository
      .createQueryBuilder('board')
      .leftJoinAndSelect('board.member', 'member')
      .leftJoinAndSelect('board.tags', 'tag')
      .where('member.id = :id', { id })
      .andWhere("board.status IN ('COMPLETE', 'WAITING', 'RUNNING')")
      .orderBy('board.date_created', 'DESC')
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

  // fromStatus의 상태들을 toStatus로 변경, 복수 데이터를 다루기 때문에 이렇게 조건을 추가
  async updateBoardsStatusByMemberId(id: number, fromStatus: boardStatus, toStatus: boardStatus) {
    const boardToUpdate = await this.boardRepository
      .createQueryBuilder('board')
      .innerJoin('board.member', 'member')
      .where('member.id = :id and board.status = :fromStatus', { id, fromStatus })
      .getOne();

    if (boardToUpdate) {
      boardToUpdate.status = toStatus;
      await this.boardRepository.save(boardToUpdate);
    }
  }
}
