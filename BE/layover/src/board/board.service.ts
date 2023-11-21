import { Injectable } from '@nestjs/common';
import * as AWS from 'aws-sdk';
import { hashSHA256 } from '../utils/hashUtils';

@Injectable()
export class BoardService {
  makePreSignedUrl(filename: string, filetype: string) {
    const s3 = new AWS.S3({
      endpoint: process.env.NCLOUD_S3_ENDPOINT,
      credentials: {
        accessKeyId: process.env.NCLOUD_S3_ACCESS_KEY,
        secretAccessKey: process.env.NCLOUD_S3_SECRET_KEY,
      },
      region: process.env.NCLOUD_S3_REGION,
    });

    const videoHash: string = hashSHA256(`${filename}.${filetype}`);

    const preSignedUrl: string = s3.getSignedUrl('putObject', {
      Bucket: process.env.NCLOUD_S3_BUCKET_NAME,
      Key: videoHash,
      Expires: 60 * 60, // URL 만료되는 시간(초 단위)
      ContentType: `video/${filetype}`,
    });
    return { preSignedUrl };
  }

  createBoard(title: string, content: string, location: string) {}
}
