import { ApiProperty } from '@nestjs/swagger';

export class PresignedUrlDto {
  @ApiProperty({
    example: 'myVideo',
    description: '업로드할 동영상 이름',
  })
  readonly filename: string;

  @ApiProperty({
    example: 'mp4',
    description: '업로드할 동영상 타입',
  })
  readonly filetype: string;
}
