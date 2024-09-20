import { Module } from '@nestjs/common';
import { TagService } from './tag.service';
import { tagProvider } from './tag.provider';
import { DatabaseModule } from '../database/database.module';
import { TagRepository } from './tag.repository';

@Module({
  imports: [DatabaseModule],
  providers: [...tagProvider, TagService, TagRepository],
  exports: [TagService],
})
export class TagModule {}
