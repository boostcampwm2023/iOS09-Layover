import { Inject, Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { Board } from './board.entity';
import { MemberService } from '../member/member.service';
import { VideoService } from '../video/video.service';
import { Member } from '../member/member.entity';
import { Video } from '../video/video.entity';
import { makeUploadPreSignedUrl } from 'src/utils/s3Utils';

@Injectable()
export class BoardService {
  constructor(
    @Inject('BOARD_REPOSITORY') private boardRepository: Repository<Board>,
    private memberService: MemberService,
    private videoService: VideoService,
  ) {}

  makePreSignedUrl(bucketname: string, filename: string, fileCategory: string, filetype: string): { preSignedUrl: string } {
    return makeUploadPreSignedUrl(bucketname, filename, fileCategory, filetype);
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
      filename: '',
      status: 'RUNNING',
    });
    const savedBoard: Board = await this.boardRepository.save(boardEntity);
    return savedBoard.id;
  }

  async setOriginalVideoUrl(filename: string) {
    const board: Board = await this.boardRepository.findOne({ where: { filename } });
    board.original_video_url = this.generateOriginalVideoHLS(filename);
    await this.boardRepository.save(board);
  }

  generateOriginalVideoHLS(filename: string) {
    return `${process.env.HLS_SCHEME}${process.env.HLS_ORIGIN_CDN}/hls/${process.env.HLS_ORIGIN_BUCKET_ENCRYPTED_NAME}
    /${filename}/index.m3u8`;
  }

  async setEncodedVideoUrl(filename: string) {
    const board: Board = await this.boardRepository.findOne({ where: { filename } });
    const video: Video = board.video;
    // filename 으로 sd 인지 hd 인지 구분해야함.

    if (filename === 'HD') {
      video.hd_url = this.generateEncodedVideoHLS(filename);
    }

    if (filename === 'SD') {
      video.hd_url = this.generateEncodedVideoHLS(filename);
    }

    await this.videoService.saveVideo(video);
  }

  generateEncodedVideoHLS(filename: string) {
    return `${process.env.HLS_SCHEME}${process.env.HLS_ENCODING_CDN}/hls/${process.env.HLS_ENCODING_BUCKET_ENCRYPTED_NAME}
    /${filename}/index.m3u8`;
  }
}
