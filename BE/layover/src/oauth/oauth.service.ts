import { HttpService } from '@nestjs/axios';
import { Injectable } from '@nestjs/common';
import { firstValueFrom } from 'rxjs';
// import { MemberService } from 'src/database/member/member.service';

@Injectable()
export class OauthService {
  constructor(
    private readonly httpService: HttpService, // private readonly memberService: MemberService,
  ) {}

  async getAccessToken(url: string, code: string): Promise<string> {
    const observableRes = this.httpService.post(
      url,
      {
        grant_type: 'authorization_code',
        client_id: process.env.KAKAO_CLIENT_ID,
        redirect_uri: process.env.KAKAO_REDIRECT_URI,
        code,
      },
      {
        headers: {
          'Content-type': 'application/x-www-form-urlencoded;charset=utf-8',
        },
      },
    );
    const response = await firstValueFrom(observableRes);
    const accessToken = response.data.access_token;
    return accessToken;
  }

  async getEmailByAccessToken(
    url: string,
    accessToken: string,
  ): Promise<string> {
    const queryString = `?property_keys=["kakao_account.email"]`;
    const observableRes = this.httpService.post(
      url + queryString,
      {},
      {
        headers: {
          Authorization: `Bearer ${accessToken}`,
          'Content-type': 'application/x-www-form-urlencoded;charset=utf-8',
        },
      },
    );
    const response = await firstValueFrom(observableRes);
    const eamil = response.data.kakaoAccount.email;
    return eamil;
  }

  // isMemberExistByHash(hash: string): Promise<boolean> {
  //  return this.memberService.isMemberExistByHash(hash);
  //}

  doSignup() {}

  doLogin(): { accessJWT: string; refreshJWT: string } {
    return {
      accessJWT: '1234',
      refreshJWT: '5678',
    };
  }

  // 로그아웃! 해서 Auth 서버에도 토큰 지우기
  //returnAccessToken(accessToken: string): void {
  //  this.httpService.post('https://kapi.kakao.com/v1/user/logout');
  //}
}
