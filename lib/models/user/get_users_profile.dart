// GET /api/users/{userId} - 사용자 정보 조회
//
// Response: UserProfileResponse

/// 사용자 프로필 응답
class UserProfileResponse {
  final int userId;
  final String nickname;
  final String? profileImageUrl;
  final String? birthDate;      // 2026-01-12 형식
  final String? gender;         // MALE, FEMALE
  final int? height;            // cm
  final int? weight;            // kg

  UserProfileResponse({
    required this.userId,
    required this.nickname,
    this.profileImageUrl,
    this.birthDate,
    this.gender,
    this.height,
    this.weight,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      userId: json['userId'] as int,
      nickname: json['nickname'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String?,
      birthDate: json['birthDate'] as String?,
      gender: json['gender'] as String?,
      height: json['height'] as int?,
      weight: json['weight'] as int?,
    );
  }
}
