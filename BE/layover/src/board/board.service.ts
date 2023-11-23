import { Inject, Injectable } from '@nestjs/common';
import * as AWS from 'aws-sdk';
import { hashSHA256 } from '../utils/hashUtils';
import { Repository } from 'typeorm';
import { Board } from './board.entity';
import { MemberService } from '../member/member.service';
import { VideoService } from '../video/video.service';
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

    const videoHash: string = hashSHA256(`${filename}.${filetype}`);

    const preSignedUrl: string = s3.getSignedUrl('putObject', {
      Bucket: process.env.NCLOUD_S3_BUCKET_NAME,
      Key: videoHash,
      Expires: 60 * 60, // URL 만료되는 시간(초 단위)
      ContentType: `video/${filetype}`,
    });
    return { preSignedUrl };
  }

  async createBoard(
    title: string,
    content: string,
    location: string,
  ): Promise<number> {
    //1. 토큰내의 payload로 id를 가져오고, member db에서 엔티티를 가져온다.

    //2. video db에 엔티티를 하나 생성한다. (sd url과 hd url은 그냥 비워둔 상태로, 그리고 id를 반환 받는다.)
    const video: Video = await this.videoService.createEmptyVideo();
    const boardEntity: Board = this.boardRepository.create({
      video: video,
      title: title,
      content: content,
      original_video_url: '',
      video_thumbnail: '',
      location: location,
    });
    const savedBoard = await this.boardRepository.save(boardEntity);
    return savedBoard.id;
  }
}
