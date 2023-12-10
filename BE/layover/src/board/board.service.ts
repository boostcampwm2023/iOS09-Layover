import { Injectable } from '@nestjs/common';
import { Board } from './board.entity';
import { MemberService } from '../member/member.service';
import { Member } from '../member/member.entity';
import { MemberInfosResDto } from '../member/dtos/member-infos-res.dto';
import { BoardResDto } from './dtos/board-res-dto';
import { TagService } from '../tag/tag.service';
import { BoardsResDto } from './dtos/boards-res.dto';
import { CreateBoardResDto } from './dtos/create-board-res.dto';
import { generateDownloadPreSignedUrl } from '../utils/s3Utils';
import { CreateBoardDto } from './dtos/create-board.dto';
import { BoardRepository, boardStatus } from './board.repository';
import { EncodingCallbackDto } from './dtos/encoding-callback.dto';

@Injectable()
export class BoardService {
  constructor(
    private boardRepository: BoardRepository,
    private memberService: MemberService,
    private tagService: TagService,
  ) {}

  async createBoard(userId: number, createBoardDto: CreateBoardDto): Promise<CreateBoardResDto> {
    const member: Member = await this.memberService.getMemberById(userId);
    createBoardDto.content = createBoardDto.content ?? '';

    const savedBoard: Board = await this.boardRepository.saveBoard(
      new Board(
        member,
        createBoardDto.title,
        createBoardDto.content,
        '',
        createBoardDto.latitude,
        createBoardDto.longitude,
        '',
        'WAITING',
      ),
    );

    if (createBoardDto.tag) {
      await Promise.all(
        createBoardDto.tag.map(async (tagname) => {
          await this.tagService.createTag(savedBoard, tagname);
        }),
      );
    }

    return new CreateBoardResDto(
      savedBoard.id,
      savedBoard.title,
      savedBoard.content,
      savedBoard.latitude,
      savedBoard.longitude,
      createBoardDto.tag ?? [],
    );
  }

  async getBoardsRandomly() {
    // 성공한것만 가져온다.
    const limit: number = await this.boardRepository.countCompletedBoards();
    let offset: number = Math.floor(Math.random() * limit);
    const itemsPerPage = 10; // 최대 10개 데이터를 가져온다.

    // 데이터가 10개 이하라면 첫번째 데이터부터 가져옴.
    if (offset < 10) {
      offset = 0;
    } else if (limit - offset < 10) {
      offset = limit - 10;
    }

    const boards: Board[] = await this.boardRepository.findBoardsRandomly(itemsPerPage, offset);
    return Promise.all(boards.map((board: Board) => this.createBoardResDto(board)));
  }

  async createBoardResDto(board: Board): Promise<BoardsResDto> {
    let preSignedUrl: string | null;
    if (board.member.profile_image_key !== 'default')
      preSignedUrl = generateDownloadPreSignedUrl(
        process.env.NCLOUD_S3_PROFILE_BUCKET_NAME,
        board.member.profile_image_key,
      );
    else preSignedUrl = null;
    const member = new MemberInfosResDto(board.member.id, board.member.username, board.member.introduce, preSignedUrl);
    const videoThumbnailUrl = generateDownloadPreSignedUrl(
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
    const tag = board.tags ? board.tags.map((tag) => tag.tagname) : [];
    return new BoardsResDto(member, boardInfo, tag);
  }

  async getBoardsByMap(lat: string, lon: string) {
    const latitude: number = parseFloat(lat);
    const longitude: number = parseFloat(lon);
    const boards: Board[] = await this.boardRepository.findBoardsByMap(latitude, longitude);
    return Promise.all(boards.map((board) => this.createBoardResDto(board)));
  }

  async getBoardsByTag(tag: string, page: number) {
    const itemsPerPage = 15;
    const offset = (page - 1) * itemsPerPage;

    const boards: Board[] = await this.boardRepository.findBoardsByTag(tag, itemsPerPage, offset);
    const boardIds = boards.map((board) => board.id);
    const allBoards: Board[] = await this.boardRepository.findBoardsByIds(boardIds);
    return Promise.all(allBoards.map((board) => this.createBoardResDto(board)));
  }

  async getBoardsByProfile(id: number, page: number) {
    const itemsPerPage = 15;
    const offset = (page - 1) * itemsPerPage;
    const boards: Board[] = await this.boardRepository.findBoardsByProfile(id, itemsPerPage, offset);
    return Promise.all(boards.map((board) => this.createBoardResDto(board)));
  }

  async updateFilenameById(id: number, filename: string) {
    const board: Board = await this.boardRepository.findOneById(id);
    board.filename = filename;
    await this.boardRepository.saveBoard(board);
  }

  generateEncodedVideoUrl(filename: string) {
    return `${process.env.HLS_SCHEME}${process.env.HLS_ENCODING_CDN}/hls/${process.env.HLS_ENCODING_BUCKET_ENCRYPTED_NAME}
    /${process.env.HLS_ENCODING_PATH}/${filename}_AVC_,FHD,HD,SD,_1Pass_30fps.mp4.smil/master.m3u8`;
  }

  async getBoardById(id: number): Promise<Board> {
    return await this.boardRepository.findOneById(id);
  }

  async deleteBoardById(boardId: number) {
    await this.boardRepository.updateStatusById(boardId, 'DELETED');
  }

  async processByEncodingStatus(encodingCallbackRequestDto: EncodingCallbackDto) {
    const filename = this.parsingFilenameFromFilePath(encodingCallbackRequestDto.filePath);

    //파일명으로 파일을 찾고 해당 파일의 status 를 갱신해준다.
    switch (encodingCallbackRequestDto.status) {
      case 'RUNNING':
        await this.boardRepository.updateStatusByFilename(filename, 'RUNNING');
        break;
      case 'FAILURE':
        await this.boardRepository.updateStatusByFilename(filename, 'FAILURE');
        break;
      case 'COMPLETE':
        await this.boardRepository.updateStatusByFilename(filename, 'COMPLETE');
        await this.boardRepository.updateEncodedVideoUrlByFilename(filename, this.generateEncodedVideoUrl(filename));
        break;
    }
  }

  async updateBoardsStatusByMemberId(id: number, fromStatus: boardStatus, toStatus: boardStatus) {
    await this.boardRepository.updateBoardsStatusByMemberId(id, fromStatus, toStatus);
  }

  parsingFilenameFromFilePath(filePath: string) {
    const regExp = /^\/layover-station\/(.*?)(_AVC.*?)\.mp4$/;
    return filePath.match(regExp)[1];
  }
}
