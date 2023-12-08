import { Body, Controller, Delete, Get, Patch, Post, Query } from '@nestjs/common';
import { CheckUsernameDto } from './dtos/check-username.dto';
import { MemberService } from './member.service';
import { ApiBearerAuth, ApiOperation, ApiQuery, ApiResponse, ApiTags } from '@nestjs/swagger';
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
import { ProfilePreSignedUrlDto } from './dtos/profile-pre-signed-url.dto';
import { MemberInfosResDto } from './dtos/member-infos-res.dto';
import { SWAGGER } from 'src/utils/swaggerUtils';
import { tokenPayload } from 'src/utils/interfaces/token.payload';
import { MEMBER_SWAGGER } from './member.swagger';
import { generateDownloadPreSignedUrl, generateUploadPreSignedUrl } from '../utils/s3Utils';
import { PreSignedUrlResDto } from '../utils/pre-signed-url-res.dto';

@ApiTags('Member API')
@Controller('member')
@ApiResponse(SWAGGER.SERVER_CUSTOM_RESPONSE)
@ApiResponse(SWAGGER.HTTP_ERROR_RESPONSE)
@ApiResponse(SWAGGER.INTERNAL_SERVER_ERROR_RESPONSE)
export class MemberController {
  constructor(private readonly memberService: MemberService) {}

  @ApiOperation({
    summary: '닉네임 검증(중복)',
    description: '닉네임 검증을 수행합니다.',
  })
  @ApiResponse(MEMBER_SWAGGER.CHECK_USER_NAME_SUCCESS)
  @Post('check-username')
  async checkUsername(@Body() usernameDto: CheckUsernameDto) {
    const isValid = !(await this.memberService.isExistUsername(usernameDto.username));
    throw new CustomResponse(ECustomCode.SUCCESS, new CheckUsernameResDto(isValid));
  }

  @ApiOperation({
    summary: '닉네임 수정',
    description: '닉네임 수정을 수행합니다.',
  })
  @ApiResponse(MEMBER_SWAGGER.UPDATE_USER_NAME_SUCCESS)
  @ApiResponse(SWAGGER.ACCESS_TOKEN_TIMEOUT_RESPONSE)
  @ApiBearerAuth('token')
  @Patch('username')
  async updateUsername(@CustomHeader(new JwtValidationPipe()) payload: tokenPayload, @Body() usernameDto: UsernameDto) {
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
  @ApiResponse(MEMBER_SWAGGER.UPDATE_INTRODUCE_SUCCESS)
  @ApiResponse(SWAGGER.ACCESS_TOKEN_TIMEOUT_RESPONSE)
  @ApiBearerAuth('token')
  @Patch('introduce')
  async updateIntroduce(
    @CustomHeader(new JwtValidationPipe()) payload: tokenPayload,
    @Body() introduceDto: IntroduceDto,
  ) {
    const id = payload.memberId;
    const introduce = introduceDto.introduce;

    // db에 반영
    await this.memberService.updateIntroduce(id, introduce);

    // 응답
    throw new CustomResponse(ECustomCode.SUCCESS, new IntroduceResDto(introduce));
  }

  @ApiOperation({
    summary: '회원 정보 요청',
    description: '회원 정보들(닉네임, 자기소개, 프로필 이미지 url)을 응답으로 줍니다.',
  })
  @ApiResponse(MEMBER_SWAGGER.GET_MEMBER_INFOS_SUCCESS)
  @ApiResponse(SWAGGER.ACCESS_TOKEN_TIMEOUT_RESPONSE)
  @ApiBearerAuth('token')
  @ApiQuery(SWAGGER.MEMBER_ID_QUERY_STRING)
  @Get()
  async getOtherMemberInfos(
    @CustomHeader(new JwtValidationPipe()) payload: tokenPayload,
    @Query('memberId') memberId: string,
  ) {
    let id: number;
    if (memberId !== undefined) {
      // memberId가 존재하면 타인의 프로필을 조회하는 것이다.
      id = parseInt(memberId);
    } else {
      // memberId가 존재하지 않으면 내 프로필을 조회하는 것이다.
      id = payload.memberId;
    }

    const member = await this.memberService.getMemberById(id);
    if (member === null) throw new CustomResponse(ECustomCode.MEMBER02);

    const username = member.username;
    const introduce = member.introduce;
    const profileImageKey = member.profile_image_key;

    const bucketname = process.env.NCLOUD_S3_PROFILE_BUCKET_NAME;
    const preSignedUrl = generateDownloadPreSignedUrl(bucketname, profileImageKey);

    // 응답
    throw new CustomResponse(ECustomCode.SUCCESS, new MemberInfosResDto(id, username, introduce, preSignedUrl));
  }

  @ApiOperation({
    summary: '회원 탈퇴(삭제)',
    description: '회원 삭제를 수행합니다.',
  })
  @ApiResponse(MEMBER_SWAGGER.DELETE_MEMBER_SUCCESS)
  @ApiResponse(SWAGGER.ACCESS_TOKEN_TIMEOUT_RESPONSE)
  @ApiBearerAuth('token')
  @Delete()
  async deleteMember(@CustomHeader(new JwtValidationPipe()) payload: tokenPayload) {
    const id = payload.memberId;

    // 삭제될 유저 정보 가져오기
    const memberInfo = await this.memberService.getUsernameById(id);

    // db에 반영
    await this.memberService.deleteMember(id);

    // 응답
    throw new CustomResponse(ECustomCode.SUCCESS, new DeleteMemberResDto(memberInfo));
  }

  @ApiOperation({
    summary: '프로필 이미지 업로드용 presigned url 요청',
    description: '프로필 이미지 업로드용 presigned url을 응답으로 줍니다.',
  })
  @ApiResponse(MEMBER_SWAGGER.GET_UPLOAD_PROFILE_PRESIGNED_URL_SUCCESS)
  @ApiResponse(SWAGGER.ACCESS_TOKEN_TIMEOUT_RESPONSE)
  @ApiBearerAuth('token')
  @Post('profile-image/presigned-url')
  async getUploadProfilePresignedUrl(
    @CustomHeader(new JwtValidationPipe()) payload: tokenPayload,
    @Body() body: ProfilePreSignedUrlDto,
  ) {
    const id = payload.memberId;

    // 프로필 사진 업로드할 presigned url 생성하기
    const member = await this.memberService.getMemberById(id);
    const filename = member.username;
    const filetype = body.filetype;
    const bucketname = process.env.NCLOUD_S3_PROFILE_BUCKET_NAME;
    const preSignedUrl = generateUploadPreSignedUrl(bucketname, filename, 'image', filetype);

    // db에 반영
    const key = `${filename}.${filetype}`;
    await this.memberService.updateProfileImage(id, key);

    // 응답
    throw new CustomResponse(ECustomCode.SUCCESS, new PreSignedUrlResDto(preSignedUrl));
  }
}
