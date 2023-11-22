import { ApiProperty } from '@nestjs/swagger';

export class AppleLoginDto {
  @ApiProperty({
    example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9',
    description: '애플 아이덴티티 토큰',
  })
  readonly identityToken: string;
}
