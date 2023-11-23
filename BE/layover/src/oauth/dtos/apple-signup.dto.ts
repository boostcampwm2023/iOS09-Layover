import { ApiProperty } from '@nestjs/swagger';

export class AppleSignupDto {
  @ApiProperty({
    example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9',
    description: '애플 아이덴티티 토큰',
  })
  readonly identityToken: string;

  @ApiProperty({
    example: 'myUsername',
    description: '설정할 유저 닉네임',
  })
  readonly username: string;
}
