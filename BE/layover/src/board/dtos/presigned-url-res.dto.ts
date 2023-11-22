import { ApiProperty } from '@nestjs/swagger';

export class PresignedUrlResDto {
  @ApiProperty({
    example: 'someUrl',
    description: '동영상을 업로드 하기 위해 요청할 링크',
  })
  readonly presignedUrl: string;

  constructor(presignedUrl: string) {
    this.presignedUrl = presignedUrl;
  }
}
