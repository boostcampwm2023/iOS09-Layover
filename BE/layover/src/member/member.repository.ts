import { Repository } from 'typeorm';
import { Member, memberStatus } from './member.entity';
import { Inject } from '@nestjs/common';

export class MemberRepository {
  constructor(@Inject('MEMBER_REPOSITORY') private memberRepository: Repository<Member>) {}

  async saveMember(
    username: string,
    profile_image_key: string,
    introduce: string,
    provider: string,
    hash: string,
    status: memberStatus,
  ): Promise<void> {
    await this.memberRepository.save({
      username,
      profile_image_key,
      introduce,
      provider,
      hash,
      status,
    });
  }

  async updateUsername(id: number, username: string): Promise<void> {
    await this.memberRepository.update({ id }, { username });
  }

  async updateIntroduce(id: number, introduce: string): Promise<void> {
    await this.memberRepository.update({ id }, { introduce });
  }

  async updateProfileImage(id: number, key: string): Promise<void> {
    await this.memberRepository.update({ id }, { profile_image_key: key });
  }

  async updateMemberStatus(id: number, status: memberStatus): Promise<void> {
    await this.memberRepository.update({ id }, { status });
  }

  async findUsernameById(id: number): Promise<string> {
    const member = await this.memberRepository.findOne({ where: { id } });
    return member.username;
  }

  async findMemberById(id: number): Promise<Member | null> {
    return await this.memberRepository.findOne({ where: { id } });
  }

  async findMemberByHash(hash: string): Promise<Member | null> {
    return await this.memberRepository.findOne({ where: { hash } });
  }

  async findMemberByUsername(username: string): Promise<Member | null> {
    return await this.memberRepository.findOne({ where: { username } });
  }
}
