// PUT /api/users/{userId} - 사용자 정보 생성/업데이트
//
// (생년월일/성별은 최초 1회만)
// Request: UpdateUserRequest
// Response: UserProfileResponse (get_users_profile.dart 참조)

export 'get_users_profile.dart' show UserProfileResponse;

/// 사용자 정보 업데이트 요청
/// 
/// 프로필 이미지는 별도 API(POST /api/users/{userId}/profile-image)로 업로드
class UpdateUserRequest {
  final String? nickname;
  final String? birthDate;      // 2026-01-12 형식 (최초 1회만)
  final String? gender;         // MALE, FEMALE (최초 1회만)
  final int? height;            // cm
  final int? weight;            // kg

  UpdateUserRequest({
    this.nickname,
    this.birthDate,
    this.gender,
    this.height,
    this.weight,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (nickname != null) map['nickname'] = nickname;
    if (birthDate != null) map['birthDate'] = birthDate;
    if (gender != null) map['gender'] = gender;
    if (height != null) map['height'] = height;
    if (weight != null) map['weight'] = weight;
    return map;
  }
}
