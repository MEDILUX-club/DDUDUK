import 'package:dduduk_app/models/user/user.dart';

/// POST /api/auth/login - 소셜 로그인
///
/// Request: LoginRequest
/// Response: LoginResponse

// ──────────────────────────────────────
// Request
// ──────────────────────────────────────

class LoginRequest {
  final String provider;
  final String providerId;
  final String? email;
  final String? nickname;
  final String? profileImage;
  final String? accessToken;

  LoginRequest({
    required this.provider,
    required this.providerId,
    this.email,
    this.nickname,
    this.profileImage,
    this.accessToken,
  });

  Map<String, dynamic> toJson() => {
        'provider': provider.toUpperCase(),
        'providerId': providerId,
        if (email != null) 'email': email,
        if (nickname != null) 'nickname': nickname,
        if (profileImage != null) 'profileImage': profileImage,
        if (accessToken != null) 'accessToken': accessToken,
      };
}

// ──────────────────────────────────────
// Response
// ──────────────────────────────────────

class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final User user;
  final bool isNewUser;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.isNewUser,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      isNewUser: json['isNewUser'] as bool? ?? false,
    );
  }
}
