import { Injectable } from '@nestjs/common';
import { Member } from './member.entity';
import { MemberRepository } from './member.repository';

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
    await this.memberRepository.saveMember(username, profile_image_key, introduce, provider, hash);
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

  async deleteMember(id: number): Promise<void> {
    await this.memberRepository.deleteMember(id);
  }

  async getUsernameById(id: number): Promise<string> {
    return await this.memberRepository.findUsernameById(id);
  }

  async isMemberExistByHash(hash: string): Promise<boolean> {
    const member = await this.memberRepository.findMemberByHash(hash);
    return member !== null; // 이렇게 비교해도 되겟지?
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
