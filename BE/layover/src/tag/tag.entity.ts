import { Board } from '../board/board.entity';
import { Column, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';

export class Tag {
  @PrimaryGeneratedColumn('increment')
  id: number;

  @ManyToOne(() => Board, (board) => board.id)
  board: Board;

  @Column({ nullable: false })
  tagname: string;
}
