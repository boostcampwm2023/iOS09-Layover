import { Inject, Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { Video } from './video.entity';

@Injectable()
export class VideoService {
  constructor(
    @Inject('VIDEO_REPOSITORY') private videoRepository: Repository<Video>,
  ) {}

  async createEmptyVideo(): Promise<Video> {
    const videoEntity = this.videoRepository.create({
      sd_url: '',
      hd_url: '',
    });
    return await this.videoRepository.save(videoEntity);
  }
}
