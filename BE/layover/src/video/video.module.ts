import { Module } from '@nestjs/common';
import { DatabaseModule } from '../database/database.module';
import { videoProvider } from './video.provider';
import { VideoService } from './video.service';

@Module({
  imports: [DatabaseModule],
  providers: [...videoProvider, VideoService],
  exports: [VideoService],
})
export class VideoModule {}
