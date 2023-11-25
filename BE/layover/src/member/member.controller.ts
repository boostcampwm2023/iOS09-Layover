import { Body, Controller, HttpStatus, Patch, Post } from '@nestjs/common';
import { CheckUsernameDto } from './dtos/check-username.dto';
import { MemberService } from './member.service';
import {
  ApiOperation,
  ApiResponse,
  ApiTags,
  getSchemaPath,
} from '@nestjs/swagger';
import { CheckUsernameResDto } from './dtos/check-username-res.dto';
import { CustomResponse } from 'src/response/custom-response';
import { ECustomCode } from 'src/response/ecustom-code.jenum';
import { UsernameResDto } from './dtos/username-res.dto';
import { UsernameDto } from './dtos/username.dto';
import { CustomHeader } from 'src/pipes/custom-header.decorator';
import { JwtValidationPipe } from 'src/pipes/jwt.validation.pipe';

@ApiTags('Member API')
@Controller('member')
export class MemberController {
  constructor(private readonly memberService: MemberService) {}

  @ApiOperation({
    summary: '닉네임 검증(중복)',
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
  @Post('check-username')
  async checkUsername(@Body() usernameDto: CheckUsernameDto) {
    const exist = await !this.memberService.isExistUsername(
      usernameDto.username,
    );
    throw new CustomResponse(ECustomCode.SUCCESS, { exist });
  }

  @ApiOperation({
    summary: '닉네임 수정',
    description: '닉네임 수정을 수행합니다.',
  })
  @ApiResponse({
    status: HttpStatus.OK,
    description: '닉네임 수정 결과',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'SUCCESS' },
        message: { type: 'boolean', example: '성공' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(UsernameResDto) },
      },
    },
  })
  @Patch('username')
  async pdateUsername(
    @CustomHeader(new JwtValidationPipe()) payload,
    @Body() usernameDto: UsernameDto,
  ) {
    const id = payload.memberId;
    const username = usernameDto.username;
    // 중복 검증
    if (await this.memberService.isExistUsername(username)) {
      throw new CustomResponse(ECustomCode.MEMBER01);
    }

    // db에 반영
    this.memberService.updateUsername(id, username);

    // 응답
    throw new CustomResponse(ECustomCode.SUCCESS, {
      username,
    });
  }
}
