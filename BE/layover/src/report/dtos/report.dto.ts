import { ApiProperty } from '@nestjs/swagger';

export class ReportDto {
  @ApiProperty({
    example: 5,
    description: '신고 게시글 id',
  })
  readonly boardId: number;

  @ApiProperty({
    example: '청소년에게 유해한 내용이에요',
    description: '신고 유형',
  })
  readonly reportType: string;
}
