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
  final String? painArea;              // 통증 부위 (GET 응답에 포함)
  final String diagnosisType;          // AI 진단 유형 (예: "퇴행성형", "염증형", "외상형", "과사용형")
  final int diagnosisPercentage;       // 진단 확률 (0-100)
  final String diagnosisDescription;   // 진단 설명

  PainSurveyResponse({
    this.painArea,
    required this.diagnosisType,
    required this.diagnosisPercentage,
    required this.diagnosisDescription,
  });

  factory PainSurveyResponse.fromJson(Map<String, dynamic> json) {
    return PainSurveyResponse(
      painArea: json['painArea'] as String?,
      diagnosisType: json['diagnosisType'] as String? ?? '',
      diagnosisPercentage: json['diagnosisPercentage'] as int? ?? 0,
      diagnosisDescription: json['diagnosisDescription'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'diagnosisType': diagnosisType,
        'diagnosisPercentage': diagnosisPercentage,
        'diagnosisDescription': diagnosisDescription,
      };
}
