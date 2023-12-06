import * as AWS from 'aws-sdk';

export function generateUploadPreSignedUrl(
  bucketname: string,
  filename: string,
  fileCategory: string,
  filetype: string,
) {
  const s3 = new AWS.S3({
    endpoint: process.env.NCLOUD_S3_ENDPOINT,
    credentials: {
      accessKeyId: process.env.NCLOUD_S3_ACCESS_KEY,
      secretAccessKey: process.env.NCLOUD_S3_SECRET_KEY,
    },
    region: process.env.NCLOUD_S3_REGION,
  });

  return s3.getSignedUrl('putObject', {
    Bucket: bucketname,
    Key: `${filename}.${filetype}`,
    Expires: 60 * 60, // URL 만료되는 시간(초 단위)
    ContentType: `${fileCategory}/${filetype}`,
  });
}

export function generateDownloadPreSignedUrl(bucketname: string, key: string) {
  const s3 = new AWS.S3({
    endpoint: process.env.NCLOUD_S3_ENDPOINT,
    credentials: {
      accessKeyId: process.env.NCLOUD_S3_ACCESS_KEY,
      secretAccessKey: process.env.NCLOUD_S3_SECRET_KEY,
    },
    region: process.env.NCLOUD_S3_REGION,
  });

  return s3.getSignedUrl('getObject', {
    Bucket: bucketname,
    Key: key,
    Expires: 60 * 60, // URL 만료되는 시간(초 단위)
  });
}
