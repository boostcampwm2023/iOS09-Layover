import { ApiProperty } from '@nestjs/swagger';

export class CheckUsernameResDto {
  @ApiProperty({
    example: 'true',
    description: '닉네임 검증 결과 bool 값',
  })
  exist: boolean;

  constructor(exist: boolean) {
    this.exist = exist;
  }
}
