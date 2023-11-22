import { Enum, EnumType } from 'ts-jenum';
import { HttpStatus } from '@nestjs/common';

@Enum('customCode')
export class ECustomCode extends EnumType<ECustomCode>() {

  static readonly SUCCESS = new ECustomCode(
    HttpStatus.OK,
    'SUCCESS',
    '요청이 성공적으로 처리되었습니다.',
  );

  static readonly OAUTH01 = new ECustomCode(
    HttpStatus.UNAUTHORIZED,
    'OAUTH01',
    '회원가입이 되지 않은 유저입니다.',
  );

  static readonly OAUTH02 = new ECustomCode(
    HttpStatus.UNAUTHORIZED,
    'OAUTH02',
    '유효하지 않은 access token입니다.',
  );

  static readonly OAUTH03 = new ECustomCode(
    HttpStatus.UNAUTHORIZED,
    'OAUTH03',
    '사용자 정보를 받아오던 도중 오류가 발생했습니다.',
  );

  static readonly OAUTH04 = new ECustomCode(
    HttpStatus.UNAUTHORIZED,
    'OAUTH04',
    'token을 생성하는 과정에서 오류가 발생했습니다.',
  );

  static readonly OAUTH05 = new ECustomCode(
    HttpStatus.UNAUTHORIZED,
    'OAUTH05',
    'refresh token을 저장하는 과정에서 오류가 발생했습니다.',
  );

  static readonly OAUTH06 = new ECustomCode(
    HttpStatus.UNAUTHORIZED,
    'OAUTH06',
    '회원정보를 저장하는 과정에서 오류가 발생했습니다.',
  );

  static readonly OAUTH07 = new ECustomCode(
    HttpStatus.UNAUTHORIZED,
    'OAUTH07',
    'identity token을 사용한 인증이 불가능합니다.',
  );

  static readonly JWT01 = new ECustomCode(
    HttpStatus.UNAUTHORIZED,
    'JWT01',
    '유효하지 않은 토큰입니다.',
  );

  static readonly JWT02 = new ECustomCode(
    HttpStatus.UNAUTHORIZED,
    'JWT02',
    '토큰 만료기간이 경과하였습니다.',
  );

  static readonly JWT03 = new ECustomCode(
    HttpStatus.UNAUTHORIZED,
    'JWT03',
    '유효하지 않은 JWT 토큰입니다.',
  );

  static readonly JWT04 = new ECustomCode(
    HttpStatus.UNAUTHORIZED,
    'JWT04',
    '토큰 정보가 올바르지 않습니다.',
  );

  private constructor(
    readonly statusCode: HttpStatus,
    readonly customCode: string,
    readonly message: string,
  ) {
    super();
  }
}
