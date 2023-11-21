import { Body, Controller, Post } from '@nestjs/common';
import { BoardService } from './board.service';
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
    return { preSignedUrl };
  }

  @Post()
  async createBoard(
    @Body('title') title: string,
    @Body('content') content: string,
    @Body('location') location: string,
  ) {
    await this.boardService.createBoard(title, content, location);

    return {
      title,
      content,
      location,
    };
  }
}
