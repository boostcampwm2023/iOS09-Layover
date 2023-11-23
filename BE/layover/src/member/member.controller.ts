import { Controller, HttpStatus, Post } from '@nestjs/common';
import { CheckUsernameDto } from './dtos/check-username.dto';
import { MemberService } from './member.service';
import {
  ApiOperation,
  ApiResponse,
  ApiTags,
  getSchemaPath,
} from '@nestjs/swagger';
import { CheckUsernameResDto } from './dtos/check-username-res.dto';

@ApiTags('Member API')
@Controller('member')
export class MemberController {
  constructor(private readonly memberService: MemberService) {}

  @ApiOperation({
    summary: '닉네임 검증(중복, 길이 확인)',
    description: '닉네임 검증을 수행합니다.',
  })
  @ApiResponse({
    status: HttpStatus.OK,
    description: '닉네임 검증 결과',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'SUCCESS' },
        message: { type: 'boolean', example: '성공' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(CheckUsernameResDto) },
      },
    },
  })
  @Post('username')
  checkUsername(usernameDto: CheckUsernameDto) {
    return !(
      this.memberService.isUsernameLong(usernameDto.username) ||
      this.memberService.isExistUsername(usernameDto.username)
    );
  }
}
