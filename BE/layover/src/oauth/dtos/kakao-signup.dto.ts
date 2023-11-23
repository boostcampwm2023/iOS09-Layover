import { ApiProperty } from '@nestjs/swagger';

export class KakaoSignupDto {
  @ApiProperty({
    example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9',
    description: '카카오 액세스 토큰',
  })
  readonly accessToken: string;

  @ApiProperty({
    example: 'myUsername',
    description: '설정할 유저 닉네임',
  })
  readonly username: string;
}
