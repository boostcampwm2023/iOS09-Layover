import { Injectable, Inject } from '@nestjs/common';
import { Repository } from 'typeorm';
import { Member } from './member.entity';
import { makeDownloadPreSignedUrl, makeUploadPreSignedUrl } from 'src/utils/s3Utils';

@Injectable()
export class MemberService {
  constructor(@Inject('MEMBER_REPOSITORY') private memberRepository: Repository<Member>) {}

  async insertMember(username: string, profile_image_key: string, introduce: string, provider: string, hash: string): Promise<void> {
    const memberEntity = this.memberRepository.create({
      username,
      profile_image_key,
      introduce,
      provider,
      hash,
    });
    await this.memberRepository.save(memberEntity);
  }

  async updateUsername(id: number, username: string) {
    await this.memberRepository.update({ id }, { username });
  }

  async updateIntroduce(id: number, introduce: string) {
    await this.memberRepository.update({ id }, { introduce });
  }

  async updateProfileImage(id: number, key: string) {
    await this.memberRepository.update({ id }, { profile_image_key: key });
  }

  async deleteMember(id: number) {
    await this.memberRepository.delete({ id });
  }

  async selectUsername(id: number): Promise<string> {
    const member = await this.memberRepository.findOne({ where: { id } });
    return member.username;
  }

  async isMemberExistByHash(hash: string): Promise<boolean> {
    const member = await this.memberRepository.find({
      where: {
        hash,
      },
    });
    return member.length !== 0;
  }

  async isExistUsername(username: string): Promise<boolean> {
    const member = await this.memberRepository.find({ where: { username } });
    return member.length !== 0;
  }

  async findMemberById(id: number): Promise<Member> {
    return await this.memberRepository.findOne({ where: { id } });
  }

  async findMemberByHash(memberHash: string): Promise<Member> {
    return await this.memberRepository.findOne({ where: { hash: memberHash } });
  }

  makeUploadPreSignedUrl(bucketname: string, filename: string, fileCategory: string, filetype: string): { preSignedUrl: string } {
    return makeUploadPreSignedUrl(bucketname, filename, fileCategory, filetype);
  }

  makeDownloadPresignedUrl(bucketname: string, key: string): { preSignedUrl: string } {
    return makeDownloadPreSignedUrl(bucketname, key);
  }
}
