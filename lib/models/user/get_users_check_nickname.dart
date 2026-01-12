// GET /api/users/check-nickname - 닉네임 중복 체크
//
// Query Parameters:
//   - nickname: string (required)
//
// Response: CheckNicknameResponse

/// 닉네임 중복 체크 응답
class CheckNicknameResponse {
  final bool available;

  CheckNicknameResponse({
    required this.available,
  });

  factory CheckNicknameResponse.fromJson(Map<String, dynamic> json) {
    // API 응답이 {"additionalProp1": true, "additionalProp2": true, ...} 형태인 경우
    // 실제 응답 구조에 맞게 조정 필요
    // 현재는 첫 번째 boolean 값을 사용
    if (json.isEmpty) {
      return CheckNicknameResponse(available: false);
    }

    // 만약 응답에 'available' 키가 있다면
    if (json.containsKey('available')) {
      return CheckNicknameResponse(
        available: json['available'] as bool? ?? false,
      );
    }

    // 그렇지 않으면 첫 번째 값 사용
    return CheckNicknameResponse(
      available: json.values.first as bool? ?? false,
    );
  }
}
