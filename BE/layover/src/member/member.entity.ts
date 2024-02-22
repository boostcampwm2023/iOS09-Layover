import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

export type memberStatus = 'EXIST' | 'DELETED';

@Entity()
export class Member {
  @PrimaryGeneratedColumn('increment')
  id: number;

  @Column({ nullable: false, length: 20 })
  username: string;

  @Column({ nullable: false, length: 255 })
  profile_image_key: string;

  @Column({ nullable: false, length: 100 })
  introduce: string;

  @Column({ nullable: false, length: 255 })
  provider: string;

  @Column({ nullable: true, length: 255 })
  kakao_id: string;

  @Column({ nullable: true, length: 255 })
  apple_refresh_token: string;

  @Column({ nullable: false, length: 255 })
  hash: string;

  @Column({
    nullable: false,
    type: 'datetime',
    default: () => 'CURRENT_TIMESTAMP',
  })
  date_created: Date;

  @Column({
    nullable: false,
    length: 20,
  })
  status: memberStatus;

  constructor(
    id: number,
    username: string,
    profile_image_key: string,
    introduce: string,
    provider: string,
    hash: string,
    date_created: Date,
    status: memberStatus,
  ) {
    this.id = id;
    this.username = username;
    this.profile_image_key = profile_image_key;
    this.introduce = introduce;
    this.provider = provider;
    this.hash = hash;
    this.date_created = date_created;
    this.status = status;
  }
}
