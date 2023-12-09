import * as AWS from 'aws-sdk';

const contentTypes = {
  // Video types
  avi: 'video/x-msvideo',
  mov: 'video/quicktime',
  mp4: 'video/mp4',
  '3gp': 'video/3gpp',
  mpg: 'video/mpeg',
  mpeg: 'video/mpeg',
  m4v: 'video/x-m4v',
  vob: 'video/x-ms-vob',
  wmv: 'video/x-ms-wmv',
  asf: 'video/x-ms-asf',
  mkv: 'video/x-matroska',
  flv: 'video/x-flv',
  webm: 'video/webm',
  av1: 'video/av1',
  mxf: 'application/mxf',
  // Image types
  jpeg: 'image/jpeg',
  jpg: 'image/jpeg',
  png: 'image/png',
  gif: 'image/gif',
  bmp: 'image/bmp',
  tiff: 'image/tiff',
  svg: 'image/svg+xml',
  webp: 'image/webp',
  ico: 'image/x-icon',
  heic: 'image/heic',
  avif: 'image/avif',
};

export function generateUploadPreSignedUrl(bucketname: string, filename: string, filetype: string) {
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
    ContentType: contentTypes[filetype],
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
