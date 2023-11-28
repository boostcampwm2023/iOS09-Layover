import { ApiProperty } from '@nestjs/swagger';

export class ProfilePresignedUrlResDto {
  @ApiProperty({
    example: 'https://abcde.fghi',
    description: '이미지를 업로드할 presigned url',
  })
  preSignedUrl: string;

  constructor(preSignedUrl: string) {
    this.preSignedUrl = preSignedUrl;
  }
}
