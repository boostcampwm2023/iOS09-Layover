import { ApiProperty } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';

export class CreateBoardDto {
  @ApiProperty({
    example: '부산 광안리',
    description: '제목',
  })
  readonly title: string;

  @ApiProperty({
    example: 'chilling at the beach~',
    description: '내용',
    required: false,
  })
  @IsString()
  @IsOptional()
  content?: string;

  @ApiProperty({
    example: '37.0532156213',
    description: '게시글 위도',
  })
  latitude: number;

  @ApiProperty({
    example: '37.0532156213',
    description: '게시글 경도',
  })
  longitude: number;

  @ApiProperty({
    example: ['부산', '광안리', '바다'],
    description: '사용자가 작성한 태그들',
    required: false,
  })
  @IsOptional()
  tag?: string[];

  constructor(title: string, content: string, latitude: number, longitude: number, tag: string[]) {
    this.title = title;
    this.content = content;
    this.latitude = latitude;
    this.longitude = longitude;
    this.tag = tag;
  }
}
