import { Get, Post, Body } from '@nestjs/common';
import { Controller } from '@nestjs/common';
import { OauthService } from './oauth.service';
import { hashSHA256 } from 'src/utils/hashUtils';

import * as dotenv from 'dotenv';
dotenv.config();

@Controller('oauth')
export class OauthController {
  constructor(private readonly oauthService: OauthService) {}

  @Post('kakao')
  async processKakaoLogin(@Body('accessToken') accessToken: string) {
    // Get memberId from Kakao Auth Server
    const kakaoUserInfoURL = 'https://kapi.kakao.com/v2/user/me';
    const memberId = await this.oauthService.getMemberIdByAccessToken(
      kakaoUserInfoURL,
      accessToken,
    );

    // Verify a user account already exists
    const memberHash = hashSHA256(memberId + 'kakao'); // kakao 내에선 유일하겠지만 apple과 겹칠 수 있어서 뒤에 스트링 하나 추가
    const isUserExist = await this.oauthService.isMemberExistByHash(memberHash);

    if (!isUserExist) {
      // response 401, OAUTH01
    }
    // login
    const { accessJWT, refreshJWT } = await this.oauthService.login(memberHash);

    // return access token and refresh token
    return { accessJWT: accessJWT, refreshKJWT: refreshJWT };
  }

  @Post('signup')
  async processSignup(
    @Body('memberHash') memberHash: string,
    @Body('username') username: string,
    @Body('provider') provider: string,
  ) {
    console.log(memberHash, username, provider);
    await this.oauthService.signup(memberHash, username, provider);

    // login
    const { accessJWT, refreshJWT } = await this.oauthService.login(memberHash);

    // return access token and refresh token
    return { accessJWT: accessJWT, refreshKJWT: refreshJWT };
  }

  @Get('apple')
  getAppleOauthPage() {}
}
