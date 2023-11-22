import { Post, Body } from '@nestjs/common';
import { Controller } from '@nestjs/common';
import { OauthService } from './oauth.service';
import { hashSHA256 } from 'src/utils/hashUtils';
import { extractPayloadJWT } from 'src/utils/jwtUtils';
import { JwtValidationPipe } from 'src/pipes/jwt.validation.pipe';
import { CustomException, ECustomException } from 'src/custom-exception';

@Controller('oauth')
export class OauthController {
  constructor(private readonly oauthService: OauthService) {}

  @Post('kakao')
  async processKakaoLogin(@Body('accessToken') accessToken: string) {
    // Get memberId from Kakao Auth Server -> make memberHash
    const kakaoUserInfoURL = 'https://kapi.kakao.com/v2/user/me';
    const memberId = await this.oauthService.getMemberIdByAccessToken(
      kakaoUserInfoURL,
      accessToken,
    );
    const memberHash = hashSHA256(memberId + 'kakao'); // kakao 내에선 유일하겠지만 apple과 겹칠 수 있어서 뒤에 스트링 하나 추가

    // login
    const { accessJWT, refreshJWT } = await this.oauthService.login(memberHash);

    // return access token and refresh token
    return { accessToken: accessJWT, refreshToken: refreshJWT };
  }

  @Post('apple')
  async processAppleLogin(@Body('identityToken') identityToken: string) {
    // Get memberId from identity token ("sub" claim)
    const jwtPayload = await extractPayloadJWT(identityToken);
    if (!jwtPayload.sub) throw new CustomException(ECustomException.OAUTH07);
    const memberId = jwtPayload.sub;
    const memberHash = hashSHA256(memberId + 'apple'); // kakao 내에선 유일하겠지만 apple과 겹칠 수 있어서 뒤에 스트링 하나 추가

    // login
    const { accessJWT, refreshJWT } = await this.oauthService.login(memberHash);

    // return access token and refresh token
    return { accessToken: accessJWT, refreshToken: refreshJWT };
  }

  @Post('signup')
  async processSignup(
    @Body('memberHash') memberHash: string,
    @Body('username') username: string,
    @Body('provider') provider: string,
  ) {
    // 닉네임 중복 확인

    // signup
    await this.oauthService.signup(memberHash, username, provider);

    // token들 발급
    const { accessJWT, refreshJWT } =
      await this.oauthService.generateAccessRefreshTokens(memberHash);

    // return access token and refresh token
    return { accessToken: accessJWT, refreshToken: refreshJWT };
  }

  @Post('refresh-token')
  async renewTokens(@Body('refreshToken', JwtValidationPipe) refreshToken) {
    // 새로운 토큰을 생성하고 이를 반환함
    const { accessJWT, refreshJWT } =
      await this.oauthService.generateAccessRefreshTokens(
        refreshToken.payload.memberHash,
      );

    // return access token and refresh token
    return { accessToken: accessJWT, refreshToken: refreshJWT };
  }
}
