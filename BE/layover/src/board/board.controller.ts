import { Body, Controller, Post } from '@nestjs/common';
import * as AWS from 'aws-sdk';
@Controller('board')
export class BoardController {
  @Post('presigned-url')
  async getPresignedUrl(@Body('filename') filename: string) {
    const s3 = new AWS.S3({
      endpoint: 'https://kr.object.ncloudstorage.com',
      credentials: {
        accessKeyId: process.env.NCLOUD_S3_ACCESS_KEY,
        secretAccessKey: process.env.NCLOUD_S3_SECRET_KEY,
      },
      region: 'kr-standard',
    });

    const preSignedUrl: string = s3.getSignedUrl('putObject', {
      Bucket: process.env.NCLOUD_S3_BUCKET_NAME,
      Key: `${filename}.mp4`,
      Expires: 60 * 60, // URL이 만료되는 시간(초 단위)
      ContentType: 'video/mp4',
    });
    console.log(preSignedUrl);
    return { preSignedUrl };
  }
}
