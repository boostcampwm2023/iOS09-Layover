import { ApiProperty } from '@nestjs/swagger';

export class BoardResDto {
  @ApiProperty({
    example: 1,
    description: '게시글 ID',
  })
  id: number;

  @ApiProperty({
    example: 'https://qc66zhsq1708.edge.naverncp.com/hls/fMG98Ec1UirV-awtm4qKJyhanmRFlPLZbTs_/layover-station/sv_AVC_SD_1Pass_30fps.mp4/index.m3u8',
    description: '게시글 영상의 SD 화질 hls URL',
  })
  sd_url: string;

  @ApiProperty({
    example: 'https://qc66zhsq1708.edge.naverncp.com/hls/fMGEEU8c1UrV-awtm4qKyhaHnDymRFlPLZbTs_/layover-station/sv_AVC_HD_1Pass_30fps.mp4/index.m3u8',
    description: '게시글 영상의 HD 화질 hls URL',
  })
  hd_url: string;

  @ApiProperty({
    example: 'https://layover-video-thumbnail.kr.obj...',
    description: '게시글 영상의 썸네일 사진 key',
  })
  video_thumbnail: string;

  @ApiProperty({
    example: '37.0532156213',
    description: '게시글 위도 경도',
  })
  location: string;

  @ApiProperty({
    example: '붓산 광안리',
    description: '게시글 제목',
  })
  title: string;

  @ApiProperty({
    example: '날씨가 정말 좋았따이',
    description: '게시글 내용',
  })
  content: string;

  @ApiProperty({
    example: 'COMPLETE',
    description: '영상 인코딩 상태',
  })
  status: string;

  constructor(id: number, sd_url: string, hd_url: string, video_thumbnail: string, location: string, title: string, content: string, status: string) {
    this.id = id;
    this.sd_url = sd_url;
    this.hd_url = hd_url;
    this.video_thumbnail = video_thumbnail;
    this.location = location;
    this.title = title;
    this.content = content;
    this.status = status;
  }
}
