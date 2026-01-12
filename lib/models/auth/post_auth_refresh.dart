// POST /api/auth/refresh - 토큰 재발급
//
// Request: RefreshRequest
// Response: RefreshResponse

// ──────────────────────────────────────
// Request
// ──────────────────────────────────────

/// 토큰 갱신 요청
class RefreshRequest {
  final String refreshToken;

  RefreshRequest({required this.refreshToken});

  Map<String, dynamic> toJson() => {
        'refreshToken': refreshToken,
      };
}

// ──────────────────────────────────────
// Response
// ──────────────────────────────────────

/// 토큰 갱신 응답
class RefreshResponse {
  final String accessToken;
  final String refreshToken;

  RefreshResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshResponse.fromJson(Map<String, dynamic> json) {
    return RefreshResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}
