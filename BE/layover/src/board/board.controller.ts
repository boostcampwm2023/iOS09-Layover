import { Body, Controller, HttpStatus, Post } from '@nestjs/common';
import { BoardService } from './board.service';
import { ECustomCode } from '../response/ecustom-code.jenum.';
import { CustomResponse } from '../response/custom-response';
import { PresignedUrlDto } from './dtos/presigned-url.dto';
import { CreateBoardDto } from './dtos/create-board.dto';
import {
  ApiOperation,
  ApiResponse,
  ApiTags,
  getSchemaPath,
} from '@nestjs/swagger';
import { PresignedUrlResDto } from './dtos/presigned-url-res.dto';

@ApiTags('게시물(영상 포함) API')
@Controller('board')
export class BoardController {
  constructor(private readonly boardService: BoardService) {}
  @ApiOperation({
    summary: 'presigned url 요청',
    description:
      'object storage에 영상을 업로드 하기 위한 presigned url을 요청합니다.',
  })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'presigned url 요청 성공',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'SUCCESS' },
        message: { type: 'string', example: '성공' },
        statusCode: { type: 'number', example: HttpStatus.OK },
        data: { $ref: getSchemaPath(PresignedUrlResDto) },
      },
    },
  })
  @Post('presigned-url')
  async getPresignedUrl(@Body() presignedUrlDto: PresignedUrlDto) {
    const [filename, filetype] = [
      presignedUrlDto.filename,
      presignedUrlDto.filetype,
    ];

    const { preSignedUrl } = this.boardService.makePreSignedUrl(
      filename,
      filetype,
    );

    throw new CustomResponse(ECustomCode.SUCCESS, { preSignedUrl });
  }

  @ApiOperation({
    summary: '게시글 업로드 요청',
    description: '게시글에 들어갈 내용들과 함께 업로드를 요청합니다.',
  })
  @ApiResponse({
    status: HttpStatus.OK,
    description: '게시글 업로드 요청 성공',
    schema: {
      type: 'object',
      properties: {
        customCode: { type: 'string', example: 'SUCCESS' },
        message: { type: 'string', example: '성공' },
        statusCode: { type: 'number', example: HttpStatus.OK },
      },
    },
  })
  @Post()
  async createBoard(@Body() createBoardDto: CreateBoardDto) {
    const [title, content, location] = [
      createBoardDto.title,
      createBoardDto.content,
      createBoardDto.location,
    ];
    await this.boardService.createBoard(title, content, location);
    throw new CustomResponse(ECustomCode.SUCCESS);
  }
}
