import { Post, Body } from '@nestjs/common';
import { Controller } from '@nestjs/common';
import { OauthService } from './oauth.service';
import { JwtValidationPipe } from 'src/pipes/jwt.validation.pipe';
import { CustomResponse } from '../response/custom-response';
import { ECustomCode } from '../response/ecustom-code.jenum';
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { KakaoLoginDto } from './dtos/kakao-login.dto';
import { AppleLoginDto } from './dtos/apple-login.dto';
import { KakaoSignupDto } from './dtos/kakao-signup.dto';
import { AppleSignupDto } from './dtos/apple-signup.dto';
import { CustomHeader } from 'src/pipes/custom-header.decorator';
import { SWAGGER } from 'src/utils/swaggerUtils';
import { tokenPayload } from 'src/utils/interfaces/token.payload';
import { OAUTH_SWAGGER } from './oauth.swagger';
import { CheckSignupResDto } from './dtos/check-signup-res-dto';
import { ACCESS_TOKEN_EXP_IN_SECOND, REFRESH_TOKEN_EXP_IN_SECOND } from 'src/config';

@ApiTags('OAuth API')
@Controller('oauth')
@ApiResponse(SWAGGER.SERVER_CUSTOM_RESPONSE)
@ApiResponse(SWAGGER.HTTP_ERROR_RESPONSE)
@ApiResponse(SWAGGER.INTERNAL_SERVER_ERROR_RESPONSE)
export class OauthController {
  constructor(private readonly oauthService: OauthService) {}

  @ApiOperation({
    summary: '카카오 로그인',
    description: '카카오 로그인을 수행합니다.',
  })
  @ApiResponse(OAUTH_SWAGGER.PROCESS_KAKAO_LOGIN_SUCCESS)
  @ApiResponse(SWAGGER.NOT_OUR_MEMBER_RESPONSE)
  @Post('kakao')
  async processKakaoLogin(@Body() kakaoLoginDto: KakaoLoginDto) {
    // memberHash 구하기
    const memberHash = await this.oauthService.getKakaoMemberHash(kakaoLoginDto.accessToken);

    // login
    const tokenResponseDto = await this.oauthService.login(memberHash);

    // return access token and refresh token
    throw new CustomResponse(ECustomCode.SUCCESS, tokenResponseDto);
  }

  @ApiOperation({
    summary: '애플 로그인',
    description: '애플 로그인을 수행합니다.',
  })
  @ApiResponse(OAUTH_SWAGGER.PROCESS_APPLE_LOGIN_SUCCESS)
  @ApiResponse(SWAGGER.NOT_OUR_MEMBER_RESPONSE)
  @Post('apple')
  async processAppleLogin(@Body() appleLoginDto: AppleLoginDto) {
    // identity token 검증
    await this.oauthService.verifyAppleIdentityToken(appleLoginDto.identityToken);

    // memberHash 구하기
    const memberHash = this.oauthService.getAppleMemberHash(appleLoginDto.identityToken);

    // login
    const tokenResponseDto = await this.oauthService.login(memberHash);

    // return access token and refresh token
    throw new CustomResponse(ECustomCode.SUCCESS, tokenResponseDto);
  }

  @ApiOperation({
    summary: '카카오 회원가입 여부 확인',
    description: '특정 카카오 계정으로 카카오 회원가입이 돼있는지 확인합니다.',
  })
  @ApiResponse(OAUTH_SWAGGER.CHECK_SIGNUP_SUCCESS)
  @Post('check-signup/kakao')
  async checkKakaoSignup(@Body() kakaoLoginDto: KakaoLoginDto) {
    // memberHash 구하기
    const memberHash = await this.oauthService.getKakaoMemberHash(kakaoLoginDto.accessToken);

    // memberHash를 기준으로 회원가입 여부 확인
    const isUserExist = (await this.oauthService.isMemberExistByHash(memberHash)) === 'EXIST';

    // Response access token and refresh token
    throw new CustomResponse(ECustomCode.SUCCESS, new CheckSignupResDto(isUserExist));
  }

  @ApiOperation({
    summary: '애플 회원가입 여부 확인',
    description: '특정 애플 계정으로 애플 회원가입이 돼있는지 확인합니다.',
  })
  @ApiResponse(OAUTH_SWAGGER.CHECK_SIGNUP_SUCCESS)
  @Post('check-signup/apple')
  async checkAppleSignup(@Body() appleLoginDto: AppleLoginDto) {
    // identity token 검증
    await this.oauthService.verifyAppleIdentityToken(appleLoginDto.identityToken);

    // memberHash 구하기
    const memberHash = this.oauthService.getAppleMemberHash(appleLoginDto.identityToken);

    // memberHash를 기준으로 회원가입 여부 확인
    const isUserExist = (await this.oauthService.isMemberExistByHash(memberHash)) === 'EXIST';

    // Response access token and refresh token
    throw new CustomResponse(ECustomCode.SUCCESS, new CheckSignupResDto(isUserExist));
  }

  @ApiOperation({
    summary: '카카오 회원가입',
    description: '카카오 회원가입을 수행합니다.',
  })
  @ApiResponse(OAUTH_SWAGGER.PROCESS_KAKAO_SIGNUP_SUCCESS)
  @ApiResponse(SWAGGER.NOT_OUR_MEMBER_RESPONSE)
  @Post('signup/kakao')
  async processKakaoSignup(@Body() kakaoSignupDto: KakaoSignupDto) {
    const [accessToken, username] = [kakaoSignupDto.accessToken, kakaoSignupDto.username];

    // memberHash 구하기
    const memberHash = await this.oauthService.getKakaoMemberHash(accessToken);

    // 이미 회원가입 돼있다면, 바로 로그인 시키기
    const isUserExist = await this.oauthService.isMemberExistByHash(memberHash);
    if (isUserExist === 'EXIST') {
      // Response access token and refresh token
      const tokenResponseDto = await this.oauthService.generateAccessRefreshTokens(memberHash);
      throw new CustomResponse(ECustomCode.SUCCESS, tokenResponseDto);
    }

    // 복구 대상 유저라면 데이터들 복구시켜주기
    if (isUserExist === 'DELETED') {
      const memberId = await this.oauthService.getMemberIdByHash(memberHash);
      this.oauthService.recoverUserData(memberId);
      // Response access token and refresh token
      const tokenResponseDto = await this.oauthService.generateAccessRefreshTokens(memberHash);
      throw new CustomResponse(ECustomCode.SUCCESS, tokenResponseDto);
    }

    // 닉네임 중복 확인 : MEMBER01
    if (await this.oauthService.isExistUsername(username)) {
      throw new CustomResponse(ECustomCode.DUPLICATED_USERNAME);
    }

    // signup
    await this.oauthService.signup(
      memberHash,
      username,
      'kakao',
      await this.oauthService.getMemberIdByKakaoAccessToken(accessToken),
      '',
    );

    // Response access token and refresh token
    const tokenResponseDto = await this.oauthService.generateAccessRefreshTokens(memberHash);
    throw new CustomResponse(ECustomCode.SUCCESS, tokenResponseDto);
  }

  @ApiOperation({
    summary: '애플 회원가입',
    description: '애플 회원가입을 수행합니다.',
  })
  @ApiResponse(OAUTH_SWAGGER.PROCESS_APPLE_SIGNUP_SUCCESS)
  @ApiResponse(SWAGGER.NOT_OUR_MEMBER_RESPONSE)
  @Post('signup/apple')
  async processAppleSignup(@Body() appleSignupDto: AppleSignupDto) {
    const [authorizationCode, identityToken, username] = [
      appleSignupDto.authorizationCode,
      appleSignupDto.identityToken,
      appleSignupDto.username,
    ];

    // identity token 검증
    await this.oauthService.verifyAppleIdentityToken(identityToken);

    // memberHash 구하기
    const memberHash = this.oauthService.getAppleMemberHash(identityToken);

    // 이미 회원가입 돼있다면, 바로 로그인 시키기
    const isUserExist = await this.oauthService.isMemberExistByHash(memberHash);
    if (isUserExist === 'EXIST') {
      // Response access token and refresh token
      const tokenResponseDto = await this.oauthService.generateAccessRefreshTokens(memberHash);
      throw new CustomResponse(ECustomCode.SUCCESS, tokenResponseDto);
    }

    // 복구 대상 유저라면 데이터들 복구시켜주기
    if (isUserExist === 'DELETED') {
      const memberId = await this.oauthService.getMemberIdByHash(memberHash);
      this.oauthService.recoverUserData(memberId);
      // Response access token and refresh token
      const tokenResponseDto = await this.oauthService.generateAccessRefreshTokens(memberHash);
      throw new CustomResponse(ECustomCode.SUCCESS, tokenResponseDto);
    }

    // 닉네임 중복 확인 : MEMBER01
    if (await this.oauthService.isExistUsername(username)) {
      throw new CustomResponse(ECustomCode.DUPLICATED_USERNAME);
    }

    // signup
    await this.oauthService.signup(
      memberHash,
      username,
      'apple',
      '',
      await this.oauthService.getAppleRefreshToken(authorizationCode),
    );

    // Response access token and refresh token
    const tokenResponseDto = await this.oauthService.generateAccessRefreshTokens(memberHash);
    throw new CustomResponse(ECustomCode.SUCCESS, tokenResponseDto);
  }

  @ApiOperation({
    summary: 'Access/Refresh token 재발급',
    description: 'refresh token을 이용해 access/refresh token을 재발급합니다.',
  })
  @ApiResponse(OAUTH_SWAGGER.RENEW_TOKENS_SUCCESS)
  @ApiResponse(SWAGGER.REFRESH_TOKEN_TIMEOUT_RESPONSE)
  @ApiBearerAuth('token')
  @Post('refresh-token')
  async renewTokens(@CustomHeader(JwtValidationPipe) payload: tokenPayload) {
    // AccessToken이 아직 만료되지 않았다면 error
    if (payload.exp - (REFRESH_TOKEN_EXP_IN_SECOND - ACCESS_TOKEN_EXP_IN_SECOND) > Math.floor(Date.now() / 1000))
      throw new CustomResponse(ECustomCode.ACCESS_TOKEN_NOT_EXPIRED);

    // redis에 해당 refresh token이 있는지 확인
    await this.oauthService.isRefreshTokenValid(payload.jti);

    // 기존 토큰은 없앰 (기존 RefreshToken -> redis에서 삭제)
    await this.oauthService.deleteExistRefreshTokenFromRedis(payload.memberHash);

    // 새로운 토큰을 생성하고 이를 반환함
    const tokenResponseDto = await this.oauthService.generateAccessRefreshTokens(payload.memberHash);

    // return access token and refresh token
    throw new CustomResponse(ECustomCode.SUCCESS, tokenResponseDto);
  }
}
