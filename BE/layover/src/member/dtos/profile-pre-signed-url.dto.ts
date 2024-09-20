import { ApiProperty } from '@nestjs/swagger';

export class ProfilePreSignedUrlDto {
  @ApiProperty({
    example: 'jpeg',
    description: '업로드할 영상 이름과 타입',
  })
  readonly filetype: string;
}
