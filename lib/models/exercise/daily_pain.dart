// 일일 통증 기록 API 요청/응답 모델
// POST /api/users/{userId}/daily-pain

/// 일일 통증 기록 요청
class DailyPainRequest {
  final String recordDate;  // 날짜 (YYYY-MM-DD)
  final int painLevel;       // 통증 레벨 (0-10)

  DailyPainRequest({
    required this.recordDate,
    required this.painLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'recordDate': recordDate,
      'painLevel': painLevel,
    };
  }
}

/// 일일 통증 기록 응답
class DailyPainResponse {
  final int id;
  final int userId;
  final String recordDate;
  final int painLevel;
  final DateTime createdAt;

  DailyPainResponse({
    required this.id,
    required this.userId,
    required this.recordDate,
    required this.painLevel,
    required this.createdAt,
  });

  factory DailyPainResponse.fromJson(Map<String, dynamic> json) {
    return DailyPainResponse(
      id: json['id'] as int,
      userId: json['userId'] as int,
      recordDate: json['recordDate'] as String,
      painLevel: json['painLevel'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
