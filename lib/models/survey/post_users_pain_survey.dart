// /api/users/{userId}/pain-survey - 통증 설문 API
//
// POST - 통증 설문 생성
// 초기 설문 완료 시 호출하여 AI 진단 결과를 받습니다.
// Request: PainSurveyRequest
// Response: PainSurveyResponse
//
// GET - 통증 설문 조회
// 기존 설문 결과를 조회합니다. (읽기 전용 리뷰, 마이페이지)
// Response: PainSurveyResponse

// ──────────────────────────────────────
// Request
// ──────────────────────────────────────

class PainSurveyRequest {
  final String painArea;           // 통증 부위 (step2)
  final String affectedSide;       // 어느 쪽 (step3) - 왼쪽/오른쪽/모두
  final String painStartedDate;    // 언제부터 (step3)
  final int painLevel;             // 통증 강도 (step4) - 0~10
  final String painTrigger;        // 언제 심해지나요 (step4)
  final String painSensation;      // 통증 느낌 (step4)
  final String painDuration;       // 통증 지속시간 (step4)
  final String redFlags;           // 위험 신호 (step5)

  PainSurveyRequest({
    required this.painArea,
    required this.affectedSide,
    required this.painStartedDate,
    required this.painLevel,
    required this.painTrigger,
    required this.painSensation,
    required this.painDuration,
    required this.redFlags,
  });

  Map<String, dynamic> toJson() => {
        'painArea': painArea,
        'affectedSide': affectedSide,
        'painStartedDate': painStartedDate,
        'painLevel': painLevel,
        'painTrigger': painTrigger,
        'painSensation': painSensation,
        'painDuration': painDuration,
        'redFlags': redFlags,
      };
}

// ──────────────────────────────────────
// Response
// ──────────────────────────────────────

class PainSurveyResponse {
  final int id;
  final int userId;
  final String painArea;
  final String affectedSide;
  final String painStartedDate;
  final int painLevel;
  final String painTrigger;
  final String painSensation;
  final String painDuration;
  final String redFlags;
  final String? diagnosis;         // AI 진단 결과
  final String? recommendation;    // AI 추천
  final DateTime createdAt;

  PainSurveyResponse({
    required this.id,
    required this.userId,
    required this.painArea,
    required this.affectedSide,
    required this.painStartedDate,
    required this.painLevel,
    required this.painTrigger,
    required this.painSensation,
    required this.painDuration,
    required this.redFlags,
    this.diagnosis,
    this.recommendation,
    required this.createdAt,
  });

  factory PainSurveyResponse.fromJson(Map<String, dynamic> json) {
    return PainSurveyResponse(
      id: json['id'] as int,
      userId: json['userId'] as int,
      painArea: json['painArea'] as String? ?? '',
      affectedSide: json['affectedSide'] as String? ?? '',
      painStartedDate: json['painStartedDate'] as String? ?? '',
      painLevel: json['painLevel'] as int? ?? 0,
      painTrigger: json['painTrigger'] as String? ?? '',
      painSensation: json['painSensation'] as String? ?? '',
      painDuration: json['painDuration'] as String? ?? '',
      redFlags: json['redFlags'] as String? ?? '',
      diagnosis: json['diagnosis'] as String?,
      recommendation: json['recommendation'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'painArea': painArea,
        'affectedSide': affectedSide,
        'painStartedDate': painStartedDate,
        'painLevel': painLevel,
        'painTrigger': painTrigger,
        'painSensation': painSensation,
        'painDuration': painDuration,
        'redFlags': redFlags,
        'diagnosis': diagnosis,
        'recommendation': recommendation,
        'createdAt': createdAt.toIso8601String(),
      };
}
