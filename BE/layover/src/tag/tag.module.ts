import { Module } from '@nestjs/common';
import { TagService } from './tag.service';
import { tagProvider } from './tag.provider';

@Module({
  providers: [...tagProvider, TagService],
})
export class TagModule {}
