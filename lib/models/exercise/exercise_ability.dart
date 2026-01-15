// 운동 능력 평가 API 요청/응답 모델
// POST /api/users/{userId}/exercise-ability

/// 운동 능력 평가 요청
class ExerciseAbilityRequest {
  final String squatResponse;
  final String pushupResponse;
  final String stepupResponse;
  final String plankResponse;

  ExerciseAbilityRequest({
    required this.squatResponse,
    required this.pushupResponse,
    required this.stepupResponse,
    required this.plankResponse,
  });

  Map<String, dynamic> toJson() {
    return {
      'squatResponse': squatResponse,
      'pushupResponse': pushupResponse,
      'stepupResponse': stepupResponse,
      'plankResponse': plankResponse,
    };
  }
}

/// 운동 능력 평가 응답
class ExerciseAbilityResponse {
  final int id;
  final int userId;
  final String squatResponse;
  final String pushupResponse;
  final String stepupResponse;
  final String plankResponse;
  final DateTime createdAt;

  ExerciseAbilityResponse({
    required this.id,
    required this.userId,
    required this.squatResponse,
    required this.pushupResponse,
    required this.stepupResponse,
    required this.plankResponse,
    required this.createdAt,
  });

  factory ExerciseAbilityResponse.fromJson(Map<String, dynamic> json) {
    return ExerciseAbilityResponse(
      id: json['id'] as int,
      userId: json['userId'] as int,
      squatResponse: json['squatResponse'] as String,
      pushupResponse: json['pushupResponse'] as String,
      stepupResponse: json['stepupResponse'] as String,
      plankResponse: json['plankResponse'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
