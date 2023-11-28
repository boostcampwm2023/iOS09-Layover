import { Body, Controller, Delete, Get, HttpStatus, Patch, Post } from '@nestjs/common';
import { CheckUsernameDto } from './dtos/check-username.dto';
import { MemberService } from './member.service';
import { ApiOperation, ApiResponse, ApiTags, getSchemaPath } from '@nestjs/swagger';
import { CheckUsernameResDto } from './dtos/check-username-res.dto';
import { CustomResponse } from 'src/response/custom-response';
import { ECustomCode } from 'src/response/ecustom-code.jenum';
import { UsernameResDto } from './dtos/username-res.dto';
import { UsernameDto } from './dtos/username.dto';
import { CustomHeader } from 'src/pipes/custom-header.decorator';
import { JwtValidationPipe } from 'src/pipes/jwt.validation.pipe';
import { IntroduceDto } from './dtos/introduce.dto';
import { IntroduceResDto } from './dtos/introduce-res.dto';
import { DeleteMemberResDto } from './dtos/delete-member-res.dto';
import { ProfilePresignedUrlDto } from './dtos/profile-presigned-url.dto';
import { ProfilePresignedUrlResDto } from './dtos/profile-presigned-url-res.dto';
import { MemberInfosResDto } from './dtos/member-infos-res.dto';

@ApiTags('Member API')
@Controller('member')
@ApiResponse({
  status: HttpStatus.BAD_REQUEST,
  description: 'client의 요청이 잘못된 경우',
  schema: {
    type: 'object',
    properties: {
      customCode: { type: 'string', example: 'OAUTH__' },
      message: { type: 'string', example: '응답코드에 맞는 메시지' },
      statusCode: { type: 'number', example: HttpStatus.BAD_REQUEST },
    },
  },
})
@ApiResponse({
  description: '예상치 못한 Http Exception',
  schema: {
    type: 'object',
    properties: {
      customCode: { type: 'string', example: 'NEST_OFFER_EXCEPTION' },
      message: { type: 'string', example: 'message from nest' },
      statusCode: { type: 'number', example: HttpStatus.NOT_FOUND },
    },
  },
})
@ApiResponse({
  status: HttpStatus.INTERNAL_SERVER_ERROR,
  description: '예상치 못한 서버 Exception',
  schema: {
    type: 'object',
    properties: {
      customCode: { type: 'string', example: 'INTERNAL_SERVER_ERROR' },
      message: { type: 'string', example: 'message from nest' },
      statusCode: { type: 'number', example: HttpStatus.INTERNAL_SERVER_ERROR },
    },
  },
})
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
  @ApiResponse({
    status: HttpStatus.UNAUTHORIZED,
    description: '리프레시 토큰 유효기간 만료',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'JWT02' },
        message: { type: 'string', example: '토큰 만료기간이 경과하였습니다.' },
        statusCode: { type: 'number', example: HttpStatus.UNAUTHORIZED },
      },
    },
  })
  @Post('check-username')
  async checkUsername(@Body() usernameDto: CheckUsernameDto) {
    const exist = !(await this.memberService.isExistUsername(usernameDto.username));
    throw new CustomResponse(ECustomCode.SUCCESS, new CheckUsernameResDto(exist));
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
  async updateUsername(@CustomHeader(new JwtValidationPipe()) payload, @Body() usernameDto: UsernameDto) {
    const id = payload.memberId;
    const username = usernameDto.username;
    // 중복 검증
    if (await this.memberService.isExistUsername(username)) {
      throw new CustomResponse(ECustomCode.MEMBER01);
    }

    // db에 반영
    await this.memberService.updateUsername(id, username);

    // 응답
    throw new CustomResponse(ECustomCode.SUCCESS, new UsernameResDto(username));
  }

  @ApiOperation({
    summary: '자기소개 수정',
    description: '자기소개 수정을 수행합니다.',
  })
  @ApiResponse({
    status: HttpStatus.OK,
    description: '자기소개 수정 결과',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'SUCCESS' },
        message: { type: 'boolean', example: '성공' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(IntroduceResDto) },
      },
    },
  })
  @ApiResponse({
    status: HttpStatus.UNAUTHORIZED,
    description: '리프레시 토큰 유효기간 만료',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'JWT02' },
        message: { type: 'string', example: '토큰 만료기간이 경과하였습니다.' },
        statusCode: { type: 'number', example: HttpStatus.UNAUTHORIZED },
      },
    },
  })
  @Patch('introduce')
  async updateIntroduce(@CustomHeader(new JwtValidationPipe()) payload, @Body() introduceDto: IntroduceDto) {
    const id = payload.memberId;
    const introduce = introduceDto.introduce;

    // db에 반영
    await this.memberService.updateIntroduce(id, introduce);

    // 응답
    throw new CustomResponse(ECustomCode.SUCCESS, new IntroduceResDto(introduce));
  }

  @ApiOperation({
    summary: '회원 탈퇴(삭제)',
    description: '회원 삭제를 수행합니다.',
  })
  @ApiResponse({
    status: HttpStatus.OK,
    description: '삭제된 회원 정보(닉네임)',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'SUCCESS' },
        message: { type: 'boolean', example: '성공' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(DeleteMemberResDto) },
      },
    },
  })
  @Delete()
  async deleteMember(@CustomHeader(new JwtValidationPipe()) payload) {
    const id = payload.memberId;

    // 삭제될 유저 정보 가져오기
    const memberInfo = await this.memberService.selectUsername(id);

    // db에 반영
    await this.memberService.deleteMember(id);

    // 응답
    throw new CustomResponse(ECustomCode.SUCCESS, new DeleteMemberResDto(memberInfo));
  }

  @ApiOperation({
    summary: '프로필 이미지 업로드용 presigned url 요청',
    description: '프로필 이미지 업로드용 presigned url을 응답으로 줍니다.',
  })
  @ApiResponse({
    status: HttpStatus.OK,
    description: '프로필 이미지 업로드용 presigned url',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'SUCCESS' },
        message: { type: 'boolean', example: '성공' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(ProfilePresignedUrlResDto) },
      },
    },
  })
  @ApiResponse({
    status: HttpStatus.UNAUTHORIZED,
    description: '리프레시 토큰 유효기간 만료',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'JWT02' },
        message: { type: 'string', example: '토큰 만료기간이 경과하였습니다.' },
        statusCode: { type: 'number', example: HttpStatus.UNAUTHORIZED },
      },
    },
  })
  @Post('profile-image/presigned-url')
  async getUploadProfilePresignedUrl(@CustomHeader(new JwtValidationPipe()) payload, @Body() body: ProfilePresignedUrlDto) {
    const id = payload.memberId;

    // 프로필 사진 업로드할 presigned url 생성하기
    const member = await this.memberService.findMemberById(id);
    const filename = member.username;
    const filetype = body.filetype;
    const bucketname = process.env.NCLOUD_S3_PROFILE_BUCKET_NAME;
    const { preSignedUrl } = this.memberService.makeUploadPreSignedUrl(bucketname, filename, 'image', filetype);

    // db에 반영
    const key = `${filename}.${filetype}`;
    await this.memberService.updateProfileImage(id, key);

    // 응답
    throw new CustomResponse(ECustomCode.SUCCESS, new ProfilePresignedUrlResDto(preSignedUrl));
  }

  @ApiOperation({
    summary: '회원 정보 요청',
    description: '회원 정보들(닉네임, 자기소개, 프로필 이미지 url)을 응답으로 줍니다.',
  })
  @ApiResponse({
    status: HttpStatus.OK,
    description: '회원 정보들',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'SUCCESS' },
        message: { type: 'boolean', example: '성공' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(MemberInfosResDto) },
      },
    },
  })
  @ApiResponse({
    status: HttpStatus.UNAUTHORIZED,
    description: '리프레시 토큰 유효기간 만료',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'JWT02' },
        message: { type: 'string', example: '토큰 만료기간이 경과하였습니다.' },
        statusCode: { type: 'number', example: HttpStatus.UNAUTHORIZED },
      },
    },
  })
  @Get()
  async getMemberInfos(@CustomHeader(new JwtValidationPipe()) payload) {
    const id = payload.memberId;
    const member = await this.memberService.findMemberById(id);

    const username = member.username;
    const introduce = member.introduce;
    const profileImageKey = member.profile_image_key;

    const bucketname = process.env.NCLOUD_S3_PROFILE_BUCKET_NAME;
    let preSignedUrl: string;
    if (profileImageKey !== 'default') {
      ({ preSignedUrl } = this.memberService.makeDownloadPresignedUrl(bucketname, member.profile_image_key));
    } else {
      ({ preSignedUrl } = this.memberService.makeDownloadPresignedUrl(bucketname, 'default.jpeg')); // 기본 이미지 사용!
    }

    // 응답
    throw new CustomResponse(ECustomCode.SUCCESS, new MemberInfosResDto(username, introduce, preSignedUrl));
  }
}
