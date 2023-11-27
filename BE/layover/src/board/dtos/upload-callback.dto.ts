import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';

export class UploadCallbackDto {
  @ApiProperty({
    example: 'sample.mp4',
    description: '업로드된 원본 파일 이름',
  })
  @IsString()
  readonly filename: string;
}
