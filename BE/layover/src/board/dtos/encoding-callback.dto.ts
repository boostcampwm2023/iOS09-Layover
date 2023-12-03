import { ApiProperty } from '@nestjs/swagger';
import { IsNumber, IsString } from 'class-validator';

export class EncodingCallbackDto {
  @ApiProperty({
    example: 10628,
    description: '인코딩 카테고리 ID',
  })
  @IsNumber()
  readonly categoryId: number;

  @ApiProperty({
    example: 'callback-test',
    description: '인코딩 카테고리 이름',
  })
  @IsString()
  readonly categoryName: string;

  @ApiProperty({
    example: 10808,
    description: '입력 파일 ID',
  })
  @IsNumber()
  readonly fileId: number;

  @ApiProperty({
    example: '/.../Guide720_AVC_HD_1Pass_30fps.mp4',
    description: '입력 파일 경로',
  })
  @IsString()
  readonly filePath: string;

  @ApiProperty({
    example: 1,
    description: '인코딩 옵션 ID',
  })
  @IsNumber()
  readonly encodingOptionId: number;

  @ApiProperty({
    example: 'AVC_HD_1Pass_30fps',
    description: '출력 인코딩 옵션 이름',
  })
  @IsString()
  readonly outputType: string;

  @ApiProperty({
    example: 'RUNNING',
    description: '입력 파일의 인코딩 상태',
  })
  @IsString()
  readonly status: string;
}
