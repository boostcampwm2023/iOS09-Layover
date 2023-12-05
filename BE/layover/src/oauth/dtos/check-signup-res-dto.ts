import { ApiProperty } from '@nestjs/swagger';

export class CheckSignupResDto {
  @ApiProperty({
    example: 'true',
    description: '회원가입 여부 확인 결과 bool 값',
  })
  isValid: boolean;

  constructor(isValid: boolean) {
    this.isValid = isValid;
  }
}
