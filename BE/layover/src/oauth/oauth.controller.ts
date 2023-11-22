import { Post, Body } from '@nestjs/common';
import { Controller } from '@nestjs/common';
import { OauthService } from './oauth.service';
import { JwtValidationPipe } from 'src/pipes/jwt.validation.pipe';
import { CustomResponse } from '../response/custom-response';
import { ECustomCode } from '../response/ecustom-code.jenum.';

@Controller('oauth')
export class OauthController {
  constructor(private readonly oauthService: OauthService) {}

  @Post('kakao')
  async processKakaoLogin(@Body('accessToken') accessToken: string) {
    // memberHash 구하기
    const memberHash = await this.oauthService.getKakaoMemberHash(accessToken);

    // login
    const { accessJWT, refreshJWT } = await this.oauthService.login(memberHash);

    // return access token and refresh token
    throw new CustomResponse(ECustomCode.SUCCESS, {
      accessToken: accessJWT,
      refreshToken: refreshJWT,
    });
  }

  @Post('apple')
  async processAppleLogin(@Body('identityToken') identityToken: string) {
    // memberHash 구하기
    const memberHash = this.oauthService.getAppleMemberHash(identityToken);

    // login
    const { accessJWT, refreshJWT } = await this.oauthService.login(memberHash);

    // return access token and refresh token
    throw new CustomResponse(ECustomCode.SUCCESS, {
      accessToken: accessJWT,
      refreshToken: refreshJWT,
    });
  }

  @Post('signup/kakao')
  async processKakaoSignup(
    @Body('accessToken') accessToken: string,
    @Body('username') username: string,
  ) {
    // memberHash 구하기
    const memberHash = await this.oauthService.getKakaoMemberHash(accessToken);

    // 닉네임 중복 확인 : MEMBER01

    // signup
    await this.oauthService.signup(memberHash, username, 'kakao');

    // token들 발급
    const { accessJWT, refreshJWT } =
      await this.oauthService.generateAccessRefreshTokens(memberHash);

    // return access token and refresh token
    throw new CustomResponse(ECustomCode.SUCCESS, {
      accessToken: accessJWT,
      refreshToken: refreshJWT,
    });
  }

  @Post('signup/apple')
  async processAppleSignup(
    @Body('identityToken') identityToken: string,
    @Body('username') username: string,
  ) {
    // memberHash 구하기
    const memberHash = this.oauthService.getAppleMemberHash(identityToken);

    // 닉네임 중복 확인 : MEMBER01

    // signup
    await this.oauthService.signup(memberHash, username, 'apple');

    // token들 발급
    const { accessJWT, refreshJWT } =
      await this.oauthService.generateAccessRefreshTokens(memberHash);

    // return access token and refresh token
    throw new CustomResponse(ECustomCode.SUCCESS, {
      accessToken: accessJWT,
      refreshToken: refreshJWT,
    });
  }

  @Post('refresh-token')
  async renewTokens(@Body('refreshToken', JwtValidationPipe) refreshToken) {
    // 새로운 토큰을 생성하고 이를 반환함
    const { accessJWT, refreshJWT } =
      await this.oauthService.generateAccessRefreshTokens(
        refreshToken.payload.memberHash,
      );

    // return access token and refresh token
    throw new CustomResponse(ECustomCode.SUCCESS, {
      accessToken: accessJWT,
      refreshToken: refreshJWT,
    });
  }
}
