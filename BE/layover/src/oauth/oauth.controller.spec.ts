import { Test, TestingModule } from '@nestjs/testing';
import { OauthController } from './oauth.controller';
import { OauthService } from './oauth.service';
import { CustomResponse } from 'src/response/custom-response';
import { ECustomCode } from 'src/response/ecustom-code.jenum';
import { TokenResDto } from './dtos/token-res.dto';

describe('oauthController', () => {
  let oauthController: OauthController;

  const jwtRegEx = /^[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+$/;
  const mockOauthService = {
    getKakaoMemberHash: jest.fn(),
    getAppleMemberHash: jest.fn(),
    verifyAppleIdentityToken: jest.fn(),
    login: jest.fn(),
    isMemberExistByHash: jest.fn(),
    signup: jest.fn(),
    isExistUsername: jest.fn(),
    generateAccessRefreshTokens: jest.fn(),
  };

  beforeEach(async () => {
    const app: TestingModule = await Test.createTestingModule({
      controllers: [OauthController],
      providers: [
        {
          provide: OauthService,
          useValue: mockOauthService,
        },
      ],
    }).compile();

    oauthController = app.get<OauthController>(OauthController);
  });

  describe('Testing Oauth Controller (base)', () => {
    it('should be defined', () => {
      expect(oauthController).toBeDefined();
    });
  });

  describe('processKakaoLogin 테스트', () => {
    // given
    const memberHash = 'testMemberHash';
    const accessToken = 'accessTokenForTest';
    beforeEach(() => {
      mockOauthService.getKakaoMemberHash = jest.fn().mockReturnValue(memberHash);
      mockOauthService.login = jest.fn().mockResolvedValue(new TokenResDto('access.bbb.ccc', 'refresh.bbb.ccc'));
    });

    // clear mock
    afterEach(() => {
      mockOauthService.getKakaoMemberHash.mockClear();
      mockOauthService.login.mockClear();
    });

    it('1 : 정상 응답(가입된 유저)', async () => {
      try {
        // when
        await oauthController.processKakaoLogin({ accessToken });
      } catch (e) {
        // then
        expect(mockOauthService.getKakaoMemberHash).toHaveBeenCalledWith(accessToken);
        expect(mockOauthService.login).toHaveBeenCalledWith(memberHash);
        expect(e).toEqual(
          expect.objectContaining({
            customCode: 'SUCCESS',
            data: { accessToken: expect.stringMatching(jwtRegEx), refreshToken: expect.stringMatching(jwtRegEx) },
          }),
        );
      }
    });

    it('2 : 가입되지 않은 유저 -> OAUTH01', async () => {
      // given
      mockOauthService.login = jest.fn(async () => {
        throw new CustomResponse(ECustomCode.OAUTH01);
      });

      // when & then
      await expect(oauthController.processKakaoLogin({ accessToken })).rejects.toThrow(
        new CustomResponse(ECustomCode.OAUTH01),
      );
      expect(mockOauthService.getKakaoMemberHash).toHaveBeenCalledWith(accessToken);
      expect(mockOauthService.login).toHaveBeenCalledWith(memberHash);
    });
  });

  describe('processAppleLogin 테스트', () => {
    // given
    const identityToken = 'testIdentityToken';
    const memberHash = 'testMemberHash';
    beforeEach(() => {
      mockOauthService.verifyAppleIdentityToken = jest.fn();
      mockOauthService.getAppleMemberHash = jest.fn().mockReturnValue(memberHash);
      mockOauthService.login = jest.fn().mockResolvedValue(new TokenResDto('access.bbb.ccc', 'refresh.bbb.ccc'));
    });

    // clear mock
    afterEach(() => {
      mockOauthService.verifyAppleIdentityToken.mockClear();
      mockOauthService.getAppleMemberHash.mockClear();
      mockOauthService.login.mockClear();
    });

    it('1 : 정상 응답(가입된 유저)', async () => {
      try {
        // when
        await oauthController.processAppleLogin({ identityToken });
      } catch (e) {
        // then
        expect(mockOauthService.verifyAppleIdentityToken).toHaveBeenCalledWith(identityToken);
        expect(mockOauthService.getAppleMemberHash).toHaveBeenCalledWith(identityToken);
        expect(mockOauthService.login).toHaveBeenCalledWith(memberHash);
        expect(e).toEqual(
          expect.objectContaining({
            customCode: 'SUCCESS',
            data: { accessToken: expect.stringMatching(jwtRegEx), refreshToken: expect.stringMatching(jwtRegEx) },
          }),
        );
      }
    });

    it('2 : apple id token 검증 실패 -> OAUTH07', async () => {
      // given
      mockOauthService.verifyAppleIdentityToken = jest.fn(async () => {
        throw new CustomResponse(ECustomCode.OAUTH07);
      });

      // when & then
      await expect(oauthController.processAppleLogin({ identityToken })).rejects.toThrow(
        new CustomResponse(ECustomCode.OAUTH07),
      );
      expect(mockOauthService.verifyAppleIdentityToken).toHaveBeenCalledWith(identityToken);
      expect(mockOauthService.getAppleMemberHash).toHaveBeenCalledTimes(0);
      expect(mockOauthService.login).toHaveBeenCalledTimes(0);
    });

    it('3 : apple id token에 sub 필드 없음 -> OAUTH07', async () => {
      // given
      mockOauthService.getAppleMemberHash = jest.fn(() => {
        throw new CustomResponse(ECustomCode.OAUTH07);
      });

      // when & then
      await expect(oauthController.processAppleLogin({ identityToken })).rejects.toThrow(
        new CustomResponse(ECustomCode.OAUTH07),
      );
      expect(mockOauthService.verifyAppleIdentityToken).toHaveBeenCalledWith(identityToken);
      expect(mockOauthService.getAppleMemberHash).toHaveBeenCalledWith(identityToken);
      expect(mockOauthService.login).toHaveBeenCalledTimes(0);
    });

    it('4 : 가입 안 된 유저 -> OAUTH01', async () => {
      // given
      mockOauthService.login = jest.fn(async () => {
        throw new CustomResponse(ECustomCode.OAUTH01);
      });

      // when & then
      await expect(oauthController.processAppleLogin({ identityToken })).rejects.toThrow(
        new CustomResponse(ECustomCode.OAUTH01),
      );
      expect(mockOauthService.verifyAppleIdentityToken).toHaveBeenCalledWith(identityToken);
      expect(mockOauthService.getAppleMemberHash).toHaveBeenCalledWith(identityToken);
      expect(mockOauthService.login).toHaveBeenCalledWith(memberHash);
    });
  });

  describe('checkKakaoSignup 테스트', () => {
    // given
    const accessToken = 'testAccessToken';
    const memberHash = 'testMemberHash';
    beforeEach(() => {
      mockOauthService.getKakaoMemberHash = jest.fn().mockResolvedValue(memberHash);
      mockOauthService.isMemberExistByHash = jest.fn().mockResolvedValue(true);
    });

    //clear mock
    afterEach(() => {
      mockOauthService.getKakaoMemberHash.mockClear();
      mockOauthService.isMemberExistByHash.mockClear();
    });

    // clear mock
    it('1 : 정상 응답(해당 계정의 유저가 가입됐는지 아닌지)', async () => {
      try {
        // when
        await oauthController.checkKakaoSignup({ accessToken });
      } catch (e) {
        // then
        expect(e).toEqual(expect.objectContaining({ customCode: 'SUCCESS', data: { isAlreadyExist: true } }));
        expect(mockOauthService.getKakaoMemberHash).toHaveBeenCalledWith(accessToken);
        expect(mockOauthService.isMemberExistByHash).toHaveBeenCalledWith(memberHash);
      }
    });

    it('2 : 카카오에서 받아온 정보에 id 필드가 없는 경우 -> OAUTH02', async () => {
      // given
      mockOauthService.getKakaoMemberHash = jest.fn(async () => {
        throw new CustomResponse(ECustomCode.OAUTH02);
      });

      // when & then
      await expect(oauthController.checkKakaoSignup({ accessToken })).rejects.toThrow(
        new CustomResponse(ECustomCode.OAUTH02),
      );
      expect(mockOauthService.getKakaoMemberHash).toHaveBeenCalledWith(accessToken);
      expect(mockOauthService.isMemberExistByHash).toHaveBeenCalledTimes(0);
    });

    it('3 : 카카오 서버와 통신중 네트워크 오류 발생 -> OAUTH03', async () => {
      // given
      mockOauthService.getKakaoMemberHash = jest.fn(async () => {
        throw new CustomResponse(ECustomCode.OAUTH03);
      });

      // when & then
      await expect(oauthController.checkKakaoSignup({ accessToken })).rejects.toThrow(
        new CustomResponse(ECustomCode.OAUTH03),
      );
      expect(mockOauthService.getKakaoMemberHash).toHaveBeenCalledWith(accessToken);
      expect(mockOauthService.isMemberExistByHash).toHaveBeenCalledTimes(0);
    });
  });

  describe('checkAppleSignup 테스트', () => {
    // given
    const identityToken = 'testIdentityToken';
    const memberHash = 'testMemberHash';
    beforeEach(() => {
      mockOauthService.verifyAppleIdentityToken = jest.fn();
      mockOauthService.getAppleMemberHash = jest.fn().mockReturnValue(memberHash);
      mockOauthService.isMemberExistByHash = jest.fn().mockResolvedValue(true);
    });

    // clear mock
    afterEach(() => {
      mockOauthService.verifyAppleIdentityToken.mockClear();
      mockOauthService.getAppleMemberHash.mockClear();
      mockOauthService.isMemberExistByHash.mockClear();
    });

    it('1 : 정상 응답(해당 계정의 유저가 가입됐는지 아닌지)', async () => {
      try {
        // when
        await oauthController.checkAppleSignup({ identityToken });
      } catch (e) {
        // then
        expect(e).toEqual(expect.objectContaining({ customCode: 'SUCCESS', data: { isAlreadyExist: true } }));
        expect(mockOauthService.verifyAppleIdentityToken).toHaveBeenCalledWith(identityToken);
        expect(mockOauthService.getAppleMemberHash).toHaveBeenCalledWith(identityToken);
        expect(mockOauthService.isMemberExistByHash).toHaveBeenCalledWith(memberHash);
      }
    });

    it('2 : idToken이 검증되지 않음 -> OAUTH07', async () => {
      // given
      mockOauthService.verifyAppleIdentityToken = jest.fn(async () => {
        throw new CustomResponse(ECustomCode.OAUTH07);
      });

      // when & then
      await expect(oauthController.checkAppleSignup({ identityToken })).rejects.toThrow(
        new CustomResponse(ECustomCode.OAUTH07),
      );
      expect(mockOauthService.verifyAppleIdentityToken).toHaveBeenCalledWith(identityToken);
      expect(mockOauthService.getAppleMemberHash).toHaveBeenCalledTimes(0);
      expect(mockOauthService.isMemberExistByHash).toHaveBeenCalledTimes(0);
    });

    it('3 : idToken에 sub 필드가 존재하지 않음 -> OAUTH07', async () => {
      // given
      mockOauthService.getAppleMemberHash = jest.fn(() => {
        throw new CustomResponse(ECustomCode.OAUTH07);
      });

      // when & then
      await expect(oauthController.checkAppleSignup({ identityToken })).rejects.toThrow(
        new CustomResponse(ECustomCode.OAUTH07),
      );
      expect(mockOauthService.verifyAppleIdentityToken).toHaveBeenCalledWith(identityToken);
      expect(mockOauthService.getAppleMemberHash).toHaveBeenCalledWith(identityToken);
      expect(mockOauthService.isMemberExistByHash).toHaveBeenCalledTimes(0);
    });
  });

  describe('processKakaoSignup 테스트', () => {
    // given
    const accessToken = 'testAccessToken';
    const existAccessToken = 'testExistAccessToken';
    const username = 'testUsername';
    const existUsername = 'testExistUsername';
    const memberHash = 'testMemberHash';
    const existMemberHash = 'testExistMemberHash';
    beforeEach(() => {
      mockOauthService.getKakaoMemberHash = jest.fn(async (accessToken) => {
        if (accessToken === existAccessToken) return existMemberHash;
        return memberHash;
      });
      mockOauthService.isMemberExistByHash = jest.fn(async (memberHash) => {
        if (memberHash === existMemberHash) return true;
        return false;
      });
      mockOauthService.generateAccessRefreshTokens = jest
        .fn()
        .mockResolvedValue({ accessToken: 'access.bbb.ccc', refreshToken: 'refresh.bbb.ccc' });
      mockOauthService.isExistUsername = jest.fn((username) => {
        if (username === existUsername) return true;
        return false;
      });
      mockOauthService.signup = jest.fn();
    });

    // clear mock
    afterEach(() => {
      mockOauthService.getKakaoMemberHash.mockClear();
      mockOauthService.isMemberExistByHash.mockClear();
      mockOauthService.generateAccessRefreshTokens.mockClear();
      mockOauthService.isExistUsername.mockClear();
      mockOauthService.signup.mockClear();
    });

    it('1 : 정상 응답(회원 가입 성공)', async () => {
      try {
        // when
        await oauthController.processKakaoSignup({ accessToken, username });
      } catch (e) {
        // then
        expect(e).toEqual(
          expect.objectContaining({
            customCode: 'SUCCESS',
            data: { accessToken: expect.stringMatching(jwtRegEx), refreshToken: expect.stringMatching(jwtRegEx) },
          }),
        );
        expect(mockOauthService.getKakaoMemberHash).toHaveBeenCalledWith(accessToken);
        expect(mockOauthService.isMemberExistByHash).toHaveBeenCalledWith(memberHash);
        expect(mockOauthService.isExistUsername).toHaveBeenCalledWith(username);
        expect(mockOauthService.signup).toHaveBeenCalledWith(memberHash, username, 'kakao');
        expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledWith(memberHash);
        expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledTimes(1);
      }
    });

    it('2 : 정상 응답(이미 가입된 회원)', async () => {
      try {
        // when
        await oauthController.processKakaoSignup({ accessToken: existAccessToken, username });
      } catch (e) {
        // then
        expect(e).toEqual(
          expect.objectContaining({
            customCode: 'SUCCESS',
            data: { accessToken: expect.stringMatching(jwtRegEx), refreshToken: expect.stringMatching(jwtRegEx) },
          }),
        );
        expect(mockOauthService.getKakaoMemberHash).toHaveBeenCalledWith(existAccessToken);
        expect(mockOauthService.isMemberExistByHash).toHaveBeenCalledWith(existMemberHash);
        expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledWith(existMemberHash);
        expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledTimes(1);
        expect(mockOauthService.isExistUsername).toHaveBeenCalledTimes(0);
        expect(mockOauthService.signup).toHaveBeenCalledTimes(0);
      }
    });

    it('3 : 카카오에서 받아온 정보에 id 필드가 없는 경우 -> OAUTH02', async () => {
      // given
      mockOauthService.getKakaoMemberHash = jest.fn(async () => {
        throw new CustomResponse(ECustomCode.OAUTH02);
      });

      // when & then
      await expect(oauthController.processKakaoSignup({ accessToken, username })).rejects.toThrow(
        new CustomResponse(ECustomCode.OAUTH02),
      );
      expect(mockOauthService.getKakaoMemberHash).toHaveBeenCalledWith(accessToken);
      expect(mockOauthService.isMemberExistByHash).toHaveBeenCalledTimes(0);
      expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledTimes(0);
      expect(mockOauthService.isExistUsername).toHaveBeenCalledTimes(0);
      expect(mockOauthService.signup).toHaveBeenCalledTimes(0);
    });

    it('4 : 카카오 서버와 통신중 네트워크 오류 발생 -> OAUTH03', async () => {
      // given
      mockOauthService.getKakaoMemberHash = jest.fn(async () => {
        throw new CustomResponse(ECustomCode.OAUTH03);
      });

      // when & then
      await expect(oauthController.processKakaoSignup({ accessToken, username })).rejects.toThrow(
        new CustomResponse(ECustomCode.OAUTH03),
      );
      expect(mockOauthService.getKakaoMemberHash).toHaveBeenCalledWith(accessToken);
      expect(mockOauthService.isMemberExistByHash).toHaveBeenCalledTimes(0);
      expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledTimes(0);
      expect(mockOauthService.isExistUsername).toHaveBeenCalledTimes(0);
      expect(mockOauthService.signup).toHaveBeenCalledTimes(0);
    });

    it('5 : signAsync 오류 -> OAUTH04', async () => {
      // given
      mockOauthService.generateAccessRefreshTokens = jest.fn(async () => {
        throw new CustomResponse(ECustomCode.OAUTH04);
      });

      // when & then
      await expect(oauthController.processKakaoSignup({ accessToken, username })).rejects.toThrow(
        new CustomResponse(ECustomCode.OAUTH04),
      );
      expect(mockOauthService.getKakaoMemberHash).toHaveBeenCalledWith(accessToken);
      expect(mockOauthService.isMemberExistByHash).toHaveBeenCalledWith(memberHash);
      expect(mockOauthService.isExistUsername).toHaveBeenCalledWith(username);
      expect(mockOauthService.signup).toHaveBeenCalledWith(memberHash, username, 'kakao');
      expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledWith(memberHash);
      expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledTimes(1);
    });

    it('6 : Redis 오류 -> OAUTH05', async () => {
      // given
      mockOauthService.generateAccessRefreshTokens = jest.fn(async () => {
        throw new CustomResponse(ECustomCode.OAUTH05);
      });

      // when & then
      await expect(oauthController.processKakaoSignup({ accessToken, username })).rejects.toThrow(
        new CustomResponse(ECustomCode.OAUTH05),
      );
      expect(mockOauthService.getKakaoMemberHash).toHaveBeenCalledWith(accessToken);
      expect(mockOauthService.isMemberExistByHash).toHaveBeenCalledWith(memberHash);
      expect(mockOauthService.isExistUsername).toHaveBeenCalledWith(username);
      expect(mockOauthService.signup).toHaveBeenCalledWith(memberHash, username, 'kakao');
      expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledWith(memberHash);
      expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledTimes(1);
    });

    it('7 : 중복 닉네임 -> MEMBER01', async () => {
      // when & then
      await expect(oauthController.processKakaoSignup({ accessToken, username: existUsername })).rejects.toThrow(
        new CustomResponse(ECustomCode.MEMBER01),
      );
      expect(mockOauthService.getKakaoMemberHash).toHaveBeenCalledWith(accessToken);
      expect(mockOauthService.isMemberExistByHash).toHaveBeenCalledWith(memberHash);
      expect(mockOauthService.isExistUsername).toHaveBeenCalledWith(existUsername);
      expect(mockOauthService.signup).toHaveBeenCalledTimes(0);
      expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledTimes(0);
    });

    it('8 : 회원 정보 DB 저장 오류 -> OAUTH06', async () => {
      // given
      mockOauthService.signup = jest.fn(async () => {
        throw new CustomResponse(ECustomCode.OAUTH06);
      });

      // when & then
      await expect(oauthController.processKakaoSignup({ accessToken, username })).rejects.toThrow(
        new CustomResponse(ECustomCode.OAUTH06),
      );
      expect(mockOauthService.getKakaoMemberHash).toHaveBeenCalledWith(accessToken);
      expect(mockOauthService.isMemberExistByHash).toHaveBeenCalledWith(memberHash);
      expect(mockOauthService.isExistUsername).toHaveBeenCalledWith(username);
      expect(mockOauthService.signup).toHaveBeenCalledWith(memberHash, username, 'kakao');
      expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledTimes(0);
    });
  });

  describe('processAppleSignup 테스트', () => {
    // given
    const identityToken = 'testIdentityToken';
    const existIdentityToken = 'testExistIdentityToken';
    const username = 'testUsername';
    const existUsername = 'testExistUsername';
    const memberHash = 'testMemberHash';
    const existMemberHash = 'testExistMemberHash';
    beforeEach(() => {
      mockOauthService.verifyAppleIdentityToken = jest.fn();
      mockOauthService.getAppleMemberHash = jest.fn((identityToken) => {
        if (identityToken === existIdentityToken) return existMemberHash;
        return memberHash;
      });
      mockOauthService.isMemberExistByHash = jest.fn(async (memberHash) => {
        if (memberHash === existMemberHash) return true;
        return false;
      });
      mockOauthService.generateAccessRefreshTokens = jest
        .fn()
        .mockResolvedValue({ accessToken: 'access.bbb.ccc', refreshToken: 'refresh.bbb.ccc' });
      mockOauthService.isExistUsername = jest.fn((username) => {
        if (username === existUsername) return true;
        return false;
      });
      mockOauthService.signup = jest.fn();
    });

    // clear mock
    afterEach(() => {
      mockOauthService.verifyAppleIdentityToken.mockClear();
      mockOauthService.getAppleMemberHash.mockClear();
      mockOauthService.isMemberExistByHash.mockClear();
      mockOauthService.generateAccessRefreshTokens.mockClear();
      mockOauthService.isExistUsername.mockClear();
      mockOauthService.signup.mockClear();
    });

    it('1 : 정상 응답(회원 가입 성공)', async () => {
      try {
        // when
        await oauthController.processAppleSignup({ identityToken, username });
      } catch (e) {
        // then
        expect(e).toEqual(
          expect.objectContaining({
            customCode: 'SUCCESS',
            data: { accessToken: expect.stringMatching(jwtRegEx), refreshToken: expect.stringMatching(jwtRegEx) },
          }),
        );
        expect(mockOauthService.verifyAppleIdentityToken).toHaveBeenCalledWith(identityToken);
        expect(mockOauthService.getAppleMemberHash).toHaveBeenCalledWith(identityToken);
        expect(mockOauthService.isMemberExistByHash).toHaveBeenCalledWith(memberHash);
        expect(mockOauthService.isExistUsername).toHaveBeenCalledWith(username);
        expect(mockOauthService.signup).toHaveBeenCalledWith(memberHash, username, 'apple');
        expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledWith(memberHash);
        expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledTimes(1);
      }
    });

    it('2 : 정상 응답(이미 가입된 회원)', async () => {
      try {
        // when
        await oauthController.processAppleSignup({ identityToken: existIdentityToken, username });
      } catch (e) {
        // then
        expect(e).toEqual(
          expect.objectContaining({
            customCode: 'SUCCESS',
            data: { accessToken: expect.stringMatching(jwtRegEx), refreshToken: expect.stringMatching(jwtRegEx) },
          }),
        );
        expect(mockOauthService.verifyAppleIdentityToken).toHaveBeenCalledWith(existIdentityToken);
        expect(mockOauthService.getAppleMemberHash).toHaveBeenCalledWith(existIdentityToken);
        expect(mockOauthService.isMemberExistByHash).toHaveBeenCalledWith(existMemberHash);
        expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledWith(existMemberHash);
        expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledTimes(1);
        expect(mockOauthService.isExistUsername).toHaveBeenCalledTimes(0);
        expect(mockOauthService.signup).toHaveBeenCalledTimes(0);
      }
    });

    it('3-1 : identity token 검증 실패 -> OAUTH07', async () => {
      // given
      mockOauthService.verifyAppleIdentityToken = jest.fn(async () => {
        throw new CustomResponse(ECustomCode.OAUTH07);
      });

      // when & then
      await expect(oauthController.processAppleSignup({ identityToken, username })).rejects.toThrow(
        new CustomResponse(ECustomCode.OAUTH07),
      );
      expect(mockOauthService.verifyAppleIdentityToken).toHaveBeenCalledWith(identityToken);
      expect(mockOauthService.getAppleMemberHash).toHaveBeenCalledTimes(0);
      expect(mockOauthService.isMemberExistByHash).toHaveBeenCalledTimes(0);
      expect(mockOauthService.isExistUsername).toHaveBeenCalledTimes(0);
      expect(mockOauthService.signup).toHaveBeenCalledTimes(0);
      expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledTimes(0);
    });

    it('3-2 : identity token에 sub 필드 X -> OAUTH07', async () => {
      // given
      mockOauthService.getAppleMemberHash = jest.fn(() => {
        throw new CustomResponse(ECustomCode.OAUTH07);
      });

      // when & then
      await expect(oauthController.processAppleSignup({ identityToken, username })).rejects.toThrow(
        new CustomResponse(ECustomCode.OAUTH07),
      );
      expect(mockOauthService.verifyAppleIdentityToken).toHaveBeenCalledWith(identityToken);
      expect(mockOauthService.getAppleMemberHash).toHaveBeenCalledWith(identityToken);
      expect(mockOauthService.isMemberExistByHash).toHaveBeenCalledTimes(0);
      expect(mockOauthService.isExistUsername).toHaveBeenCalledTimes(0);
      expect(mockOauthService.signup).toHaveBeenCalledTimes(0);
      expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledTimes(0);
    });

    it('4 : identity token이 JWT 형식이 아님 -> JWT01', async () => {
      // given
      mockOauthService.getAppleMemberHash = jest.fn(() => {
        throw new CustomResponse(ECustomCode.JWT01);
      });

      // when & then
      await expect(oauthController.processAppleSignup({ identityToken, username })).rejects.toThrow(
        new CustomResponse(ECustomCode.JWT01),
      );
      expect(mockOauthService.verifyAppleIdentityToken).toHaveBeenCalledWith(identityToken);
      expect(mockOauthService.getAppleMemberHash).toHaveBeenCalledWith(identityToken);
      expect(mockOauthService.isMemberExistByHash).toHaveBeenCalledTimes(0);
      expect(mockOauthService.isExistUsername).toHaveBeenCalledTimes(0);
      expect(mockOauthService.signup).toHaveBeenCalledTimes(0);
      expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledTimes(0);
    });

    it('5 : signAsync 오류 -> OAUTH04', async () => {
      // given
      mockOauthService.generateAccessRefreshTokens = jest.fn(async () => {
        throw new CustomResponse(ECustomCode.OAUTH04);
      });

      // when & then
      await expect(oauthController.processAppleSignup({ identityToken, username })).rejects.toThrow(
        new CustomResponse(ECustomCode.OAUTH04),
      );
      expect(mockOauthService.verifyAppleIdentityToken).toHaveBeenCalledWith(identityToken);
      expect(mockOauthService.getAppleMemberHash).toHaveBeenCalledWith(identityToken);
      expect(mockOauthService.isMemberExistByHash).toHaveBeenCalledWith(memberHash);
      expect(mockOauthService.isExistUsername).toHaveBeenCalledWith(username);
      expect(mockOauthService.signup).toHaveBeenCalledWith(memberHash, username, 'apple');
      expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledWith(memberHash);
      expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledTimes(1);
    });

    it('6 : Redis 오류 -> OAUTH05', async () => {
      // given
      mockOauthService.generateAccessRefreshTokens = jest.fn(async () => {
        throw new CustomResponse(ECustomCode.OAUTH05);
      });

      // when & then
      await expect(oauthController.processAppleSignup({ identityToken, username })).rejects.toThrow(
        new CustomResponse(ECustomCode.OAUTH05),
      );
      expect(mockOauthService.verifyAppleIdentityToken).toHaveBeenCalledWith(identityToken);
      expect(mockOauthService.getAppleMemberHash).toHaveBeenCalledWith(identityToken);
      expect(mockOauthService.isMemberExistByHash).toHaveBeenCalledWith(memberHash);
      expect(mockOauthService.isExistUsername).toHaveBeenCalledWith(username);
      expect(mockOauthService.signup).toHaveBeenCalledWith(memberHash, username, 'apple');
      expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledWith(memberHash);
      expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledTimes(1);
    });

    it('7 : 중복 닉네임 -> MEMBER01', async () => {
      // when & then
      await expect(oauthController.processAppleSignup({ identityToken, username: existUsername })).rejects.toThrow(
        new CustomResponse(ECustomCode.MEMBER01),
      );
      expect(mockOauthService.verifyAppleIdentityToken).toHaveBeenCalledWith(identityToken);
      expect(mockOauthService.getAppleMemberHash).toHaveBeenCalledWith(identityToken);
      expect(mockOauthService.isMemberExistByHash).toHaveBeenCalledWith(memberHash);
      expect(mockOauthService.isExistUsername).toHaveBeenCalledWith(existUsername);
      expect(mockOauthService.signup).toHaveBeenCalledTimes(0);
      expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledTimes(0);
    });

    it('8 : 회원 정보 DB 저장 오류 -> OAUTH06', async () => {
      // given
      mockOauthService.signup = jest.fn(async () => {
        throw new CustomResponse(ECustomCode.OAUTH06);
      });

      // when & then
      await expect(oauthController.processAppleSignup({ identityToken, username })).rejects.toThrow(
        new CustomResponse(ECustomCode.OAUTH06),
      );
      expect(mockOauthService.verifyAppleIdentityToken).toHaveBeenCalledWith(identityToken);
      expect(mockOauthService.getAppleMemberHash).toHaveBeenCalledWith(identityToken);
      expect(mockOauthService.isMemberExistByHash).toHaveBeenCalledWith(memberHash);
      expect(mockOauthService.isExistUsername).toHaveBeenCalledWith(username);
      expect(mockOauthService.signup).toHaveBeenCalledWith(memberHash, username, 'apple');
      expect(mockOauthService.generateAccessRefreshTokens).toHaveBeenCalledTimes(0);
    });
  });
});
