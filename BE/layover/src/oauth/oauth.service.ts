import { Injectable, Inject } from '@nestjs/common';
import { firstValueFrom } from 'rxjs';
import { REFRESH_TOKEN_EXP_IN_SECOND } from 'src/config';
import { HttpService } from '@nestjs/axios';
import { JwtService } from '@nestjs/jwt';
import { MemberService } from 'src/database/member/member.service';
import { makeJwtPaylaod } from 'src/utils/jwtUtils';
import { createClient } from 'redis';
import { CustomException, ECustomException } from 'src/custom-exception';
import { hashHMACSHA256 } from 'src/utils/hashUtils';

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
    // 유저 정보가 db에 있는지(==회원가입된 유저인지) 확인
    const isUserExist = await this.isMemberExistByHash(memberHash);
    if (!isUserExist) {
      throw new CustomException(ECustomException.OAUTH01);
    }

    // 각 토큰 반환
    return this.generateAccessRefreshTokens(memberHash);
  }

  async generateAccessRefreshTokens(
    memberHash: string,
  ): Promise<{ accessJWT: string; refreshJWT: string }> {
    // access token 생성
    const accessTokenPaylaod = makeJwtPaylaod('access', memberHash);
    // OAUTH04
    const accessJWT = await this.jwtService.signAsync(accessTokenPaylaod);

    // refresh token 생성
    const refreshTokenPaylaod = makeJwtPaylaod('refresh', memberHash);
    // OAUTH04
    const refreshJWT = await this.jwtService.signAsync(refreshTokenPaylaod);

    // refresh token은 redis에 저장, 유효기간도 추가
    // OAUTH05
    this.redisClient.setEx(refreshJWT, REFRESH_TOKEN_EXP_IN_SECOND, memberHash);

    // 각 토큰 반환
    return {
      accessJWT,
      refreshJWT,
    };
  }

  // verifyAsync 함수로 간단하게 jwt를 검증할 수도 있지만, 어떤로 jwt 검증이 실패하는지 나누기 위해 직접 함수를 만듦.
  async validateJWT(token: string, issuer: string): Promise<void> {
    // 1. signature 유효한지 검사
    const headerStr = this.extractHeaderJWTstr(token);
    const payloadStr = this.extractPayloadJWTstr(token);
    const signatureStr = this.extractSignatureJWTstr(token);
    if (
      signatureStr !==
      hashHMACSHA256(headerStr + '.' + payloadStr, process.env.JWT_SECRET_KEY)
    )
      throw new CustomException(ECustomException.JWT01);

    // 1-1. payload 추출
    const payload = this.extractPayloadJWT(token);

    // 2. issuer가 일치하는지 검사 (아직은 issuer만 확인)
    if (payload.iss != issuer)
      throw new CustomException(ECustomException.JWT01);

    // 3. exp를 지났는지 검사
    if (Math.floor(Date.now() / 1000) > payload.exp)
      throw new CustomException(ECustomException.JWT02);
  }

  extractHeaderJWTstr(token: string): string {
    const regex = /^([^\.]+)/;
    const match = token.match(regex);
    if (match) {
      return match[1];
    } else {
      throw new CustomException(ECustomException.JWT01);
    }
  }

  extractPayloadJWTstr(token: string): string {
    const regex = /\.(.*?)\./g;
    const data = token.match(regex);
    if (!data) throw new CustomException(ECustomException.JWT01);
    const payload = data[0].slice(1, -1);
    return payload;
  }

  extractPayloadJWT(token: string) {
    const payload = this.extractPayloadJWTstr(token);
    return JSON.parse(Buffer.from(payload, 'base64url').toString('utf8'));
  }

  extractSignatureJWTstr(token: string): string {
    const regex = /\.([^.]+)$/;
    const match = token.match(regex);
    if (match) {
      return match[1];
    } else {
      throw new CustomException(ECustomException.JWT01);
    }
  }
}
