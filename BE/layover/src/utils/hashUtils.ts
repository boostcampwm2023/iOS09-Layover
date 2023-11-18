import { createHash, createHmac } from 'crypto';

export function hashSHA256(input: string): string {
  const hash = createHash('sha256');
  hash.update(input);
  return hash.digest('hex');
}

export function hashHMACSHA256(message: string, secret: string): string {
  const hmac = createHmac('sha256', secret);
  hmac.update(message);

  const signature = hmac.digest('base64url');
  return signature;
}
