import { Board } from 'src/board/board.entity';
import { Member } from 'src/member/member.entity';
import { Column, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class Report {
  @PrimaryGeneratedColumn('increment')
  id: number;

  @ManyToOne(() => Member, (member) => member.id)
  @JoinColumn({ name: 'member_id' })
  member: Member;

  @ManyToOne(() => Board, (board) => board.id)
  @JoinColumn({ name: 'board_id' })
  board: Board;

  @Column({ nullable: false, length: 255 })
  report_type: string;
}
