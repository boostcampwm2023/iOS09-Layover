import { Inject, Injectable } from '@nestjs/common';
import { Member, memberStatus } from './member.entity';
import { MemberRepository } from './member.repository';
import { createClient } from 'redis';
import { HttpService } from '@nestjs/axios';

export type memberExistence = 'EXIST' | 'DELETED' | 'NOTEXIST';

@Injectable()
export class MemberService {
  constructor(
    private memberRepository: MemberRepository,
    @Inject('REDIS_CLIENT')
    private readonly redisClient: ReturnType<typeof createClient>,
    @Inject('REDIS_FOR_BLACKLIST_CLIENT')
    private readonly redisBlacklistClient: ReturnType<typeof createClient>,
    private readonly httpService: HttpService,
  ) {}

  async createMember(
    username: string,
    profile_image_key: string,
    introduce: string,
    provider: string,
    kakao_id: string,
    apple_refresh_token: string,
    hash: string,
  ): Promise<void> {
    await this.memberRepository.saveMember(
      username,
      profile_image_key,
      introduce,
      provider,
      kakao_id,
      apple_refresh_token,
      hash,
      'EXIST',
    );
  }

  async updateUsername(id: number, username: string): Promise<void> {
    await this.memberRepository.updateUsername(id, username);
  }

  async updateIntroduce(id: number, introduce: string): Promise<void> {
    await this.memberRepository.updateIntroduce(id, introduce);
  }

  async updateProfileImage(id: number, key: string): Promise<void> {
    await this.memberRepository.updateProfileImage(id, key);
  }

  async updateMemberStatusById(id: number, status: memberStatus): Promise<void> {
    await this.memberRepository.updateMemberStatus(id, status);
  }

  async getUsernameById(id: number): Promise<string> {
    return await this.memberRepository.findUsernameById(id);
  }

  async isMemberExistByHash(hash: string): Promise<memberExistence> {
    const member = await this.memberRepository.findMemberByHash(hash);
    if (member) {
      return member.status === 'EXIST' ? 'EXIST' : 'DELETED';
    }
    return 'NOTEXIST';
  }

  async isExistUsername(username: string): Promise<boolean> {
    const member = await this.memberRepository.findMemberByUsername(username);
    return member !== null;
  }

  async getMemberById(id: number): Promise<Member | null> {
    return await this.memberRepository.findMemberById(id);
  }

  async getMemberByHash(memberHash: string): Promise<Member | null> {
    return await this.memberRepository.findMemberByHash(memberHash);
  }

  async addAccessTokenToBlackList(jti: string, exp: number, memberHash: string): Promise<void> {
    // JWT의 고유한 값인 jti를 이용해 redis에 해당 JWT를 블랙리스트로 등록, exp 이후 삭제되게 설정
    await this.redisBlacklistClient.setEx(jti, exp, memberHash);
  }

  async deleteExistRefreshTokenFromRedis(memberHash: string): Promise<void> {
    const refreshJti = await this.redisClient.get(memberHash);
    await this.redisClient.del(refreshJti);
    await this.redisClient.del(memberHash);
  }

  async revokeKakao(kakaoId: string): Promise<void> {
    const data = {
      target_id_type: 'user_id',
      target_id: kakaoId,
      scopes: ['profile_nickname', 'profile_image'],
    };
    this.httpService.post('https://kapi.kakao.com/v2/user/revoke/scopes', data, {
      headers: {
        Authorization: `KakaoAK ${process.env.KAKAO_APP_ADMIN_KET}`,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    });
  }

  async revokeApple(appleRefreshToken: string): Promise<void> {
    const data = {
      client_id: process.env.APPLE_CLIENT_ID,
      client_secret: process.env.APPLE_CLIENT_SECRET,
      token: appleRefreshToken,
      token_type_hint: 'refresh_token',
    };
    this.httpService.post('https://appleid.apple.com/auth/revoke', data, {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    });
  }
}
