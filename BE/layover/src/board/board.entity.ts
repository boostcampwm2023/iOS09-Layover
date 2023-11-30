import { Column, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { Member } from '../member/member.entity';

@Entity()
export class Board {
  @PrimaryGeneratedColumn('increment')
  id: number;

  @ManyToOne(() => Member, (member) => member.id)
  @JoinColumn({ name: 'member_id' })
  member: Member;

  @Column({ nullable: false })
  title: string;

  @Column({ nullable: false })
  content: string;

  @Column({ nullable: false })
  original_video_url: string;

  @Column({ nullable: false })
  encoded_video_url: string;

  @Column({ nullable: false })
  video_thumbnail: string;

  @Column({ nullable: false, type: 'double' })
  latitude: number;

  @Column({ nullable: false, type: 'double' })
  longitude: number;

  @Column()
  filename: string;

  @Column({ nullable: false })
  status: string;
}
