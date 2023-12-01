import { ApiProperty } from '@nestjs/swagger';

export class BoardResDto {
  @ApiProperty({
    example: 1,
    description: '게시글 ID',
  })
  id: number;

  @ApiProperty({
    example:
      'https://qc66zhsq1708.edge.naverncp.com/hls/fMG98Ec1UirV-awtm4qKJyhanmRFlPLZbTs_/layover-station/sv_AVC_HD, SD_1Pass_30fps.mp4/index.m3u8',
    description: 'ABR 이 적용된 인코딩 된 영상 url',
  })
  encoded_video_url: string;

  @ApiProperty({
    example: 'https://layover-video-thumbnail.kr.obj...',
    description: '게시글 영상의 썸네일 사진 url',
  })
  video_thumbnail_url: string;

  @ApiProperty({
    example: '37.0532156213',
    description: '게시글 위도',
  })
  latitude: number;

  @ApiProperty({
    example: '37.0532156213',
    description: '게시글 경도',
  })
  longitude: number;

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

  constructor(
    id: number,
    encoded_video_url: string,
    video_thumbnail: string,
    latitude: number,
    longitude: number,
    title: string,
    content: string,
    status: string,
  ) {
    this.id = id;
    this.encoded_video_url = encoded_video_url;
    this.video_thumbnail_url = video_thumbnail;
    this.latitude = latitude;
    this.longitude = longitude;
    this.title = title;
    this.content = content;
    this.status = status;
  }
}
