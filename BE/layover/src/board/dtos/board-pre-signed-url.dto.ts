import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsNumber, IsString } from 'class-validator';

export class BoardPreSignedUrlDto {
  @ApiProperty({
    example: 1,
    description: '업로드할 동영상의 게시글 id',
  })
  @IsNumber()
  @IsNotEmpty()
  readonly boardId: number;

  @ApiProperty({
    example: 'mp4',
    description: '업로드할 동영상 타입',
  })
  @IsString()
  @IsNotEmpty()
  readonly filetype: string;
}
