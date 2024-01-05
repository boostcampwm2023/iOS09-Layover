import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';

export class EncodingCallbackDto {
  @ApiProperty({
    example: 'uusu123135131-123143ads-213',
    description: '동영상 파일 이름',
  })
  @IsString()
  readonly filename: string;

  @ApiProperty({
    example: 'RUNNING',
    description: '입력 파일의 인코딩 상태',
  })
  @IsString()
  readonly status: string;

  @ApiProperty({
    example: 'ncloud.video.download.com/sfsdsdsdsfsd',
    description: 'm3u8 master 링크',
  })
  readonly filePath?: string;
}
