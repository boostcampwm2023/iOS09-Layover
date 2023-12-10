import { Injectable } from '@nestjs/common';
import { Member, memberStatus } from './member.entity';
import { MemberRepository } from './member.repository';

export type memberExistence = 'EXIST' | 'DELETED' | 'NOTEXIST';

@Injectable()
export class MemberService {
  constructor(private memberRepository: MemberRepository) {}

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
}
