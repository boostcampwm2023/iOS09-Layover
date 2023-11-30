export interface tokenPayload {
  iss: string;
  exp: number;
  sub: string;
  aud: string;
  nbf: number;
  iat: number;
  jti: string;
  memberHash: string;
  memberId: number;
}
