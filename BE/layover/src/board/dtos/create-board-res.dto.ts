import { ApiProperty } from '@nestjs/swagger';

export class CreateBoardResDto {
  @ApiProperty({
    example: 1,
    description: '게시글 id',
  })
  readonly id: number;

  @ApiProperty({
    example: '제목',
    description: '게시글 제목',
  })
  readonly title: string;

  @ApiProperty({
    example: '내용',
    description: '게시글 내용',
  })
  readonly content: string;

  @ApiProperty({
    example: '37.12310530',
    description: '위도',
  })
  readonly latitude: string;

  @ApiProperty({
    example: '127.12310530',
    description: '경도',
  })
  readonly longitude: string;

  @ApiProperty({
    example: ['부산', '광안리', '바다'],
    description: '사용자가 작성한 태그들',
  })
  readonly tag: string[];

  constructor(id: number, title: string, content: string, latitude: string, longitude: string, tag: string[]) {
    this.id = id;
    this.title = title;
    this.content = content;
    this.latitude = latitude;
    this.longitude = longitude;
    this.tag = tag;
  }
}
