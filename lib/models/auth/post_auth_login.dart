// POST /api/auth/login - 소셜 로그인
//
// Request: LoginRequest
// Response: LoginResponse

// ──────────────────────────────────────
// Request
// ──────────────────────────────────────

/// 소셜 로그인 요청
class LoginRequest {
  final String socialType;  // KAKAO, NAVER, APPLE
  final String socialId;    // 소셜 서비스에서 발급받은 사용자 ID

  LoginRequest({
    required this.socialType,
    required this.socialId,
  });

  Map<String, dynamic> toJson() {
    return {
      'socialType': socialType.toUpperCase(),
      'socialId': socialId,
    };
  }
}

// ──────────────────────────────────────
// Response
// ──────────────────────────────────────

/// 소셜 로그인 응답
class LoginResponse {
  final int userId;
  final String nickname;
  final String accessToken;
  final String refreshToken;

  LoginResponse({
    required this.userId,
    required this.nickname,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['userId'] as int,
      nickname: json['nickname'] as String? ?? '',
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}
