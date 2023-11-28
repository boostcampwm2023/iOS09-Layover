import { Module } from '@nestjs/common';
import { TagService } from './tag.service';
import { tagProvider } from './tag.provider';
import { DatabaseModule } from '../database/database.module';

@Module({
  imports: [DatabaseModule],
  providers: [...tagProvider, TagService],
  exports: [TagService],
})
export class TagModule {}
