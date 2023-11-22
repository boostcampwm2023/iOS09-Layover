import { Body, Controller, Post } from '@nestjs/common';
import { BoardService } from './board.service';
import {ECustomCode} from "../response/ecustom-code.jenum.";
import {CustomResponse} from "../response/custom-response";
@Controller('board')
export class BoardController {
  constructor(private readonly boardService: BoardService) {}

  @Post('presigned-url')
  async getPresignedUrl(
    @Body('filename') filename: string,
    @Body('filetype') filetype: string,
  ) {
    const { preSignedUrl } = this.boardService.makePreSignedUrl(
      filename,
      filetype,
    );
    throw new CustomResponse(ECustomCode.SUCCESS, { preSignedUrl });
  }

  @Post()
  async createBoard(
    @Body('title') title: string,
    @Body('content') content: string,
    @Body('location') location: string,
  ) {
    await this.boardService.createBoard(title, content, location);
    throw new CustomResponse(ECustomCode.SUCCESS);
  }
}
