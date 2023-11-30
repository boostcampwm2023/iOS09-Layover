import { Post, Body, HttpStatus } from '@nestjs/common';
import { Controller } from '@nestjs/common';
import { OauthService } from './oauth.service';
import { JwtValidationPipe } from 'src/pipes/jwt.validation.pipe';
import { CustomResponse } from '../response/custom-response';
import { ECustomCode } from '../response/ecustom-code.jenum';
import { ApiHeader, ApiOperation, ApiResponse, ApiTags, getSchemaPath } from '@nestjs/swagger';
import { KakaoLoginDto } from './dtos/kakao-login.dto';
import { AppleLoginDto } from './dtos/apple-login.dto';
import { KakaoSignupDto } from './dtos/kakao-signup.dto';
import { AppleSignupDto } from './dtos/apple-signup.dto';
import { TokenResDto } from './dtos/token-res.dto';
import { CustomHeader } from 'src/pipes/custom-header.decorator';
import { SWAGGER } from 'src/utils/swaggerUtils';
import { tokenPayload } from 'src/utils/interfaces/token.payload';

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
  @ApiResponse({
    status: HttpStatus.OK,
    description: '카카오 로그인 성공',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'SUCCESS' },
        message: { type: 'string', example: '성공' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(TokenResDto) },
      },
    },
  })
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
  @ApiResponse({
    status: HttpStatus.OK,
    description: '애플 로그인 성공',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'SUCCESS' },
        message: { type: 'string', example: '성공' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(TokenResDto) },
      },
    },
  })
  @ApiResponse(SWAGGER.NOT_OUR_MEMBER_RESPONSE)
  @Post('apple')
  async processAppleLogin(@Body() appleLoginDto: AppleLoginDto) {
    // memberHash 구하기
    const memberHash = this.oauthService.getAppleMemberHash(appleLoginDto.identityToken);

    // login
    const tokenResponseDto = await this.oauthService.login(memberHash);

    // return access token and refresh token
    throw new CustomResponse(ECustomCode.SUCCESS, tokenResponseDto);
  }

  @ApiOperation({
    summary: '카카오 회원가입',
    description: '카카오 회원가입을 수행합니다.',
  })
  @ApiResponse({
    status: HttpStatus.OK,
    description: '카카오 회원가입 성공',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'SUCCESS' },
        message: { type: 'string', example: '성공' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(TokenResDto) },
      },
    },
  })
  @ApiResponse(SWAGGER.NOT_OUR_MEMBER_RESPONSE)
  @Post('signup/kakao')
  async processKakaoSignup(@Body() kakaoSignupDto: KakaoSignupDto) {
    const [accessToken, username] = [kakaoSignupDto.accessToken, kakaoSignupDto.username];

    // memberHash 구하기
    const memberHash = await this.oauthService.getKakaoMemberHash(accessToken);

    // 이미 회원가입 돼있다면, 바로 로그인 시키기
    const isUserExist = await this.oauthService.isMemberExistByHash(memberHash);
    if (isUserExist) {
      // Response access token and refresh token
      const tokenResponseDto = await this.oauthService.generateAccessRefreshTokens(memberHash);
      throw new CustomResponse(ECustomCode.SUCCESS, tokenResponseDto);
    }

    // 닉네임 중복 확인 : MEMBER01
    if (await this.oauthService.isExistUsername(username)) {
      throw new CustomResponse(ECustomCode.MEMBER01);
    }

    // signup
    await this.oauthService.signup(memberHash, username, 'kakao');

    // Response access token and refresh token
    const tokenResponseDto = await this.oauthService.generateAccessRefreshTokens(memberHash);
    throw new CustomResponse(ECustomCode.SUCCESS, tokenResponseDto);
  }

  @ApiOperation({
    summary: '애플 회원가입',
    description: '애플 회원가입을 수행합니다.',
  })
  @ApiResponse({
    status: HttpStatus.OK,
    description: '애플 회원가입 성공',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'SUCCESS' },
        message: { type: 'string', example: '성공' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(TokenResDto) },
      },
    },
  })
  @ApiResponse(SWAGGER.NOT_OUR_MEMBER_RESPONSE)
  @Post('signup/apple')
  async processAppleSignup(@Body() appleSignupDto: AppleSignupDto) {
    const [identityToken, username] = [appleSignupDto.identityToken, appleSignupDto.username];

    // memberHash 구하기
    const memberHash = this.oauthService.getAppleMemberHash(identityToken);

    // 이미 회원가입 돼있다면, 바로 로그인 시키기
    const isUserExist = await this.oauthService.isMemberExistByHash(memberHash);
    if (isUserExist) {
      // Response access token and refresh token
      const tokenResponseDto = await this.oauthService.generateAccessRefreshTokens(memberHash);
      throw new CustomResponse(ECustomCode.SUCCESS, tokenResponseDto);
    }

    // 닉네임 중복 확인 : MEMBER01
    if (await this.oauthService.isExistUsername(username)) {
      throw new CustomResponse(ECustomCode.MEMBER01);
    }

    // signup
    await this.oauthService.signup(memberHash, username, 'apple');

    // Response access token and refresh token
    const tokenResponseDto = await this.oauthService.generateAccessRefreshTokens(memberHash);
    throw new CustomResponse(ECustomCode.SUCCESS, tokenResponseDto);
  }

  @ApiOperation({
    summary: 'Access token 재발급',
    description: 'refresh token을 이용해 access token을 재발급합니다.',
  })
  @ApiResponse({
    status: HttpStatus.OK,
    description: '토큰 재발급 성공',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'SUCCESS' },
        message: { type: 'string', example: '성공' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(TokenResDto) },
      },
    },
  })
  @ApiResponse(SWAGGER.REFRESH_TOKEN_TIMEOUT_RESPONSE)
  @ApiHeader(SWAGGER.AUTHORIZATION_HEADER)
  @Post('refresh-token')
  async renewTokens(@CustomHeader(new JwtValidationPipe()) payload: tokenPayload) {
    // 새로운 토큰을 생성하고 이를 반환함
    const tokenResponseDto = await this.oauthService.generateAccessRefreshTokens(payload.memberHash);

    // return access token and refresh token
    throw new CustomResponse(ECustomCode.SUCCESS, tokenResponseDto);
  }
}
