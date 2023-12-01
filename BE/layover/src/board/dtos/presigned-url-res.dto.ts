import { ApiProperty } from '@nestjs/swagger';

export class PresignedUrlResDto {
  @ApiProperty({
    example: 'https://layover-original-video.s3.amazonaws.com/14bb1a79093f5b9443e9b8105.....',
    description: '동영상을 업로드 하기 위해 요청할 링크',
  })
  readonly presignedUrl: string;

  constructor(presignedUrl: string) {
    this.presignedUrl = presignedUrl;
  }
}
