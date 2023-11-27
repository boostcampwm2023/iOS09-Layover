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
      status: 'RUNNING',
    });
    const savedBoard: Board = await this.boardRepository.save(boardEntity);
    return savedBoard.id;
  }
}
