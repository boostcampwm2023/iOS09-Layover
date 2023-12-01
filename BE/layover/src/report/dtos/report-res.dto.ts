import { ApiProperty } from '@nestjs/swagger';

export class ReportResDto {
  @ApiProperty({
    example: 221,
    description: '신고한 멤버의 id',
  })
  memberId: number;

  @ApiProperty({
    example: 5,
    description: '신고 게시글 id',
  })
  boardId: number;

  @ApiProperty({
    example: '청소년에게 유해한 내용이에요',
    description: '신고 유형',
  })
  reportType: string;

  constructor(memberId: number, boardId: number, reportType: string) {
    this.memberId = memberId;
    this.boardId = boardId;
    this.reportType = reportType;
  }
}
