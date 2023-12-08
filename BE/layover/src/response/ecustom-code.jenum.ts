import { Enum, EnumType } from 'ts-jenum';
import { HttpStatus } from '@nestjs/common';

@Enum('customCode')
export class ECustomCode extends EnumType<ECustomCode>() {
  static readonly SUCCESS = new ECustomCode(HttpStatus.OK, 'SUCCESS', '요청이 성공적으로 처리되었습니다.');

  static readonly OAUTH01 = new ECustomCode(HttpStatus.UNAUTHORIZED, 'OAUTH01', '회원가입이 되지 않은 유저입니다.');

  static readonly OAUTH02 = new ECustomCode(HttpStatus.BAD_REQUEST, 'OAUTH02', '유효하지 않은 kakao access token입니다.');

  static readonly OAUTH03 = new ECustomCode(
    HttpStatus.INTERNAL_SERVER_ERROR,
    'OAUTH03',
    'OAuth 서버에서 사용자 정보를 받아오던 도중 오류가 발생했습니다.',
  );

  static readonly OAUTH04 = new ECustomCode(HttpStatus.INTERNAL_SERVER_ERROR, 'OAUTH04', 'token을 생성하는 과정에서 오류가 발생했습니다.');

  static readonly OAUTH05 = new ECustomCode(HttpStatus.INTERNAL_SERVER_ERROR, 'OAUTH05', 'refresh token을 저장하는 과정에서 오류가 발생했습니다.');

  static readonly OAUTH06 = new ECustomCode(HttpStatus.INTERNAL_SERVER_ERROR, 'OAUTH06', '회원정보를 저장하는 과정에서 오류가 발생했습니다.');

  static readonly OAUTH07 = new ECustomCode(HttpStatus.BAD_REQUEST, 'OAUTH07', '유효하지 않은identity token입니다.');

  static readonly OAUTH08 = new ECustomCode(HttpStatus.BAD_REQUEST, 'OAUTH08', 'Apple public key를 받아오는데 실패했습니다.');

  static readonly JWT01 = new ECustomCode(HttpStatus.BAD_REQUEST, 'JWT01', '토큰이 JWT 형식이 아닙니다.');

  static readonly JWT02 = new ECustomCode(HttpStatus.UNAUTHORIZED, 'JWT02', '토큰 만료기간이 경과하였습니다.');

  static readonly JWT03 = new ECustomCode(HttpStatus.BAD_REQUEST, 'JWT03', '유효하지 않은 JWT 토큰입니다.');

  static readonly JWT04 = new ECustomCode(HttpStatus.BAD_REQUEST, 'JWT04', '토큰 정보가 올바르지 않습니다.');

  static readonly JWT05 = new ECustomCode(HttpStatus.BAD_REQUEST, 'JWT05', '토큰 타입이 Bearer가 아닙니다.');

  static readonly JWT06 = new ECustomCode(HttpStatus.BAD_REQUEST, 'JWT06', '토큰 데이터가 존재하지 않습니다.');

  static readonly JWT07 = new ECustomCode(HttpStatus.BAD_REQUEST, 'JWT07', '지원하지 않는 알고리즘으로 서명된 토큰입니다.');

  static readonly MEMBER01 = new ECustomCode(HttpStatus.BAD_REQUEST, 'MEMBER01', '중복 닉네임이 존재합니다.');

  static readonly MEMBER02 = new ECustomCode(HttpStatus.BAD_REQUEST, 'MEMBER02', '존재하지 않는 회원 id 입니다.');

  private constructor(
    readonly statusCode: HttpStatus,
    readonly customCode: string,
    readonly message: string,
  ) {
    super();
  }
}
