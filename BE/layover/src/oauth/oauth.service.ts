import { Injectable, Inject } from '@nestjs/common';
import { firstValueFrom, catchError } from 'rxjs';
import { REFRESH_TOKEN_EXP_IN_SECOND } from 'src/config';
import { HttpService } from '@nestjs/axios';
import { JwtService } from '@nestjs/jwt';
import { MemberService } from 'src/database/member/member.service';
import { extractPayloadJWT, makeJwtPaylaod } from 'src/utils/jwtUtils';
import { createClient } from 'redis';
import { CustomException, ECustomException } from 'src/custom-exception';
import { AxiosError } from 'axios';
import { hashSHA256 } from 'src/utils/hashUtils';

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
    const observableRes = this.httpService
      .post(
        url,
        {},
        {
          headers: {
            Authorization: `Bearer ${accessToken}`,
            'Content-type': 'application/x-www-form-urlencoded;charset=utf-8',
          },
        },
      )
      .pipe(
        catchError((error: AxiosError) => {
          console.log(`${error} occured!`);
          throw new CustomException(ECustomException.OAUTH03);
        }),
      );
    const response = await firstValueFrom(observableRes);
    if (!response.data.id)
      // 일단 카카오에선 요청이 거절되거나 해도 이 id 필드는 필수로 주는 것 같긴하지만 일단 예외처리 함
      throw new CustomException(ECustomException.OAUTH02);
    const uniqueMemberId = String(response.data.id);
    return uniqueMemberId;
  }

  async getKakaoMemberHash(accessToken: string): Promise<string> {
    const kakaoUserInfoURL = 'https://kapi.kakao.com/v2/user/me';
    const memberId = await this.getMemberIdByAccessToken(
      kakaoUserInfoURL,
      accessToken,
    );
    return hashSHA256(memberId + 'kakao'); // kakao 내에선 유일하겠지만 apple과 겹칠 수 있어서 뒤에 스트링 하나 추가
  }

  getAppleMemberHash(identityToken: string): string {
    const jwtPayload = extractPayloadJWT(identityToken);
    if (!jwtPayload.sub) throw new CustomException(ECustomException.OAUTH07);
    const memberId = jwtPayload.sub;
    return hashSHA256(memberId + 'apple'); // kakao 내에선 유일하겠지만 apple과 겹칠 수 있어서 뒤에 스트링 하나 추가
  }

  isMemberExistByHash(hash: string): Promise<boolean> {
    return this.memberService.isMemberExistByHash(hash);
  }

  async signup(
    memberHash: string,
    username: string,
    provider: string,
  ): Promise<void> {
    try {
      await this.memberService.insertMember(
        username,
        'default profile_image_url',
        'default introduce',
        provider,
        memberHash,
      );
    } catch (e) {
      throw new CustomException(ECustomException.OAUTH06);
    }
  }

  async login(
    memberHash: string,
  ): Promise<{ accessJWT: string; refreshJWT: string }> {
    // 유저 정보가 db에 있는지(==회원가입된 유저인지) 확인
    const isUserExist = await this.isMemberExistByHash(memberHash);
    if (!isUserExist) {
      throw new CustomException(ECustomException.OAUTH01, { memberHash });
    }

    // 각 토큰 반환
    return this.generateAccessRefreshTokens(memberHash);
  }

  async generateAccessRefreshTokens(
    memberHash: string,
  ): Promise<{ accessJWT: string; refreshJWT: string }> {
    // memberHash로부터 해당 회원이 저장된 db pk를 찾아옴.
    const memberId = 777;

    // access, refresh token 생성
    const accessTokenPaylaod = makeJwtPaylaod('access', memberHash, memberId);
    const refreshTokenPaylaod = makeJwtPaylaod('refresh', memberHash, memberId);

    let accessJWT: string;
    let refreshJWT: string;

    try {
      accessJWT = await this.jwtService.signAsync(accessTokenPaylaod);
      refreshJWT = await this.jwtService.signAsync(refreshTokenPaylaod);
    } catch (e) {
      throw new CustomException(ECustomException.OAUTH04);
    }

    try {
      // refresh token은 redis에 저장, 유효기간도 추가
      this.redisClient.setEx(
        refreshJWT,
        REFRESH_TOKEN_EXP_IN_SECOND,
        memberHash,
      );
    } catch (e) {
      throw new CustomException(ECustomException.OAUTH05);
    }

    // 각 토큰 반환
    return {
      accessJWT,
      refreshJWT,
    };
  }
}
