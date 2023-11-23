import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';

export class CreateBoardDto {
  @ApiProperty({
    example: '부산 광안리',
    description: '제목',
  })
  readonly title: string;

  @ApiProperty({
    example: 'chilling at the beach~',
    description: '내용',
  })
  @IsString()
  @IsNotEmpty()
  readonly content: string;

  @ApiProperty({
    example: '37.0213513391321',
    description: '위치',
  })
  @IsString()
  @IsNotEmpty()
  readonly location: string;
}
