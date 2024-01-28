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
import { all } from 'axios';

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

  async findBoardsRandomly(itemsPerPage: number) {
    // complete 인 값을 모두 가져옴
    const boards: Board[] = await this.boardRepository.getAllCompleteVideo();

    // 랜덤 인덱스를 하나 고른다.
    let randomIdx: number = Math.floor(Math.random() * boards.length);

    // 데이터는 항상 10개 이상 존재한다고 가정.
    // 해당 랜덤 인덱스부터 10개의 데이터가 있는지 확인하고 처리한다.
    if (randomIdx + 10 > boards.length) {
      randomIdx -= randomIdx + 10 - boards.length;
    }

    // 해당 객체의 id를 return 해준다.
    return boards.slice(randomIdx, randomIdx + itemsPerPage);
  }

  async getBoardsHome(cursor: number) {
    // 성공한것만 가져온다.
    console.log('enter service layer');
    const itemsPerPage = 10; // 최대 10개 데이터를 가져온다.

    const boards: Board[] =
      cursor === -1
        ? await this.findBoardsRandomly(itemsPerPage)
        : await this.boardRepository.findBoardsHome(itemsPerPage, cursor);

    console.log(boards);
    // 해당 커서로부터 일정 개수의 데이터 가져오기
    const lastId = boards[boards.length - 1].id;
    boards.map((board: Board) => {
      console.log(board.id);
    });

    // 배열 섞기 (우선 보류)

    const boardsResDto: BoardsResDto[] = await Promise.all(boards.map((board: Board) => this.createBoardResDto(board)));
    return {
      lastId: lastId,
      boardsResDto,
    };
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
      `${process.env.HLS_ENCODING_PATH}/${board.filename}.jpg`,
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

  // 인코딩 되기전, 되는 중 상태 게시글도 가져온다.
  async getBoardsByMap(lat: string, lon: string) {
    const latitude: number = parseFloat(lat);
    const longitude: number = parseFloat(lon);
    const boards: Board[] = await this.boardRepository.findBoardsByMap(latitude, longitude);
    return Promise.all(boards.map((board) => this.createBoardResDto(board)));
  }

  async getBoardsByTag(tag: string, cursor: number) {
    const itemsPerPage = 15;
    let boards: Board[];

    // cursor 값이 없을 경우 -> 최근 데이터 15개 가져오기
    if (cursor === undefined) {
      boards = await this.boardRepository.findBoardsByTag(tag, itemsPerPage);
    } else {
      // cursor 값이 있을 경우 -> 해당 id 보다 작은 아이디 15개 limit 가져오기
      boards = await this.boardRepository.findBoardsByTagWithCursor(tag, itemsPerPage, cursor);
    }
    // 가장 끝의 id를 cursor 로 반환해줘야함.
    const boardIds = boards.map((board) => board.id);
    const lastId = boardIds[-1];
    const allBoards: Board[] = await this.boardRepository.findBoardsByIds(boardIds);
    const boardsResDto: BoardsResDto[] = await Promise.all(allBoards.map((board) => this.createBoardResDto(board)));
    return {
      lastId: lastId,
      boardsResDto,
    };
  }

  async getBoardsByProfile(id: number, cursor: number) {
    const itemsPerPage = 15;
    let boards: Board[];

    if (cursor === undefined) {
      boards = await this.boardRepository.findBoardsByProfile(id, itemsPerPage);
    } else {
      boards = await this.boardRepository.findBoardsByProfileWithCursor(id, itemsPerPage, cursor);
    }

    const lastId = boards[-1].id;

    const boardsResDto: BoardsResDto[] = await Promise.all(boards.map((board) => this.createBoardResDto(board)));
    // 가장 끝의 id를 cursor 로 반환해줘야함.
    return {
      lastId: lastId,
      boardsResDto,
    };
  }

  async updateFilenameById(id: number, filename: string) {
    const board: Board = await this.boardRepository.findOneById(id);
    board.filename = filename;
    await this.boardRepository.saveBoard(board);
  }

  async getBoardById(id: number): Promise<Board> {
    return await this.boardRepository.findOneById(id);
  }

  async deleteBoardById(boardId: number) {
    await this.boardRepository.updateStatusById(boardId, 'DELETED');
  }

  async processByEncodingStatus(encodingCallbackRequestDto: EncodingCallbackDto) {
    //파일명으로 파일을 찾고 해당 파일의 status 를 갱신해준다.
    switch (encodingCallbackRequestDto.status) {
      case 'RUNNING':
        await this.boardRepository.updateStatusByFilename(encodingCallbackRequestDto.filename, 'RUNNING');
        break;

      case 'FAILURE':
        await this.boardRepository.updateStatusByFilename(encodingCallbackRequestDto.filename, 'FAILURE');
        break;

      case 'COMPLETE': // cloud function 에서 인코딩을 성공적으로 끝냈을 때
        await this.boardRepository.updateStatusByFilename(encodingCallbackRequestDto.filename, 'COMPLETE');
        await this.boardRepository.updateEncodedVideoUrlByFilename(
          encodingCallbackRequestDto.filename,
          encodingCallbackRequestDto.filePath,
        );
        break;
    }
  }

  async updateBoardsStatusByMemberId(id: number, fromStatus: boardStatus, toStatus: boardStatus) {
    await this.boardRepository.updateBoardsStatusByMemberId(id, fromStatus, toStatus);
  }
}
