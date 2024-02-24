import { Injectable, Inject } from '@nestjs/common';
import { firstValueFrom, catchError } from 'rxjs';
import { REFRESH_TOKEN_EXP_IN_SECOND } from 'src/config';
import { HttpService } from '@nestjs/axios';
import { JwtService } from '@nestjs/jwt';
import { MemberService, memberExistence } from 'src/member/member.service';
import { extractPayloadJWT, makeJwtPaylaod, verifyJwtToken } from 'src/utils/jwtUtils';
import { createClient } from 'redis';
import { CustomResponse } from 'src/response/custom-response';
import { AxiosError } from 'axios';
import { hashSHA256 } from 'src/utils/hashUtils';
import { ECustomCode } from '../response/ecustom-code.jenum';
import { TokenResDto } from './dtos/token-res.dto';
import { BoardService } from 'src/board/board.service';

@Injectable()
export class OauthService {
  constructor(
    private readonly httpService: HttpService,
    private readonly memberService: MemberService,
    private readonly boardService: BoardService,
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
          throw new CustomResponse(ECustomCode.OAUTH_SERVER_ERR);
        }),
      );
    const response = await firstValueFrom(observableRes);
    if (!response.data.id)
      // 일단 카카오에선 요청이 거절되거나 해도 이 id 필드는 필수로 주는 것 같긴하지만 일단 예외처리 함
      throw new CustomResponse(ECustomCode.INVALID_KAKAO_TOKEN);
    const uniqueMemberId = String(response.data.id);
    return uniqueMemberId;
  }

  async getKakaoMemberHash(accessToken: string): Promise<string> {
    const memberId = await this.getMemberIdByKakaoAccessToken(accessToken);
    return hashSHA256(memberId + 'kakao'); // kakao 내에선 유일하겠지만 apple과 겹칠 수 있어서 뒤에 스트링 하나 추가
  }

  getAppleMemberHash(identityToken: string): string {
    const jwtPayload = extractPayloadJWT(identityToken);
    if (!jwtPayload.sub) throw new CustomResponse(ECustomCode.INVALID_IDENTITY_TOKEN);
    const memberId = jwtPayload.sub;
    return hashSHA256(memberId + 'apple'); // kakao 내에선 유일하겠지만 apple과 겹칠 수 있어서 뒤에 스트링 하나 추가
  }

  async verifyAppleIdentityToken(identityToken: string) {
    try {
      await verifyJwtToken(identityToken);
    } catch (e) {
      throw new CustomResponse(ECustomCode.INVALID_IDENTITY_TOKEN);
    }
  }

  async isMemberExistByHash(hash: string): Promise<memberExistence> {
    return await this.memberService.isMemberExistByHash(hash);
  }

  async isExistUsername(username: string) {
    return await this.memberService.isExistUsername(username);
  }

  async getMemberIdByHash(hash: string): Promise<number> {
    return (await this.memberService.getMemberByHash(hash)).id;
  }

  async recoverUserData(id: number) {
    this.memberService.updateMemberStatusById(id, 'EXIST');
    this.boardService.updateBoardsStatusByMemberId(id, 'INACTIVE', 'COMPLETE');
  }

  async signup(
    memberHash: string,
    username: string,
    provider: string,
    kakao_id: string,
    apple_refresh_token: string,
  ): Promise<void> {
    try {
      await this.memberService.createMember(
        username,
        'default',
        '',
        provider,
        kakao_id,
        apple_refresh_token,
        memberHash,
      );
    } catch (e) {
      throw new CustomResponse(ECustomCode.SAVE_MEMBER_INFO_ERR);
    }
  }

  async login(memberHash: string): Promise<TokenResDto> {
    // 유저 정보가 db에 있는지(==회원가입된 유저인지) 확인
    const isUserExist = await this.isMemberExistByHash(memberHash);
    console.log(isUserExist);
    if (isUserExist !== 'EXIST') {
      throw new CustomResponse(ECustomCode.NOT_SIGNUP_MEMBER);
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

    let accessJWTstr: string;
    let refreshJWTstr: string;

    try {
      accessJWTstr = await this.jwtService.signAsync(accessTokenPaylaod);
      refreshJWTstr = await this.jwtService.signAsync(refreshTokenPaylaod);
    } catch (e) {
      throw new CustomResponse(ECustomCode.TOKEN_GENERATE_ERR);
    }

    try {
      // refresh token의 jti는 redis에 저장, 유효기간도 추가
      const refreshToken = extractPayloadJWT(refreshJWTstr);
      await this.redisClient.setEx(refreshToken.jti, REFRESH_TOKEN_EXP_IN_SECOND, memberHash);
      await this.redisClient.setEx(memberHash, REFRESH_TOKEN_EXP_IN_SECOND, refreshToken.jti);
    } catch (e) {
      throw new CustomResponse(ECustomCode.REFRESH_TOKEN_SAVE_ERR);
    }

    // 각 토큰 반환
    return new TokenResDto(accessJWTstr, refreshJWTstr);
  }

  async isRefreshTokenValid(refreshToken: string): Promise<void> {
    const value = await this.redisClient.get(refreshToken);
    if (value === null) throw new CustomResponse(ECustomCode.INVALUD_REFRESH_TOKEN);
  }

  async addAccessTokenToBlackList(jti: string, exp: number, memberHash: string): Promise<void> {
    // JWT의 고유한 값인 jti를 이용해 redis에 해당 JWT를 블랙리스트로 등록, exp 이후 삭제되게 설정
    await this.redisClient.setEx(jti, exp, memberHash);
  }

  async deleteExistRefreshTokenFromRedis(memberHash: string): Promise<void> {
    const refreshJti: string = await this.redisClient.get(memberHash);
    await this.redisClient.del(refreshJti);
    await this.redisClient.del(memberHash);
  }

  async getAppleRefreshToken(authorization_code: string): Promise<string> {
    const data = {
      client_id: process.env.APPLE_CLIENT_ID,
      client_secret: process.env.APPLE_CLIENT_SECRET,
      code: authorization_code,
      grant_type: 'authorization_code',
      redirect_uri: process.env.APPLE_REDIRECT_URI,
    };
    const observableRes = this.httpService
      .post('https://appleid.apple.com/auth/token', data, {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      })
      .pipe(
        catchError((error: AxiosError) => {
          console.log(`${error} occured!`);
          throw new CustomResponse(ECustomCode.OAUTH_SERVER_ERR);
        }),
      );
    const response = await firstValueFrom(observableRes);
    if (!response.data.refresh_token) throw new CustomResponse(ECustomCode.INVALID_APPLE_TOKEN);
    const appleRefreshToken = String(response.data.refresh_token);
    return appleRefreshToken;
  }
}
