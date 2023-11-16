import { Injectable, Inject } from '@nestjs/common';
import { Repository } from 'typeorm';
import { Member } from './member.entity';

@Injectable()
export class MemberService {
  constructor(
    @Inject('MEMBER_REPOSITORY') private memberRepository: Repository<Member>,
  ) {}

  async insertMember(
    username: string,
    profile_image_url: string,
    introduce: string,
    provider: string,
    hash: string,
  ): Promise<void> {
    const memberEntity = this.memberRepository.create({
      username,
      profile_image_url,
      introduce,
      provider,
      hash,
    });
    await this.memberRepository.save(memberEntity);
  }

  async isMemberExistByHash(hash: string): Promise<boolean> {
    const member = await this.memberRepository.find({
      where: {
        hash,
      },
    });
    if (member.length === 0) return false;
    else return true;
  }
}
