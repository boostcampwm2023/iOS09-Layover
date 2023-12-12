import { PipeTransform, Injectable, Inject } from '@nestjs/common';
import { CustomResponse } from 'src/response/custom-response';
import { extractPayloadJWT, verifyJwtToken } from 'src/utils/jwtUtils';
import { ECustomCode } from '../response/ecustom-code.jenum';
import { tokenPayload } from 'src/utils/interfaces/token.payload';
import { createClient } from 'redis';

@Injectable()
export class JwtValidationPipe implements PipeTransform {
  @Inject('REDIS_FOR_BLACKLIST_CLIENT')
  private readonly redisBlacklistClient: ReturnType<typeof createClient>;

  async transform(header): Promise<tokenPayload> {
    const [tokenType, token] = header['authorization']?.split(' ');

    // 기본적으로 헤더에 각 데이터들이 들어있는지 확인
    if (tokenType && tokenType.toLowerCase() !== 'bearer') throw new CustomResponse(ECustomCode.NOT_BEARER_JWT);
    if (!token) throw new CustomResponse(ECustomCode.NO_DATA_JWT);

    // 1. signature 유효한지 검사
    await verifyJwtToken(token, process.env.JWT_SECRET_KEY);

    // 1-1. sign 검증됐으면.. payload 추출
    const payload = extractPayloadJWT(token);

    // 1-2. 없는 payload 항목이 있는지 검사
    if (
      !payload.aud ||
      !payload.exp ||
      !payload.iat ||
      !payload.iss ||
      !payload.jti ||
      !payload.memberHash ||
      !payload.memberId ||
      !payload.nbf ||
      !payload.sub
    )
      throw new CustomResponse(ECustomCode.NO_SOME_PAYLOAD_DATA_JWT);

    // 2. 블랙리스트에 올라가있는지 확인(access token)
    const value = await this.redisBlacklistClient.get(payload.jti);
    if (value !== null) throw new CustomResponse(ECustomCode.INVALID_JWT);

    // 3. issuer가 일치하는지 검사 (아직은 issuer만 확인)
    const issuer = process.env.LAYOVER_PUBLIC_IP;
    if (payload.iss != issuer) throw new CustomResponse(ECustomCode.JWT_INFO_ERR);

    // 4. exp를 지났는지 검사
    if (Math.floor(Date.now() / 1000) > payload.exp) throw new CustomResponse(ECustomCode.JWT_EXPIRED);

    // 5. jwt 페이로드를 넘겨줌 (객체형태)
    return payload;
  }
}
