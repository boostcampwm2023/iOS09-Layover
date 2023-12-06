import { BoardService } from './board.service';
import { Test, TestingModule } from '@nestjs/testing';
import { MemberService } from '../member/member.service';
import { TagService } from '../tag/tag.service';
import { BoardRepository } from './board.repository';
import { createBoardDto, savedBoard } from './board.fixture';
import { CreateBoardResDto } from './dtos/create-board-res.dto';

describe('BoardService', () => {
  let boardService: BoardService;
  const mockBoardRepository = {
    saveBoard: jest.fn(),
  };
  const mockMemberService = {
    findMemberById: jest.fn(),
  };
  const mockTagService = {
    createTag: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        BoardService,
        { provide: BoardRepository, useValue: mockBoardRepository },
        { provide: MemberService, useValue: mockMemberService },
        { provide: TagService, useValue: mockTagService },
      ],
    }).compile();

    boardService = module.get<BoardService>(BoardService);
  });

  it('should be defined', () => {
    expect(boardService).toBeDefined();
  });

  it('게시글 생성 성공', async () => {
    // given
    mockMemberService.findMemberById.mockResolvedValue(savedBoard.member);
    mockBoardRepository.saveBoard.mockResolvedValue(savedBoard);
    mockTagService.createTag.mockResolvedValue([]);

    // when
    const result: CreateBoardResDto = await boardService.createBoard(1, createBoardDto);

    // then
    expect(result).toBeInstanceOf(CreateBoardResDto);
    expect(result).toEqual({
      id: undefined,
      title: createBoardDto.title,
      content: createBoardDto.content,
      latitude: createBoardDto.latitude,
      longitude: createBoardDto.longitude,
      tag: createBoardDto.tag,
    });
  });
});
