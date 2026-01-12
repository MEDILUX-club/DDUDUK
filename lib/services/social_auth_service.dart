import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:dduduk_app/models/auth/post_auth_login.dart';

/// 소셜 로그인 결과를 담는 클래스
class SocialLoginResult {
  final String provider;
  final String id;
  final String? email;
  final String? nickname;
  final String? profileImage;
  final String? accessToken;

  SocialLoginResult({
    required this.provider,
    required this.id,
    this.email,
    this.nickname,
    this.profileImage,
    this.accessToken,
  });

  @override
  String toString() {
    return 'SocialLoginResult(provider: $provider, id: $id, email: $email, nickname: $nickname)';
  }

  /// LoginRequest로 변환 (API 호출용)
  LoginRequest toLoginRequest() {
    return LoginRequest(
      provider: provider,
      providerId: id,
      email: email,
      nickname: nickname,
      profileImage: profileImage,
      accessToken: accessToken,
    );
  }
}

/// 소셜 로그인 서비스
class SocialAuthService {
  /// 카카오 로그인
  static Future<SocialLoginResult?> signInWithKakao() async {
    try {
      OAuthToken token;

      // 카카오톡 설치 여부 확인
      if (await isKakaoTalkInstalled()) {
        debugPrint('카카오톡으로 로그인 시도');
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        debugPrint('카카오 계정으로 로그인 시도');
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      debugPrint('카카오 로그인 성공: ${token.accessToken}');

      // 사용자 정보 가져오기
      User user = await UserApi.instance.me();
      debugPrint('사용자 정보: ${user.kakaoAccount?.profile?.nickname}');

      return SocialLoginResult(
        provider: 'kakao',
        id: user.id.toString(),
        email: user.kakaoAccount?.email,
        nickname: user.kakaoAccount?.profile?.nickname,
        profileImage: user.kakaoAccount?.profile?.profileImageUrl,
        accessToken: token.accessToken,
      );
    } catch (e) {
      debugPrint('카카오 로그인 실패: $e');
      return null;
    }
  }

  /// 카카오 로그아웃
  static Future<void> signOutKakao() async {
    try {
      await UserApi.instance.logout();
      debugPrint('카카오 로그아웃 성공');
    } catch (e) {
      debugPrint('카카오 로그아웃 실패: $e');
    }
  }

  /// 네이버 로그인
  static Future<SocialLoginResult?> signInWithNaver() async {
    try {
      NaverLoginResult result = await FlutterNaverLogin.logIn();

      if (result.status == NaverLoginStatus.loggedIn) {
        debugPrint('네이버 로그인 성공');

        // 사용자 정보 가져오기
        NaverAccountResult account = await FlutterNaverLogin.currentAccount();

        return SocialLoginResult(
          provider: 'naver',
          id: account.id,
          email: account.email,
          nickname: account.nickname,
          profileImage: account.profileImage,
          accessToken: result.accessToken.accessToken,
        );
      }

      debugPrint('네이버 로그인 실패: ${result.status}');
      return null;
    } catch (e) {
      debugPrint('네이버 로그인 실패: $e');
      return null;
    }
  }

  /// 네이버 로그아웃
  static Future<void> signOutNaver() async {
    try {
      await FlutterNaverLogin.logOut();
      debugPrint('네이버 로그아웃 성공');
    } catch (e) {
      debugPrint('네이버 로그아웃 실패: $e');
    }
  }

  /// 애플 로그인
  static Future<SocialLoginResult?> signInWithApple() async {
    try {
      // nonce 생성 (보안을 위해)
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      debugPrint('애플 로그인 성공: ${credential.userIdentifier}');

      // 이름 조합 (애플은 최초 로그인 시에만 이름을 제공)
      String? nickname;
      if (credential.givenName != null || credential.familyName != null) {
        nickname = '${credential.familyName ?? ''}${credential.givenName ?? ''}'
            .trim();
        if (nickname.isEmpty) nickname = null;
      }

      return SocialLoginResult(
        provider: 'apple',
        id: credential.userIdentifier ?? '',
        email: credential.email,
        nickname: nickname,
        profileImage: null, // 애플은 프로필 이미지를 제공하지 않음
        accessToken: credential.identityToken,
      );
    } catch (e) {
      debugPrint('애플 로그인 실패: $e');
      return null;
    }
  }

  /// nonce 생성 헬퍼
  static String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  /// SHA256 해시 생성
  static String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
