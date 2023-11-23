import { ApiProperty } from '@nestjs/swagger';

export class CheckUsernameDto {
  @ApiProperty({
    example: 'hwani',
    description: '유효성을 검증하거나 변경하고자 하는 닉네임',
  })
  readonly username: string;
}
