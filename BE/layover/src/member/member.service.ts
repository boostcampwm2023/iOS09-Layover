import { Inject, Injectable } from '@nestjs/common';
import { Member, memberStatus } from './member.entity';
import { MemberRepository } from './member.repository';
import { createClient } from 'redis';

export type memberExistence = 'EXIST' | 'DELETED' | 'NOTEXIST';

@Injectable()
export class MemberService {
  constructor(
    private memberRepository: MemberRepository,
    @Inject('REDIS_CLIENT')
    private readonly redisClient: ReturnType<typeof createClient>,
  ) {}

  async createMember(
    username: string,
    profile_image_key: string,
    introduce: string,
    provider: string,
    hash: string,
  ): Promise<void> {
    await this.memberRepository.saveMember(username, profile_image_key, introduce, provider, hash, 'EXIST');
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
    await this.redisClient.setEx(jti, exp, memberHash);
  }

  async deleteExistRefreshTokenFromRedis(memberHash: string): Promise<void> {
    const refreshJti = await this.redisClient.get(memberHash);
    await this.redisClient.del(refreshJti);
    await this.redisClient.del(memberHash);
  }
}
