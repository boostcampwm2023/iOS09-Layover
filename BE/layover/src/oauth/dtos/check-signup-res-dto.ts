import { ApiProperty } from '@nestjs/swagger';

export class CheckSignupResDto {
  @ApiProperty({
    example: 'true',
    description: '해당 계정이 이미 존재하는지 여부 boolean 값',
  })
  isAlreadyExist: boolean;

  constructor(isAlreadyExist: boolean) {
    this.isAlreadyExist = isAlreadyExist;
  }
}
