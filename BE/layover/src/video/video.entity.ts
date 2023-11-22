import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class Video {
  @PrimaryGeneratedColumn('increment')
  id: number;

  @Column({ nullable: false })
  sd_url: string;

  @Column({ nullable: false })
  hd_url: string;
}
