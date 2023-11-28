import { ApiProperty } from '@nestjs/swagger';

export class MemberInfosResDto {
  @ApiProperty({
    example: 221,
    description: '요청한 회원의 id 값(해당 회원을 유일하게 구분하는 값)',
  })
  id: number;

  @ApiProperty({
    example: 'hwani',
    description: '요청한 회원의 닉네임',
  })
  username: string;

  @ApiProperty({
    example: 'Hi, my name is hwani',
    description: '요청한 회원의 자기소개',
  })
  introduce: string;

  @ApiProperty({
    example: 'https://layover-profile-image.kr.obj...',
    description: '요청한 회원의 프로필 이미지를 다운받을 수 있는 url',
  })
  profile_image_url: string;

  constructor(id: number, username: string, introduce: string, profile_image_url: string) {
    this.id = id;
    this.username = username;
    this.introduce = introduce;
    this.profile_image_url = profile_image_url;
  }
}
