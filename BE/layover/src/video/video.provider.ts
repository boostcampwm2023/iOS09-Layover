import { DataSource } from 'typeorm';
import { Video } from './video.entity';

export const videoProvider = [
  {
    provide: 'VIDEO_REPOSITORY',
    useFactory: (dataSource: DataSource) => dataSource.getRepository(Video),
    inject: ['DATA_SOURCE'],
  },
];
