import { Inject, Injectable } from '@nestjs/common';
import { MemberService } from 'src/member/member.service';
import { Report } from './report.entity';
import { Repository } from 'typeorm';
import { BoardService } from 'src/board/board.service';
import { ReportResDto } from './dtos/report-res.dto';

@Injectable()
export class ReportService {
  constructor(
    @Inject('REPORT_REPOSITORY') private readonly reportRepository: Repository<Report>,
    private readonly memberService: MemberService,
    private readonly boardService: BoardService,
  ) {}

  async createReport(memberId: number, boardId: number, reportType: string): Promise<ReportResDto> {
    const member = await this.memberService.getMemberById(memberId);
    const board = await this.boardService.getBoardById(boardId);
    await this.reportRepository.insert({
      member: member,
      board: board,
      report_type: reportType,
    });
    return new ReportResDto(member.id, board.id, reportType);
  }
}
