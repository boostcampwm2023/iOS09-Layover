import { Enum, EnumType } from 'ts-jenum';
import { HttpStatus } from '@nestjs/common';

export const enum EMessage {
  SUCCESS = '요청이 성공적으로 처리되었습니다.',
  NOT_SIGNUP_MEMBER = '회원가입이 되지 않은 유저입니다.',
  INVALID_KAKAO_TOKEN = '유효하지 않은 kakao access token입니다.',
  OAUTH_SERVER_ERR = 'OAuth 서버에서 사용자 정보를 받아오던 도중 오류가 발생했습니다.',
  TOKEN_GENERATE_ERR = 'token을 생성하는 과정에서 오류가 발생했습니다.',
  REFRESH_TOKEN_SAVE_ERR = 'refresh token을 저장하는 과정에서 오류가 발생했습니다.',
  SAVE_MEMBER_INFO_ERR = '회원정보를 저장하는 과정에서 오류가 발생했습니다.',
  INVALID_IDENTITY_TOKEN = '유효하지 않은identity token입니다.',
  NOT_JWT_TYPE = '토큰이 JWT 형식이 아닙니다.',
  JWT_EXPIRED = '토큰 만료기간이 경과하였습니다.',
  INVALID_JWT = '유효하지 않은 JWT 토큰입니다.',
  JWT_INFO_ERR = '토큰 정보가 올바르지 않습니다.',
  NOT_BEARER_JWT = '토큰 타입이 Bearer가 아닙니다.',
  NO_DATA_JWT = '토큰 데이터가 존재하지 않습니다.',
  NO_SOME_PAYLOAD_DATA_JWT = 'JWT payload에 필수 데이터가 모두 존재하지 않습니다.',
  ACCESS_TOKEN_NOT_EXPIRED = 'Access token 유효기간이 지나지 않았으므로 Refresh token을 이용한 재발급이 불가능합니다.',
  JWT_ALGORITHM_ERR = '지원하지 않는 알고리즘으로 서명된 토큰입니다.',
  DUPLICATED_USERNAME = '중복 닉네임이 존재합니다.',
  INVALID_MEMBER_ID = '존재하지 않는 회원 id 입니다.',
}

@Enum('message')
export class ECustomCode extends EnumType<ECustomCode>() {
  static readonly SUCCESS = new ECustomCode(HttpStatus.OK, EMessage.SUCCESS);

  static readonly NOT_SIGNUP_MEMBER = new ECustomCode(HttpStatus.UNAUTHORIZED, EMessage.NOT_SIGNUP_MEMBER);

  static readonly INVALID_KAKAO_TOKEN = new ECustomCode(HttpStatus.BAD_REQUEST, EMessage.INVALID_KAKAO_TOKEN);

  static readonly OAUTH_SERVER_ERR = new ECustomCode(HttpStatus.INTERNAL_SERVER_ERROR, EMessage.OAUTH_SERVER_ERR);

  static readonly TOKEN_GENERATE_ERR = new ECustomCode(HttpStatus.INTERNAL_SERVER_ERROR, EMessage.TOKEN_GENERATE_ERR);

  static readonly REFRESH_TOKEN_SAVE_ERR = new ECustomCode(
    HttpStatus.INTERNAL_SERVER_ERROR,
    EMessage.REFRESH_TOKEN_SAVE_ERR,
  );

  static readonly SAVE_MEMBER_INFO_ERR = new ECustomCode(
    HttpStatus.INTERNAL_SERVER_ERROR,
    EMessage.SAVE_MEMBER_INFO_ERR,
  );

  static readonly INVALID_IDENTITY_TOKEN = new ECustomCode(HttpStatus.BAD_REQUEST, EMessage.INVALID_IDENTITY_TOKEN);

  // static readonly OAUTH08 = new ECustomCode(HttpStatus.BAD_REQUEST, 'Apple public key를 받아오는데 실패했습니다.');

  static readonly NOT_JWT_TYPE = new ECustomCode(HttpStatus.BAD_REQUEST, EMessage.NOT_JWT_TYPE);

  static readonly JWT_EXPIRED = new ECustomCode(HttpStatus.UNAUTHORIZED, EMessage.JWT_EXPIRED);

  static readonly INVALID_JWT = new ECustomCode(HttpStatus.BAD_REQUEST, EMessage.INVALID_JWT);

  static readonly JWT_INFO_ERR = new ECustomCode(HttpStatus.BAD_REQUEST, EMessage.JWT_INFO_ERR);

  static readonly NOT_BEARER_JWT = new ECustomCode(HttpStatus.BAD_REQUEST, EMessage.NOT_BEARER_JWT);

  static readonly NO_DATA_JWT = new ECustomCode(HttpStatus.BAD_REQUEST, EMessage.NO_DATA_JWT);

  static readonly NO_SOME_PAYLOAD_DATA_JWT = new ECustomCode(HttpStatus.BAD_REQUEST, EMessage.NO_SOME_PAYLOAD_DATA_JWT);

  static readonly ACCESS_TOKEN_NOT_EXPIRED = new ECustomCode(HttpStatus.BAD_REQUEST, EMessage.ACCESS_TOKEN_NOT_EXPIRED);

  static readonly JWT_ALGORITHM_ERR = new ECustomCode(HttpStatus.BAD_REQUEST, EMessage.JWT_ALGORITHM_ERR);

  static readonly DUPLICATED_USERNAME = new ECustomCode(HttpStatus.BAD_REQUEST, EMessage.DUPLICATED_USERNAME);

  static readonly INVALID_MEMBER_ID = new ECustomCode(HttpStatus.BAD_REQUEST, EMessage.INVALID_MEMBER_ID);

  private constructor(
    readonly statusCode: HttpStatus,
    readonly message: string,
  ) {
    super();
  }
}
