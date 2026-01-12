/// 설문 데이터를 화면간 전달하기 위한 모델
/// 
/// step1~5까지 수집된 데이터를 저장하고
/// step5 완료 시 API에 제출합니다.
class SurveyData {
  // Step 1: 기본 정보 (API에는 포함되지 않음 - 별도 User API로 전송)
  String? birthDate;
  int? height;
  int? weight;
  String? gender;

  // Step 2: 통증 부위
  String? painArea;  // 목, 팔꿈치, 어깨, 손목, 허리, 고관절, 무릎, 발목

  // Step 3: 통증 기본 정보
  String? affectedSide;  // 왼쪽, 오른쪽, 모두
  List<String>? painAreaDetails;  // 무릎 안쪽, 무릎 바깥쪽, 무릎 앞쪽 등
  String? painStartedDate;  // 언제부터 아팠나요

  // Step 4: 통증 세부 정보
  double? painLevel;  // 0~10
  Set<String>? painTriggers;  // 언제 심해지나요 (복수 선택)
  String? painSensation;  // 통증 느낌
  String? painDuration;  // 지속 시간

  // Step 5: 위험 신호
  String? redFlags;

  SurveyData();

  /// API 제출용으로 변환
  Map<String, dynamic> toApiRequest() {
    return {
      'painArea': painArea ?? '',
      'affectedSide': affectedSide ?? '',
      'painStartedDate': painStartedDate ?? '',
      'painLevel': painLevel?.round() ?? 0,
      'painTrigger': painTriggers?.join(', ') ?? '',
      'painSensation': painSensation ?? '',
      'painDuration': painDuration ?? '',
      'redFlags': redFlags ?? '',
    };
  }

  /// 모든 필수 데이터가 입력되었는지 확인
  bool get isComplete {
    return painArea != null &&
        affectedSide != null &&
        painStartedDate != null &&
        painLevel != null &&
        painTriggers != null &&
        painTriggers!.isNotEmpty &&
        painSensation != null &&
        redFlags != null;
  }

  /// 복사본 생성
  SurveyData copyWith({
    String? birthDate,
    int? height,
    int? weight,
    String? gender,
    String? painArea,
    String? affectedSide,
    List<String>? painAreaDetails,
    String? painStartedDate,
    double? painLevel,
    Set<String>? painTriggers,
    String? painSensation,
    String? painDuration,
    String? redFlags,
  }) {
    final copy = SurveyData();
    copy.birthDate = birthDate ?? this.birthDate;
    copy.height = height ?? this.height;
    copy.weight = weight ?? this.weight;
    copy.gender = gender ?? this.gender;
    copy.painArea = painArea ?? this.painArea;
    copy.affectedSide = affectedSide ?? this.affectedSide;
    copy.painAreaDetails = painAreaDetails ?? this.painAreaDetails;
    copy.painStartedDate = painStartedDate ?? this.painStartedDate;
    copy.painLevel = painLevel ?? this.painLevel;
    copy.painTriggers = painTriggers ?? this.painTriggers;
    copy.painSensation = painSensation ?? this.painSensation;
    copy.painDuration = painDuration ?? this.painDuration;
    copy.redFlags = redFlags ?? this.redFlags;
    return copy;
  }

  @override
  String toString() {
    return 'SurveyData(painArea: $painArea, affectedSide: $affectedSide, '
        'painStartedDate: $painStartedDate, painLevel: $painLevel, '
        'painTriggers: $painTriggers, painSensation: $painSensation, '
        'painDuration: $painDuration, redFlags: $redFlags)';
  }
}
