import { Inject, Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { Board } from './board.entity';
import { MemberService } from '../member/member.service';
import { Member } from '../member/member.entity';
import { MemberInfosResDto } from '../member/dtos/member-infos-res.dto';
import { BoardResDto } from './dtos/board-res-dto';
import { TagService } from '../tag/tag.service';
import { BoardsResDto } from './dtos/boards-res.dto';
import { CreateBoardResDto } from './dtos/create-board-res.dto';
import { makeDownloadPreSignedUrl } from '../utils/s3Utils';

@Injectable()
export class BoardService {
  constructor(
    @Inject('BOARD_REPOSITORY') private boardRepository: Repository<Board>,
    private memberService: MemberService,
    private tagService: TagService,
  ) {}

  async createBoard(userId: number, title: string, content: string, latitude: number, longitude: number, tag: string[]): Promise<CreateBoardResDto> {
    const member: Member = await this.memberService.findMemberById(userId);

    const savedBoard: Board = await this.boardRepository.save({
      member: member,
      title: title,
      content: content ?? '',
      encoded_video_url: '',
      latitude: latitude,
      longitude: longitude,
      filename: '',
      status: 'WAITING',
    });
    if (tag) {
      tag.map(async (tagname) => {
        await this.tagService.saveTag(savedBoard, tagname);
      });
    }

    return new CreateBoardResDto(savedBoard.id, title, content, latitude, longitude, tag);
  }

  async getBoardRandom() {
    // 성공한것만 가져온다.
    const limit = await this.boardRepository.createQueryBuilder('board').where("board.status = 'COMPLETE'").getCount();
    let random = Math.floor(Math.random() * limit);
    const n = 10; // 최대 10개 데이터를 가져온다.

    // 데이터가 10개 이하라면 첫번째 데이터부터 가져옴.
    if (random < 10) {
      random = 0;
    } else if (limit - random < 10) {
      random = limit - 10;
    }

    const boards: Board[] = await this.boardRepository
      .createQueryBuilder('board')
      .leftJoinAndSelect('board.member', 'member')
      .leftJoinAndSelect('board.tags', 'tag')
      .where("board.status = 'COMPLETE'")
      .skip(random)
      .take(n)
      .getMany();

    return Promise.all(boards.map((board) => this.createBoardResDto(board)));
  }

  async createBoardResDto(board: Board): Promise<BoardsResDto> {
    const member = new MemberInfosResDto(board.member.id, board.member.username, board.member.introduce, board.member.profile_image_key);
    const videoThumbnailUrl = makeDownloadPreSignedUrl(
      process.env.NCLOUD_S3_THUMBNAIL_BUCKET_NAME,
      `${process.env.HLS_ENCODING_PATH}/${board.filename}_01.jpg`,
    );
    const boardInfo = new BoardResDto(
      board.id,
      board.encoded_video_url,
      videoThumbnailUrl,
      board.latitude,
      board.longitude,
      board.title,
      board.content,
      board.status,
    );
    const tag = board.tags.map((tag) => tag.tagname);
    return new BoardsResDto(member, boardInfo, tag);
  }

  async getBoardMap(lat: string, lon: string) {
    const latitude = parseFloat(lat);
    const longitude = parseFloat(lon);

    const boards: Board[] = await this.boardRepository
      .createQueryBuilder('board')
      .leftJoinAndSelect('board.member', 'member')
      .leftJoinAndSelect('board.tags', 'tag')
      .where(`ST_Distance_Sphere(point(:longitude, :latitude), point(board.longitude, board.latitude)) < :distance`, {
        longitude,
        latitude,
        distance: 500000, // 100km
      })
      .andWhere("board.status = 'COMPLETE'")
      .getMany();

    return Promise.all(boards.map((board) => this.createBoardResDto(board)));
  }

  async getBoardTag(tag: string, page: number) {
    const itemsPerPage = 15;
    const offset = (page - 1) * itemsPerPage;

    const boards: Board[] = await this.boardRepository
      .createQueryBuilder('board')
      .leftJoinAndSelect('board.member', 'member')
      .leftJoinAndSelect('board.tags', 'tag')
      .where('tag.tagname = :tag', { tag })
      .andWhere("board.status = 'COMPLETE'")
      .skip(offset)
      .take(itemsPerPage)
      .getMany();

    const boardIds = boards.map((board) => board.id);

    const allBoards: Board[] = await this.boardRepository
      .createQueryBuilder('board')
      .leftJoinAndSelect('board.member', 'member')
      .leftJoinAndSelect('board.tags', 'tag')
      .whereInIds(boardIds)
      .getMany();

    return Promise.all(allBoards.map((board) => this.createBoardResDto(board)));
  }

  async getBoardProfile(id: number, page: number) {
    const itemsPerPage = 15;
    const offset = (page - 1) * itemsPerPage;

    const boards: Board[] = await this.boardRepository
      .createQueryBuilder('board')
      .leftJoinAndSelect('board.member', 'member')
      .leftJoinAndSelect('board.tags', 'tag')
      .where("board.status = 'COMPLETE'")
      .andWhere('member.id = :id', { id })
      .skip(offset)
      .take(itemsPerPage)
      .getMany();
    return Promise.all(boards.map((board) => this.createBoardResDto(board)));
  }

  async setEncodedVideoUrl(filename: string) {
    const board: Board = await this.boardRepository.findOne({ where: { filename } });
    board.encoded_video_url = this.generateEncodedVideoHLS(filename);
    await this.boardRepository.save(board);
  }

  async saveFilenameById(id: number, filename: string) {
    const board: Board = await this.boardRepository.findOne({ where: { id } });
    board.filename = filename;
    await this.boardRepository.save(board);
  }

  generateEncodedVideoHLS(filename: string) {
    return `${process.env.HLS_SCHEME}${process.env.HLS_ENCODING_CDN}/hls/${process.env.HLS_ENCODING_BUCKET_ENCRYPTED_NAME}
    /${process.env.HLS_ENCODING_PATH}/${filename}_AVC_,HD,SD,_1Pass_30fps.mp4.smil/master.m3u8`;
  }

  async setStatusByFilename(filename: string, status: string) {
    await this.boardRepository.update({ filename }, { status });
  }

  async findBoardById(id: number): Promise<Board> {
    return await this.boardRepository.findOne({ where: { id } });
  }

  async deleteBoard(boardId: string) {
    await this.boardRepository.update({ id: parseInt(boardId) }, { status: 'DELETED' });
  }
}
