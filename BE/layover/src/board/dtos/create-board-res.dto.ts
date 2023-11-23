import { ApiProperty } from '@nestjs/swagger';

export class CreateBoardResDto {
  @ApiProperty({
    example: 1,
    description: '게시글 id',
  })
  readonly id: number;

  constructor(id: number) {
    this.id = id;
  }
}
