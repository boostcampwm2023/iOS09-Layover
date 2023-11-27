import { ApiProperty } from '@nestjs/swagger';

export class IntroduceResDto {
  @ApiProperty({
    example: 'Hi, my name is hwani',
    description: '새로운ㄴ 자기소개',
  })
  introduce: string;

  constructor(introduce: string) {
    this.introduce = introduce;
  }
}
