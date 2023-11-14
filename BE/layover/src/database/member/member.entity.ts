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

  @Column()
  username: string;

  @Column()
  profile_image_url: string;

  @Column()
  introduce: string;

  @Column()
  provider: string;

  @Column()
  hash: string;

  @Column()
  date_created: Date;
}
