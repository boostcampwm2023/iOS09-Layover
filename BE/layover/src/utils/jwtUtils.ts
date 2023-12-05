import { ACCESS_TOKEN_EXP_IN_SECOND, REFRESH_TOKEN_EXP_IN_SECOND } from 'src/config';
import { CustomResponse } from 'src/response/custom-response';
import { ECustomCode } from '../response/ecustom-code.jenum';
import { v4 } from 'uuid';
import { tokenPayload } from './interfaces/token.payload';
import { hashHMACSHA256 } from './hashUtils';
import verifyAppleToken from 'verify-apple-id-token';

type tokenType = 'access' | 'refresh';

export function makeJwtPaylaod(token: tokenType, memberHash: string, memberId: number): any {
  const issuedNumericDate = Math.floor(Date.now() / 1000); // 현재 시점을 numericDate 형식으로 저장, Date.now()는 밀리세컨드 단위라 세컨드 단위로 나타내기 위해 1000으로 나눔.
  const expirationPeriod = token === 'access' ? ACCESS_TOKEN_EXP_IN_SECOND : REFRESH_TOKEN_EXP_IN_SECOND;
  const uuid = v4();

  return {
    iss: `${process.env.LAYOVER_PUBLIC_IP}`,
    exp: issuedNumericDate + expirationPeriod,
    sub: `${memberHash}`,
    aud: `${process.env.LAYOVER_PUBLIC_IP}`,
    nbf: issuedNumericDate,
    iat: issuedNumericDate,
    jti: uuid,
    memberHash: `${memberHash}`,
    memberId,
  };
}

export function extractHeaderJWTstr(token: string): string {
  const regex = /^([^\.]+)/;
  const match = token.match(regex);
  if (match) {
    return match[1];
  } else {
    throw new CustomResponse(ECustomCode.JWT01);
  }
}

export function extractHeaderJWT(token: string) {
  const header = extractHeaderJWTstr(token);
  return JSON.parse(Buffer.from(header, 'base64url').toString('utf8'));
}

export function extractPayloadJWTstr(token: string): string {
  const regex = /\.(.*?)\./g;
  const data = token.match(regex);
  if (!data) throw new CustomResponse(ECustomCode.JWT01);
  const payload = data[0].slice(1, -1);
  return payload;
}

export function extractPayloadJWT(token: string): tokenPayload {
  const payload = extractPayloadJWTstr(token);
  return JSON.parse(Buffer.from(payload, 'base64url').toString('utf8'));
}

export function extractSignatureJWTstr(token: string): string {
  const regex = /\.([^.]+)$/;
  const match = token.match(regex);
  if (match) {
    return match[1];
  } else {
    throw new CustomResponse(ECustomCode.JWT01);
  }
}

export async function verifyJwtToken(token: string, key?: string): Promise<boolean> {
  const headerStr = extractHeaderJWTstr(token);
  const payloadStr = extractPayloadJWTstr(token);
  const signatureStr = extractSignatureJWTstr(token);

  const algType = extractHeaderJWT(token).alg;
  switch (algType) {
    case 'HS256':
      if (signatureStr !== hashHMACSHA256(headerStr + '.' + payloadStr, key)) throw new CustomResponse(ECustomCode.JWT03);
      break;
    case 'RS256':
      await verifyAppleToken({
        idToken: token,
        clientId: 'kr.codesquad.boostcamp8.Layover',
      });
      break;
    default:
      throw new CustomResponse(ECustomCode.JWT07);
  }

  return true;
}
