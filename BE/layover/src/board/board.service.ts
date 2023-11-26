import { Inject, Injectable } from '@nestjs/common';
import * as AWS from 'aws-sdk';
import { Repository } from 'typeorm';
import { Board } from './board.entity';
import { MemberService } from '../member/member.service';
import { VideoService } from '../video/video.service';
import { Member } from '../member/member.entity';
import { Video } from '../video/video.entity';

@Injectable()
export class BoardService {
  constructor(
    @Inject('BOARD_REPOSITORY') private boardRepository: Repository<Board>,
    private memberService: MemberService,
    private videoService: VideoService,
  ) {}

  makePreSignedUrl(filename: string, filetype: string) {
    const s3 = new AWS.S3({
      endpoint: process.env.NCLOUD_S3_ENDPOINT,
      credentials: {
        accessKeyId: process.env.NCLOUD_S3_ACCESS_KEY,
        secretAccessKey: process.env.NCLOUD_S3_SECRET_KEY,
      },
      region: process.env.NCLOUD_S3_REGION,
    });

    const preSignedUrl: string = s3.getSignedUrl('putObject', {
      Bucket: process.env.NCLOUD_S3_BUCKET_NAME,
      Key: `${filename}.${filetype}`,
      Expires: 60 * 60, // URL 만료되는 시간(초 단위)
      ContentType: `video/${filetype}`,
    });
    return { preSignedUrl };
  }

  async createBoard(userId: number, title: string, content: string, location: string): Promise<number> {
    const member: Member = await this.memberService.findMemberById(userId);
    const video: Video = await this.videoService.createEmptyVideo();
    const boardEntity: Board = this.boardRepository.create({
      member: member,
      video: video,
      title: title,
      content: content,
      original_video_url: '',
      video_thumbnail: '',
      location: location,
    });
    const savedBoard: Board = await this.boardRepository.save(boardEntity);
    return savedBoard.id;
  }
}
