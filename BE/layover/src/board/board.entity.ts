import { Column, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { Member } from '../member/member.entity';
import { Tag } from '../tag/tag.entity';

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
  encoded_video_url: string;

  @Column({ nullable: false, type: 'double' })
  latitude: number;

  @Column({ nullable: false, type: 'double' })
  longitude: number;

  @Column()
  filename: string;

  @OneToMany(() => Tag, (tag) => tag.board)
  tags: Tag[];

  @Column({ nullable: false })
  status: string;
}
