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
    date_created: Date,
  ): Promise<void> {
    const memberEntity = this.memberRepository.create({
      username,
      profile_image_url,
      introduce,
      provider,
      hash,
      date_created,
    });
    await this.memberRepository.save(memberEntity);
  }

  async isMemberExistByHash(hash: string): Promise<boolean> {
    const member = await this.memberRepository.find({
      where: {
        hash,
      },
    });
    if (member) return true;
    else return false;
  }
}
