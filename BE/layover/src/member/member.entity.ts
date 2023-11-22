import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

/*
CREATE TABLE layover_member
(
     id INT PRIMARY KEY AUTO_INCREMENT,
     username VARCHAR(20) NOT NULL,
     profile_image_url VARCHAR(255) NOT NULL,
     introduce VARCHAR(100) NOT NULL,
     provider VARCHAR(255) NOT NULL,
     hash VARCHAR(255) NOT NULL,
     date_created DATETIME NOT NULL,
)
*/

@Entity()
export class Member {
  @PrimaryGeneratedColumn('increment')
  id: string;

  @Column({ nullable: false })
  username: string;

  @Column({ nullable: false })
  profile_image_url: string;

  @Column({ nullable: false })
  introduce: string;

  @Column({ nullable: false })
  provider: string;

  @Column({ nullable: false })
  hash: string;

  @Column({
    nullable: false,
    type: 'datetime',
    default: () => 'CURRENT_TIMESTAMP',
  })
  date_created: Date;
}
