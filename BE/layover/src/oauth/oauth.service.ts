import { HttpService } from '@nestjs/axios';
import { Injectable, Inject } from '@nestjs/common';
import { firstValueFrom } from 'rxjs';
import { MemberService } from 'src/database/member/member.service';
import { JwtService } from '@nestjs/jwt';
import { getJwtPaylaod } from 'src/utils/jwtUtils';
import { createClient } from 'redis';
import { REFRESH_TOKEN_EXP_IN_SECOND } from 'src/config';

@Injectable()
export class OauthService {
  constructor(
    private readonly httpService: HttpService,
    private readonly memberService: MemberService,
    private readonly jwtService: JwtService,
    @Inject('REDIS_CLIENT')
    private readonly redisClient: ReturnType<typeof createClient>,
  ) {}

  async getMemberIdByAccessToken(
    url: string,
    accessToken: string,
  ): Promise<string> {
    const observableRes = this.httpService.post(
      url,
      {},
      {
        headers: {
          Authorization: `Bearer ${accessToken}`,
          'Content-type': 'application/x-www-form-urlencoded;charset=utf-8',
        },
      },
    );
    const response = await firstValueFrom(observableRes);
    const uniqueMemberId = String(response.data.id);
    return uniqueMemberId;
  }

  isMemberExistByHash(hash: string): Promise<boolean> {
    return this.memberService.isMemberExistByHash(hash);
  }

  async signup(
    memberHash: string,
    username: string,
    provider: string,
  ): Promise<void> {
    await this.memberService.insertMember(
      username,
      'default profile_image_url',
      'default introduce',
      provider,
      memberHash,
    );
  }

  async login(
    memberHash: string,
  ): Promise<{ accessJWT: string; refreshJWT: string }> {
    // access token 생성
    const accessTokenPaylaod = getJwtPaylaod('access', memberHash);
    const accessJWT = await this.jwtService.signAsync(accessTokenPaylaod);

    // refresh token 생성
    const refreshTokenPaylaod = getJwtPaylaod('refresh', memberHash);
    const refreshJWT = await this.jwtService.signAsync(refreshTokenPaylaod);

    // refresh token은 redis에 저장, 유효기간도 추가
    this.redisClient.setEx(refreshJWT, REFRESH_TOKEN_EXP_IN_SECOND, memberHash);

    // 각 토큰 반환
    return {
      accessJWT,
      refreshJWT,
    };
  }
}
