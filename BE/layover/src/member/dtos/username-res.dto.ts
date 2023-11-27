import { ApiProperty } from '@nestjs/swagger';

export class UsernameResDto {
  @ApiProperty({
    example: 'hwani2',
    description: '변경된 닉네임 값',
  })
  username: string;

  constructor(username: string) {
    this.username = username;
  }
}
