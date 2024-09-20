import { ApiProperty } from '@nestjs/swagger';

export class IntroduceDto {
  @ApiProperty({
    example: 'Hi, my name is hwani',
    description: '새로운 자기소개',
  })
  readonly introduce: string;
}
