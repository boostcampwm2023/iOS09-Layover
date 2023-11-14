import { Get, HttpStatus, Redirect, Query } from '@nestjs/common';
import { Controller } from '@nestjs/common';
import { OauthService } from './oauth.service';
import { hashSHA256 } from 'src/utils/hashUtils';

const kakaoOauthURL = 'https://kauth.kakao.com/oauth/authorize';
const kakaoRedirectUri = '/kakao/authorization-code';

@Controller('oauth')
export class OauthController {
  constructor(private readonly oauthService: OauthService) {}

  @Get('kakao')
  @Redirect(
    `${kakaoOauthURL}?client_id=${process.env.KAKAO_CLIENT_ID}&redirect_uri=${kakaoRedirectUri}&response_type=code`,
    HttpStatus.FOUND,
  )
  getKakaoOauthPage() {}

  @Get('kakao/authorization-code')
  async getKakaoAccessCode(
    @Query('code') code?: string,
    @Query('error') error?: string,
    @Query('error_description') error_description?: string,
    // @Query('state') state?: string, // To prevent CSRF attack
  ) {
    if (!code) {
      return `${error}: ${error_description}`;
    }

    // Send code to Kakao Auth Server to get access code
    const kakaoAccessTokenURL = 'https://kauth.kakao.com/oauth/token';
    const accessToken = await this.oauthService.getAccessToken(
      kakaoAccessTokenURL,
      code,
    );

    // Get email from Kakao Auth Server
    const kakaoUserInfoURL = 'https://kapi.kakao.com/v2/user/me';
    const email = await this.oauthService.getEmailByAccessToken(
      kakaoUserInfoURL,
      accessToken,
    );

    // Verify a user account already exists
    const hashValue = hashSHA256(email);
    // const isUserExist = await this.oauthService.isMemberExistByHash(hashValue);

    // if (!isUserExist) {
    // singup
    //}
    // login
    const { accessJWT, refreshJWT } = this.oauthService.doLogin();

    // return access token and refresh token
    return { accessJWT: accessJWT, refreshKJWT: refreshJWT };
  }

  @Get('apple')
  getAppleOauthPage() {}
}
