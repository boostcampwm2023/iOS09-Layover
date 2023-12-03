import { Body, Controller, Get, HttpStatus, Logger, Post, Query, Req } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import { BoardService } from './board.service';
import { ECustomCode } from '../response/ecustom-code.jenum';
import { CustomResponse } from '../response/custom-response';
import { PresignedUrlDto } from './dtos/presigned-url.dto';
import { CreateBoardDto } from './dtos/create-board.dto';
import { ApiHeader, ApiOperation, ApiResponse, ApiTags, getSchemaPath } from '@nestjs/swagger';
import { PresignedUrlResDto } from './dtos/presigned-url-res.dto';
import { CreateBoardResDto } from './dtos/create-board-res.dto';
import { UploadCallbackDto } from './dtos/upload-callback.dto';
import { EncodingCallbackDto } from './dtos/encoding-callback.dto';
import { CustomHeader } from '../pipes/custom-header.decorator';
import { JwtValidationPipe } from '../pipes/jwt.validation.pipe';
import { BoardsResDto } from './dtos/boards-res.dto';
import { SWAGGER } from '../utils/swaggerUtils';
import { BOARD_SWAGGER } from './board.swagger';

@ApiTags('게시물(영상 포함) API')
@Controller('board')
export class BoardController {
  private readonly logger: Logger = new Logger(BoardController.name);

  constructor(private readonly boardService: BoardService) {}

  @ApiOperation({
    summary: '게시글 생성 요청',
    description: '게시글에 들어갈 내용들과 함께 업로드를 요청합니다.',
  })
  @ApiResponse(BOARD_SWAGGER.CREATE_BOARD_SUCCESS)
  @ApiHeader(SWAGGER.AUTHORIZATION_HEADER)
  @Post()
  async createBoard(@CustomHeader(new JwtValidationPipe()) payload: any, @Body() createBoardDto: CreateBoardDto) {
    const savedBoard: CreateBoardResDto = await this.boardService.createBoard(
      payload.memberId,
      createBoardDto.title,
      createBoardDto.content,
      createBoardDto.latitude,
      createBoardDto.longitude,
      createBoardDto.tag,
    );
    throw new CustomResponse(ECustomCode.SUCCESS, savedBoard);
  }

  @ApiOperation({
    summary: 'presigned url 요청',
    description: 'object storage에 영상을 업로드 하기 위한 presigned url을 요청합니다.',
  })
  @ApiResponse(BOARD_SWAGGER.GET_PRESIGNED_URL_SUCCESS)
  @ApiHeader(SWAGGER.AUTHORIZATION_HEADER)
  @Post('presigned-url')
  async getPresignedUrl(@CustomHeader(new JwtValidationPipe()) payload: any, @Body() presignedUrlDto: PresignedUrlDto) {
    const [filename, filetype] = [uuidv4(), presignedUrlDto.filetype];
    const bucketname = process.env.NCLOUD_S3_ORIGINAL_BUCKET_NAME;

    const { preSignedUrl } = this.boardService.makePreSignedUrl(bucketname, filename, 'video', filetype);
    throw new CustomResponse(ECustomCode.SUCCESS, { preSignedUrl });
  }

  @ApiOperation({
    summary: '홈 화면 게시글 조회',
    description: '랜덤 게시물 (최대) 10개를 조회합니다.',
  })
  @ApiResponse(BOARD_SWAGGER.GET_BOARD_SUCCESS)
  @ApiHeader(SWAGGER.AUTHORIZATION_HEADER)
  @Get('home')
  async getBoardRandom() {
    const boardsRestDto: BoardsResDto[] = await this.boardService.getBoardRandom();
    throw new CustomResponse(ECustomCode.SUCCESS, boardsRestDto);
  }

  @ApiOperation({
    summary: '지도 화면 게시글 조회',
    description: '거리에 따라 지도 화면에 보여질 게시물들을 조회합니다.',
  })
  @ApiResponse(BOARD_SWAGGER.GET_BOARD_SUCCESS)
  @ApiHeader(SWAGGER.AUTHORIZATION_HEADER)
  @Get('map')
  async getBoardMap(@Query('latitude') latitude: string, @Query('longitude') longitude: string) {
    const boardsRestDto: BoardsResDto[] = await this.boardService.getBoardMap(latitude, longitude);
    throw new CustomResponse(ECustomCode.SUCCESS, boardsRestDto);
  }

  @ApiResponse(BOARD_SWAGGER.GET_BOARD_SUCCESS)
  @ApiHeader(SWAGGER.AUTHORIZATION_HEADER)
  @Get('tag')
  async getBoardTag(@Query('tag') tag: string) {
    const boardsRestDto: BoardsResDto[] = await this.boardService.getBoardTag(tag);
    throw new CustomResponse(ECustomCode.SUCCESS, boardsRestDto);
  }

  @ApiOperation({
    summary: '원본 영상 업로드 완료 콜백',
    description: '클라이언트를 통해 원본 영상이 업로드 되면 호출되고, 원본 hls link 를 db에 저장합니다.',
  })
  @Post('/upload-callback')
  async uploadCallback(@Body() uploadCallbackRequestDto: UploadCallbackDto) {
    this.logger.log(`[In] upload-callback: ${uploadCallbackRequestDto.filename}`);
    // await this.boardService.setOriginalVideoUrl(uploadCallbackRequestDto.filename);
    this.logger.log(`[Out] upload-callback: ${uploadCallbackRequestDto.filename}`);
    throw new CustomResponse(ECustomCode.SUCCESS);
  }

  // @ApiOperation({
  //   summary: '인코딩 완료 콜백',
  //   description: '인코딩 상태에 따라 호출되어지며, 내부의 status에 따라 인코딩된 영상의 hls link를 db에 저장합니다.',
  // })
  // @Post('/encoding-callback')
  // async encodingCallback(@Body() encodingCallbackRequestDto: EncodingCallbackDto) {
  //   this.logger.log(`[In] encoding-callback: ${encodingCallbackRequestDto.filePath}`);
  //   // status 를 구분한다.
  //   switch (encodingCallbackRequestDto.status) {
  //     case 'WAITING':
  //       this.logger.log(`[Out] encoding-callback: !WAITING!`);
  //       break;
  //     case 'RUNNING':
  //       this.logger.log(`[Out] encoding-callback: !RUNNING!`);
  //       break;
  //     case 'FAILURE':
  //       this.logger.log(`[Out] encoding-callback: !FAILURE!`);
  //       break;
  //     case 'COMPLETE':
  //       this.logger.log(`[Out] encoding-callback: !COMPLETE!`);
  //       // dto 에서 filename 을 파싱한다.
  //       // const filename = encodingCallbackRequestDto.filePath;
  //       // await this.boardService.setEncodedVideoUrl(filename);
  //       break;
  //     default:
  //   }
  //   throw new CustomResponse(ECustomCode.SUCCESS);
  // }
  @Post('/encoding-callback')
  async encodingCallback(@Req() request: Request) {
    this.logger.log(request);
    throw new CustomResponse(ECustomCode.SUCCESS);
  }
}
