import { Inject, Injectable } from '@nestjs/common';
import { MemberService } from 'src/member/member.service';
import { Report } from './report.entity';
import { Repository } from 'typeorm';

@Injectable()
export class ReportService {
  constructor(
    @Inject('REPORT_REPOSITORY') private readonly reportRepository: Repository<Report>,
    private readonly memberService: MemberService,
  ) {}

  async insertReport(memberId: number, reportType: string) {
    const member = await this.memberService.findMemberById(memberId);
    const reportEntity = this.reportRepository.create({
      member: member,
      report_type: reportType,
    });
    await this.reportRepository.insert(reportEntity);
  }
}
