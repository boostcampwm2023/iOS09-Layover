import {
  ACCESS_TOKEN_EXP_IN_SECOND,
  REFRESH_TOKEN_EXP_IN_SECOND,
} from 'src/config';

type tokenType = 'access' | 'refresh';

export function getJwtPaylaod(token: tokenType, memberHash: string): any {
  const issuedNumericDate = Math.floor(Date.now() / 1000); // 현재 시점을 numericDate 형식으로 저장, Date.now()는 밀리세컨드 단위라 세컨드 단위로 나타내기 위해 1000으로 나눔.
  const expirationPeriod =
    token === 'access'
      ? ACCESS_TOKEN_EXP_IN_SECOND
      : REFRESH_TOKEN_EXP_IN_SECOND;
  const uuid = 1234;

  return {
    iss: `${process.env.LAYOVER_PUBLIC_IP}`,
    exp: issuedNumericDate + expirationPeriod,
    sub: `Layover${token}Token`,
    aud: `${process.env.LAYOVER_PUBLIC_IP}`,
    nbf: issuedNumericDate,
    iat: issuedNumericDate,
    jti: uuid,
    memberHash: `${memberHash}`,
  };
}
