import { Injectable, Inject } from '@nestjs/common';
import { firstValueFrom, catchError } from 'rxjs';
import { REFRESH_TOKEN_EXP_IN_SECOND } from 'src/config';
import { HttpService } from '@nestjs/axios';
import { JwtService } from '@nestjs/jwt';
import { MemberService } from 'src/member/member.service';
import { extractPayloadJWT, makeJwtPaylaod, verifyJwtToken } from 'src/utils/jwtUtils';
import { createClient } from 'redis';
import { CustomResponse } from 'src/response/custom-response';
import { AxiosError } from 'axios';
import { hashSHA256 } from 'src/utils/hashUtils';
import { ECustomCode } from '../response/ecustom-code.jenum';
import { TokenResDto } from './dtos/token-res.dto';

@Injectable()
export class OauthService {
  constructor(
    private readonly httpService: HttpService,
    private readonly memberService: MemberService,
    private readonly jwtService: JwtService,
    @Inject('REDIS_CLIENT')
    private readonly redisClient: ReturnType<typeof createClient>,
  ) {}

  async getMemberIdByKakaoAccessToken(accessToken: string): Promise<string> {
    const kakaoUserInfoURL = 'https://kapi.kakao.com/v2/user/me';
    const observableRes = this.httpService
      .post(
        kakaoUserInfoURL,
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
          throw new CustomResponse(ECustomCode.OAUTH03);
        }),
      );
    const response = await firstValueFrom(observableRes);
    if (!response.data.id)
      // 일단 카카오에선 요청이 거절되거나 해도 이 id 필드는 필수로 주는 것 같긴하지만 일단 예외처리 함
      throw new CustomResponse(ECustomCode.OAUTH02);
    const uniqueMemberId = String(response.data.id);
    return uniqueMemberId;
  }

  async getKakaoMemberHash(accessToken: string): Promise<string> {
    const memberId = await this.getMemberIdByKakaoAccessToken(accessToken);
    return hashSHA256(memberId + 'kakao'); // kakao 내에선 유일하겠지만 apple과 겹칠 수 있어서 뒤에 스트링 하나 추가
  }

  getAppleMemberHash(identityToken: string): string {
    const jwtPayload = extractPayloadJWT(identityToken);
    if (!jwtPayload.sub) throw new CustomResponse(ECustomCode.OAUTH07);
    const memberId = jwtPayload.sub;
    return hashSHA256(memberId + 'apple'); // kakao 내에선 유일하겠지만 apple과 겹칠 수 있어서 뒤에 스트링 하나 추가
  }

  async verifyAppleIdentityToken(identityToken: string) {
    try {
      await verifyJwtToken(identityToken);
    } catch (e) {
      throw new CustomResponse(ECustomCode.OAUTH07);
    }
  }

  async isMemberExistByHash(hash: string): Promise<boolean> {
    return await this.memberService.isMemberExistByHash(hash);
  }

  async isExistUsername(username: string) {
    return await this.memberService.isExistUsername(username);
  }

  async signup(memberHash: string, username: string, provider: string): Promise<void> {
    try {
      await this.memberService.createMember(username, 'default.jpeg', 'default introduce', provider, memberHash);
    } catch (e) {
      throw new CustomResponse(ECustomCode.OAUTH06);
    }
  }

  async login(memberHash: string): Promise<TokenResDto> {
    // 유저 정보가 db에 있는지(==회원가입된 유저인지) 확인
    const isUserExist = await this.isMemberExistByHash(memberHash);
    if (!isUserExist) {
      throw new CustomResponse(ECustomCode.OAUTH01);
    }

    // 각 토큰 반환
    return this.generateAccessRefreshTokens(memberHash);
  }

  async generateAccessRefreshTokens(memberHash: string): Promise<TokenResDto> {
    // memberHash로부터 해당 회원이 저장된 db pk를 찾아옴.
    const member = await this.memberService.getMemberByHash(memberHash);
    const memberId = member.id;

    // access, refresh token 생성
    const accessTokenPaylaod = makeJwtPaylaod('access', memberHash, memberId);
    const refreshTokenPaylaod = makeJwtPaylaod('refresh', memberHash, memberId);

    let accessJWT: string;
    let refreshJWT: string;

    try {
      accessJWT = await this.jwtService.signAsync(accessTokenPaylaod);
      refreshJWT = await this.jwtService.signAsync(refreshTokenPaylaod);
    } catch (e) {
      throw new CustomResponse(ECustomCode.OAUTH04);
    }

    try {
      // refresh token은 redis에 저장, 유효기간도 추가
      this.redisClient.setEx(refreshJWT, REFRESH_TOKEN_EXP_IN_SECOND, memberHash);
    } catch (e) {
      throw new CustomResponse(ECustomCode.OAUTH05);
    }

    // 각 토큰 반환
    return new TokenResDto(accessJWT, refreshJWT);
  }
}
