import { Inject, Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { Video } from './video.entity';

@Injectable()
export class VideoService {
  constructor(@Inject('VIDEO_REPOSITORY') private videoRepository: Repository<Video>) {}

  async createVideo(videoName: string): Promise<string> {
    const videoEntity: Video = this.videoRepository.create({
      id: videoName,
      sd_url: '',
      hd_url: '',
    });
    const savedVideo: Video = await this.videoRepository.save(videoEntity);
    return savedVideo.id;
  }
}
