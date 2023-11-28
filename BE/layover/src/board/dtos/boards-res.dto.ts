import { MemberInfosResDto } from '../../member/dtos/member-infos-res.dto';
import { BoardResDto } from './board-res-dto';
import { ApiProperty } from '@nestjs/swagger';

export class BoardsResDto {
  @ApiProperty({ type: () => MemberInfosResDto })
  member: MemberInfosResDto;

  @ApiProperty({ type: () => BoardResDto })
  board: BoardResDto;

  @ApiProperty({
    example: ['tag1', 'tag2'],
    description: '게시글의 태그',
  })
  tag: string[];
}
