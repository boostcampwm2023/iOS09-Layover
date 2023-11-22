import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { Video } from '../video/video.entity';
import { Member } from '../member/member.entity';

@Entity()
export class Board {
  @PrimaryGeneratedColumn('increment')
  id: number;

  @ManyToOne(() => Member, (member) => member.id)
  @JoinColumn({ name: 'member_id' })
  member: Member;

  @ManyToOne(() => Video, (video) => video.id)
  @JoinColumn({ name: 'video_id' })
  video: Video;

  @Column({ nullable: false })
  title: string;

  @Column({ nullable: false })
  content: string;

  @Column({ nullable: false })
  original_video_url: string;

  @Column({ nullable: false })
  video_thumbnail: string;

  @Column({ nullable: false })
  location: string;
}
