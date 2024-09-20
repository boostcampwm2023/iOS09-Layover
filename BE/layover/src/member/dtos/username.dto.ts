import { ApiProperty } from '@nestjs/swagger';

export class UsernameDto {
  @ApiProperty({
    example: 'hwani1',
    description: '변경 변경하고자 하는 닉네임',
  })
  readonly username: string;
}
