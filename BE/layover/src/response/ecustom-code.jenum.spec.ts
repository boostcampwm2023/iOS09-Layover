import { ECustomCode } from './ecustom-code.jenum';

describe('ts-jenum 테스트', () => {
  it('ts-jenum 기본 케이스 검증', () => {
    expect('' + ECustomCode.OAUTH01).toBe(ECustomCode.OAUTH01.customCode);
  });
});
