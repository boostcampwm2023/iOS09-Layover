import { ApiProperty } from '@nestjs/swagger';

export class ProfilePresignedUrlDto {
  @ApiProperty({
    example: `{
      filetype: "jpeg"
    }`,
    description: '업로드할 영상 이름과 타입',
  })
  readonly filetype: string;
}
