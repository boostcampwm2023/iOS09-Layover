import { Column, Entity, PrimaryColumn } from 'typeorm';

@Entity()
export class Video {
  @PrimaryColumn()
  id: string;

  @Column({ nullable: false })
  sd_url: string;

  @Column({ nullable: false })
  hd_url: string;
}
