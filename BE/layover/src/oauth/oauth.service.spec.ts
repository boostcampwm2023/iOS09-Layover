import { Test, TestingModule } from '@nestjs/testing';
import { OauthService } from './oauth.service';
import { HttpService } from '@nestjs/axios';
import { JwtService } from '@nestjs/jwt';
import { MemberService } from 'src/member/member.service';
import { CustomResponse } from 'src/response/custom-response';
import { ECustomCode } from 'src/response/ecustom-code.jenum';
import * as jwtUtils from 'src/utils/jwtUtils';
import * as hashUtils from 'src/utils/hashUtils';
import { REFRESH_TOKEN_EXP_IN_SECOND } from 'src/config';

describe('OauthService', () => {
  let service: OauthService;

  const mockJwtService = { signAsync: jest.fn() };
  const mockHttpService = {};
  const mockMemberService = {
    isMemberExistByHash: jest.fn(),
    isExistUsername: jest.fn(),
    createMember: jest.fn(),
    getMemberByHash: jest.fn(),
  };
  const mockRedisClient = {
    setEx: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        OauthService,
        { provide: JwtService, useValue: mockJwtService },
        { provide: HttpService, useValue: mockHttpService },
        { provide: MemberService, useValue: mockMemberService },
        { provide: 'REDIS_CLIENT', useValue: mockRedisClient },
      ],
    }).compile();

    service = module.get<OauthService>(OauthService);
  });

  describe('Testing Oauth Service (base)', () => {
    it('should be defined', () => {
      expect(service).toBeDefined();
    });
  });

  describe('아직 테스트 못 한 함수들... Oauth 서버에서 받아와야 되는 애들은 어떡하쥐???', () => {
    it(`getMemberIdByAccessToken() 테스트 1`, () => {});

    it(`getKakaoMemberHash() 테스트 1`, () => {});
  });

  describe('getAppleMemberHash() 테스트', () => {
    // given
    let spyExtractPayloadJWT: ReturnType<typeof jest.spyOn>;
    let spyHashSHA256: ReturnType<typeof jest.spyOn>;
    beforeEach(() => {
      spyExtractPayloadJWT = jest.spyOn(jwtUtils, 'extractPayloadJWT');
      spyHashSHA256 = jest.spyOn(hashUtils, 'hashSHA256');
    });

    // clear spy
    afterEach(() => {
      spyExtractPayloadJWT.mockRestore();
      spyHashSHA256.mockRestore();
    });

    it(`1 : 결과가 잘 해싱돼서 반환되는가`, () => {
      // when
      const genuineIdToken =
        'eyJraWQiOiJZdXlYb1kiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwiYXVkIjoia3IuY29kZXNxdWFkLmJvb3N0Y2FtcDguTGF5b3ZlciIsImV4cCI6MTcwMTg0MzEyOCwiaWF0IjoxNzAxNzU2NzI4LCJzdWIiOiIwMDE1MzAuN2M2N2FjZDZkMTYwNDk2NTk1MDRhYzE4NzI0ZTJhODkuMTQ0NiIsImNfaGFzaCI6ImMzRWQ2VXh2R2FCdXN2T2FoVjdHblEiLCJhdXRoX3RpbWUiOjE3MDE3NTY3MjgsIm5vbmNlX3N1cHBvcnRlZCI6dHJ1ZX0.i6EFXkygK-ZmGYr8eGbky9zyUrmNKOIb9sfSD-tWVyt3HDf9ikMOhiiUY-hvDPdpUVcuxHEgMU8zVesZ4LE1hVLYB1RylXoDSHhBg3C8SlfFrJwci7ENSLZ3j5721RR-tGd5ZtCqNBUNeRB0bQF-LkbsWC0S7OfjAEecOMhIcC3BsBZ-r1NyKqe3jwnMiXch4qdhJLNYWjR0ynm_QV1t4MwzHrz0MfEdQ6g8qYDe1ZPdr8iUz_RfmA3x-H446i8Wyv6inBizfnM9tdoj8xB2NfXaWgB6lzGVx9i-HmOBi7-NE_IU8uX7J_mQqi2sd2-wytCa-40L-CAJAVG-ewrN9w';
      const returnValue = service.getAppleMemberHash(genuineIdToken);

      // then
      expect(spyExtractPayloadJWT).toHaveBeenCalledWith(genuineIdToken);
      expect(spyHashSHA256).toHaveBeenCalledWith('001530.7c67acd6d16049659504ac18724e2a89.1446apple');
      expect(returnValue).toEqual('3cf9bc8398aac46ecd844cfcea66ce8e367147eaf589423b971fa1f8d62c9c20');
    });

    it(`2 : idToken에 sub이 없으면 -> OAUTH07`, () => {
      // when & then
      const fakeJwtTokenWithNoSub =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiSm9obiBEb2UiLCJpYXQiOjE1MTYyMzkwMjJ9.hqWGSaFpvbrXkOWc6lrnffhNWR19W_S1YKFBx2arWBk';
      expect(() => service.getAppleMemberHash(fakeJwtTokenWithNoSub)).toThrow(new CustomResponse(ECustomCode.OAUTH07));
      expect(spyExtractPayloadJWT).toHaveBeenCalledWith(fakeJwtTokenWithNoSub);
      expect(spyHashSHA256).toHaveBeenCalledTimes(0);
    });
  });

  describe('verifyAppleIdentityToken() 테스트', () => {
    it('1 : verifyJwtToken() 함수가 에러를 발생시키면 -> OAUTH07', async () => {
      // given
      const identityToken = 'aaa.bbb.ccc';
      const spyVerifyJwtToken = jest.spyOn(jwtUtils, 'verifyJwtToken').mockRejectedValue(new Error('테스트 에러'));

      // when & then
      await expect(service.verifyAppleIdentityToken(identityToken)).rejects.toThrow(
        new CustomResponse(ECustomCode.OAUTH07),
      );

      //clear spy
      spyVerifyJwtToken.mockRestore();
    });
  });

  describe('isMemberExistByHash()', () => {
    it(`테스트 1 : memberService.isMemberExistByHash()를 잘 호출하는가`, async () => {
      // given
      mockMemberService.isMemberExistByHash = jest.fn((hash) => (hash ? true : false));

      // when
      const returnedValue = await service.isMemberExistByHash('testMemberHash');

      // then
      expect(returnedValue).toBe(true);

      // clear mock
      mockMemberService.isMemberExistByHash.mockClear();
    });
  });

  describe('isExistUsername() 테스트', () => {
    it(`1 : memberService.isExistUsername()를 잘 호출하는가`, async () => {
      // given
      mockMemberService.isExistUsername = jest.fn((username) => (username ? true : false));

      // when
      const returnedValue = await service.isExistUsername('testUsername');

      // then
      expect(returnedValue).toBe(true);

      // clear mock
      mockMemberService.isExistUsername.mockClear();
    });
  });

  describe('signup() 테스트', () => {
    // given
    const username = 'testUsername';
    const provider = 'testProvider';
    const memberHash = 'testMemberHash';

    //clear mock
    afterEach(() => {
      mockMemberService.createMember.mockClear();
    });

    it(`1 : memberService.createMember()를 잘 호출하는가`, async () => {
      // given
      mockMemberService.createMember = jest.fn();

      // when
      await service.signup(memberHash, username, provider);

      // then
      expect(mockMemberService.createMember).toHaveBeenCalledWith(
        username,
        'default.jpeg',
        'default introduce',
        provider,
        memberHash,
      );
    });

    it(`2 : memberService.createMember() 오류일 때 OAUTH06을 잘 던지는가`, async () => {
      // given
      mockMemberService.createMember = jest.fn().mockRejectedValue(new Error('Test error'));

      // when & then
      await expect(service.signup(memberHash, username, provider)).rejects.toThrow(
        new CustomResponse(ECustomCode.OAUTH06),
      );
      expect(mockMemberService.createMember).toHaveBeenCalledWith(
        username,
        'default.jpeg',
        'default introduce',
        provider,
        memberHash,
      );
    });
  });

  describe('login() 테스트', () => {
    // given
    const memberHash = 'testMemberHash';
    const notExistMemberHash = 'notExistMemberHash';
    let spyIsMemberExistByHash: ReturnType<typeof jest.spyOn>;
    let spyGenerateAccessRefreshTokens: ReturnType<typeof jest.spyOn>;
    beforeEach(() => {
      mockMemberService.getMemberByHash = jest.fn().mockResolvedValue({ id: 777 });
      mockMemberService.isMemberExistByHash = jest.fn(async (memberHash) => {
        if (memberHash === notExistMemberHash) return false;
        return true;
      });
      mockRedisClient.setEx = jest.fn();
      mockJwtService.signAsync = jest.fn(async () => `aaa.bbb.ccc`);
      spyIsMemberExistByHash = jest.spyOn(service, 'isMemberExistByHash');
      spyGenerateAccessRefreshTokens = jest.spyOn(service, 'generateAccessRefreshTokens');
    });

    // clear mock&spy
    afterEach(() => {
      mockMemberService.getMemberByHash.mockClear();
      mockMemberService.isMemberExistByHash.mockClear();
      mockRedisClient.setEx.mockClear();
      mockJwtService.signAsync.mockClear();
      spyIsMemberExistByHash.mockRestore();
      spyGenerateAccessRefreshTokens.mockRestore();
    });

    it(`1 : 결과를 잘 반환하는가 + 내부 함수들 잘 호출되는가`, async () => {
      // when
      const returnValue = await service.login(memberHash);

      // then
      const jwtRegEx = /^[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+$/;
      expect(spyIsMemberExistByHash).toHaveBeenCalledWith(memberHash);
      expect(spyGenerateAccessRefreshTokens).toHaveBeenCalledWith(memberHash);
      expect(returnValue).toHaveProperty('accessToken', expect.stringMatching(jwtRegEx));
      expect(returnValue).toHaveProperty('refreshToken', expect.stringMatching(jwtRegEx));
    });

    it(`2 : 회원가입 안 된 유저 -> OAUTH01`, async () => {
      // when & then
      await expect(service.login(notExistMemberHash)).rejects.toThrow(new CustomResponse(ECustomCode.OAUTH01));
      expect(spyIsMemberExistByHash).toHaveBeenCalledWith(notExistMemberHash);
      expect(spyGenerateAccessRefreshTokens).toHaveBeenCalledTimes(0);
    });
  });

  describe('generateAccessRefreshTokens() 테스트', () => {
    // given
    const memberHash = 'testMemberHash';
    const jwtRegEx = /^[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+$/;
    let spyMakeJwtPayload: ReturnType<typeof jest.spyOn>;
    beforeEach(() => {
      mockMemberService.getMemberByHash = jest.fn().mockResolvedValue({ id: 777 });
      mockRedisClient.setEx = jest.fn();
      mockJwtService.signAsync = jest.fn(async () => `aaa.bbb.ccc`);
      spyMakeJwtPayload = jest.spyOn(jwtUtils, 'makeJwtPaylaod').mockImplementation((a, b, c) => {
        return `${a}${b}${String(c)}`;
      });
    });

    // clear mock&spy
    afterEach(() => {
      mockMemberService.getMemberByHash.mockClear();
      mockRedisClient.setEx.mockClear();
      mockJwtService.signAsync.mockClear();
      spyMakeJwtPayload.mockRestore();
    });

    it(`1 : 각 토큰 형식에 맞게 잘 반환하는가 + 내부 함수들 잘 호출하는가`, async () => {
      // when
      const returnValue = await service.generateAccessRefreshTokens(memberHash);

      // then
      expect(mockMemberService.getMemberByHash).toHaveBeenCalledWith(memberHash);
      expect(spyMakeJwtPayload).toHaveBeenCalledWith('access', memberHash, 777);
      expect(spyMakeJwtPayload).toHaveBeenCalledWith('refresh', memberHash, 777);
      expect(mockJwtService.signAsync).toHaveBeenCalledWith(`access${memberHash}777`);
      expect(mockJwtService.signAsync).toHaveBeenCalledWith(`refresh${memberHash}777`);
      expect(mockRedisClient.setEx).toHaveBeenCalledWith('aaa.bbb.ccc', REFRESH_TOKEN_EXP_IN_SECOND, memberHash);
      expect(returnValue).toHaveProperty('accessToken', expect.stringMatching(jwtRegEx));
      expect(returnValue).toHaveProperty('refreshToken', expect.stringMatching(jwtRegEx));
    });

    it(`2 : signAsync 오류 -> OAUTH04`, async () => {
      // given
      mockJwtService.signAsync = jest.fn(async () => {
        throw new Error('Test error');
      });

      // when & then
      await expect(service.generateAccessRefreshTokens(memberHash)).rejects.toThrow(
        new CustomResponse(ECustomCode.OAUTH04),
      );
      expect(mockMemberService.getMemberByHash).toHaveBeenCalledWith(memberHash);
      expect(spyMakeJwtPayload).toHaveBeenCalledWith('access', memberHash, 777);
      expect(spyMakeJwtPayload).toHaveBeenCalledWith('refresh', memberHash, 777);
      expect(mockJwtService.signAsync).toHaveBeenCalledWith(`access${memberHash}777`);
      expect(mockJwtService.signAsync).toHaveBeenCalledTimes(1);
      expect(mockRedisClient.setEx).toHaveBeenCalledTimes(0);
    });

    it(`3 : Redis 오류 -> OAUTH05`, async () => {
      // given
      mockRedisClient.setEx = jest.fn(() => {
        throw new Error('Test error');
      });

      // when & then
      await expect(service.generateAccessRefreshTokens(memberHash)).rejects.toThrow(
        new CustomResponse(ECustomCode.OAUTH05),
      );
      expect(mockMemberService.getMemberByHash).toHaveBeenCalledWith(memberHash);
      expect(spyMakeJwtPayload).toHaveBeenCalledWith('access', memberHash, 777);
      expect(mockJwtService.signAsync).toHaveBeenCalledWith(`access${memberHash}777`);
      expect(mockJwtService.signAsync).toHaveBeenCalledWith(`refresh${memberHash}777`);
      expect(mockRedisClient.setEx).toHaveBeenCalledWith('aaa.bbb.ccc', REFRESH_TOKEN_EXP_IN_SECOND, memberHash);
    });
  });
});
