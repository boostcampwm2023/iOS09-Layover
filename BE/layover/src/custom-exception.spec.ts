import { CustomCode, ECustomException } from './custom-exception';

describe('ts-jenum 테스트', () => {
  it('ts-jenum 기본 케이스 검증', () => {
    expect('' + ECustomException.OAUTH01).toBe(
      ECustomException.OAUTH01.customCode,
    );

    expect(ECustomException.OAUTH01.statusCode).toBe(401);
    expect(ECustomException.OAUTH01.customCode).toBe('OAUTH01');

    expect(ECustomException.valueOf(CustomCode.OAUTH01)).toBe(
      ECustomException.OAUTH01,
    );
  });
});
