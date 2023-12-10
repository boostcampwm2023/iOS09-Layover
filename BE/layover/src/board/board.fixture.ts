import { CreateBoardResDto } from './dtos/create-board-res.dto';
import { CreateBoardDto } from './dtos/create-board.dto';
import { BoardsResDto } from './dtos/boards-res.dto';
import { MemberInfosResDto } from '../member/dtos/member-infos-res.dto';
import { BoardResDto } from './dtos/board-res-dto';
import { Board } from './board.entity';
import { Member } from '../member/member.entity';

/**
 * @description
 * BoardController 에 사용되는 fixtures
 */

export const createBoardResDto: CreateBoardResDto = new CreateBoardResDto(1, '제목', '내용', 37.1231053, 127.1231053, [
  '부산',
  '광안리',
  '바다',
]);
export const createBoardDto: CreateBoardDto = new CreateBoardDto('제목', '내용', 37.1231053, 127.1231053, [
  '부산',
  '광안리',
  '바다',
]);

export const boardsResDto: BoardsResDto[] = [
  new BoardsResDto(
    new MemberInfosResDto(1, '이름', '이메일', '프로필사진'),
    new BoardResDto(1, '제목', '내용', 37.1231053, 127.1231053, '비디오url', '썸네일url', '태그'),
    ['태그1', '태그2'],
  ),
  new BoardsResDto(
    new MemberInfosResDto(2, '이름2', '이메일2', '프로필사진2'),
    new BoardResDto(2, '제목2', '내용2', 37.1231053, 127.1231053, '비디오url2', '썸네일url2', '태그2'),
    ['태그3', '태그4'],
  ),
  new BoardsResDto(
    new MemberInfosResDto(3, '이름3', '이메일3', '프로필사진3'),
    new BoardResDto(3, '제목3', '내용3', 37.1231053, 127.1231053, '비디오url3', '썸네일url3', '태그3'),
    ['태그5', '태그6'],
  ),
];

/**
 * @description
 * BoardService 에 사용되는 fixtures
 */

export const savedBoard: Board = new Board(
  new Member(1, '이름', '프로필사진', '소개', 'provider', 'hash', new Date(), 'EXIST'),
  '제목',
  '내용',
  '비디오url',
  37.1231053,
  127.1231053,
  '썸네일url',
  'WAITING',
);
