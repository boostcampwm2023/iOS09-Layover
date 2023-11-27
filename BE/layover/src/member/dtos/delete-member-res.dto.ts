import { ApiProperty } from '@nestjs/swagger';

export class DeleteMemberResDto {
  @ApiProperty({
    example: 'hooni',
    description: '삭제된 멤버의 닉네임',
  })
  username: string;

  constructor(username: string) {
    this.username = username;
  }
}
