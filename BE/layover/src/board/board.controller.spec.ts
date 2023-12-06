import { BoardController } from './board.controller';
import { Test, TestingModule } from '@nestjs/testing';
import { BoardService } from './board.service';
import { tokenPayload } from '../utils/interfaces/token.payload';
import { CustomResponse } from '../response/custom-response';
import { boardsResDto, createBoardDto, createBoardResDto } from './board.fixture';
import { BoardsResDto } from './dtos/boards-res.dto';

describe('BoardController', () => {
  let boardController: BoardController;
  const testPayload: tokenPayload = {
    iss: 'temp',
    exp: 123456789,
    sub: 'temp',
    aud: 'temp',
    nbf: 123456789,
    iat: 123456789,
    jti: 'temp',
    memberHash: 'temp',
    memberId: 1,
  };

  const mockBoardService = {
    createBoard: jest.fn(),
    getBoardRandom: jest.fn(),
    getBoardMap: jest.fn(),
  };

  beforeEach(async () => {
    const app: TestingModule = await Test.createTestingModule({
      controllers: [BoardController],
      providers: [BoardService],
    })
      .overrideProvider(BoardService)
      .useValue(mockBoardService)
      .compile();

    boardController = app.get<BoardController>(BoardController);
  });

  it('should be defined', () => {
    expect(boardController).toBeDefined();
  });

  it('게시글 생성 성공', async () => {
    try {
      // given
      mockBoardService.createBoard.mockResolvedValue(createBoardResDto);

      //when
      await boardController.createBoard(testPayload, createBoardDto);
    } catch (e) {
      //then
      expect(e).toBeInstanceOf(CustomResponse);
      expect(e.data).toEqual({
        id: createBoardResDto.id,
        title: createBoardResDto.title,
        content: createBoardResDto.content,
        latitude: createBoardResDto.latitude,
        longitude: createBoardResDto.longitude,
        tag: createBoardResDto.tag,
      });
    }
  });

  it('홈 화면 게시글 조회 성공', async () => {
    try {
      //given
      mockBoardService.getBoardRandom.mockResolvedValue(boardsResDto);

      //when
      await boardController.getBoardRandom(testPayload);
    } catch (e) {
      //then
      expect(e).toBeInstanceOf(CustomResponse);
      e.data.map((val: BoardsResDto, idx: number) => {
        expect(val.member).toEqual(boardsResDto[idx].member);
        expect(val.board).toEqual(boardsResDto[idx].board);
        expect(val.tag).toEqual(boardsResDto[idx].tag);
      });
    }
  });
});
