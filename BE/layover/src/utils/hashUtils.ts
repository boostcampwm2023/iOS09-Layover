import { createHash } from 'crypto';

export function hashSHA256(input: string): string {
  const hash = createHash('sha256');
  hash.update(input);
  return hash.digest('hex');
}
