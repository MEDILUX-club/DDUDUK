import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dduduk_app/models/survey/survey_data.dart';
import 'package:dduduk_app/models/survey/post_users_pain_survey.dart';
import 'package:dduduk_app/repositories/pain_survey_repository.dart';
import 'package:dduduk_app/repositories/user_repository.dart';
import 'package:dduduk_app/api/api_exception.dart';

/// 설문 상태
class SurveyState {
  final SurveyData surveyData;
  final bool isLoading;
  final String? error;
  final PainSurveyResponse? result;

  const SurveyState({
    required this.surveyData,
    this.isLoading = false,
    this.error,
    this.result,
  });

  SurveyState copyWith({
    SurveyData? surveyData,
    bool? isLoading,
    String? error,
    PainSurveyResponse? result,
  }) {
    return SurveyState(
      surveyData: surveyData ?? this.surveyData,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      result: result ?? this.result,
    );
  }
}

/// 설문 상태 관리 Notifier
class SurveyNotifier extends StateNotifier<SurveyState> {
  final PainSurveyRepository _painSurveyRepository;
  final UserRepository _userRepository;

  SurveyNotifier({
    PainSurveyRepository? painSurveyRepository,
    UserRepository? userRepository,
  })  : _painSurveyRepository = painSurveyRepository ?? PainSurveyRepository(),
        _userRepository = userRepository ?? UserRepository(),
        super(SurveyState(surveyData: SurveyData()));

  // ──────────────────────────────────────
  // Step 1: 기본 정보
  // ──────────────────────────────────────

  void updateBasicInfo({
    String? birthDate,
    int? height,
    int? weight,
    String? gender,
  }) {
    state.surveyData.birthDate = birthDate;
    state.surveyData.height = height;
    state.surveyData.weight = weight;
    state.surveyData.gender = gender;
    state = state.copyWith(surveyData: state.surveyData);
  }

  // ──────────────────────────────────────
  // Step 2: 통증 부위
  // ──────────────────────────────────────

  void updatePainArea(String painArea) {
    state.surveyData.painArea = painArea;
    state = state.copyWith(surveyData: state.surveyData);
  }

  // ──────────────────────────────────────
  // Step 3: 통증 기본 정보
  // ──────────────────────────────────────

  void updatePainBasicInfo({
    String? affectedSide,
    List<String>? painAreaDetails,
    String? painStartedDate,
  }) {
    state.surveyData.affectedSide = affectedSide;
    state.surveyData.painAreaDetails = painAreaDetails;
    state.surveyData.painStartedDate = painStartedDate;
    state = state.copyWith(surveyData: state.surveyData);
  }

  // ──────────────────────────────────────
  // Step 4: 통증 세부 정보
  // ──────────────────────────────────────

  void updatePainDetailInfo({
    double? painLevel,
    Set<String>? painTriggers,
    String? painSensation,
    String? painDuration,
  }) {
    state.surveyData.painLevel = painLevel;
    state.surveyData.painTriggers = painTriggers;
    state.surveyData.painSensation = painSensation;
    state.surveyData.painDuration = painDuration;
    state = state.copyWith(surveyData: state.surveyData);
  }

  // ──────────────────────────────────────
  // Step 5: 위험 신호
  // ──────────────────────────────────────

  void updateRedFlags(String redFlags) {
    state.surveyData.redFlags = redFlags;
    state = state.copyWith(surveyData: state.surveyData);
  }

  // ──────────────────────────────────────
  // API 제출
  // ──────────────────────────────────────

  /// 설문 데이터를 API에 제출
  /// 1. 사용자 기본 정보(생년월일, 성별, 키, 몸무게) 먼저 저장
  /// 2. pain-survey API 호출
  Future<bool> submitSurvey() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // 1. 사용자 기본 정보 저장 (PUT /api/users/{userId})
      final surveyData = state.surveyData;
      if (surveyData.birthDate != null &&
          surveyData.gender != null &&
          surveyData.height != null &&
          surveyData.weight != null) {
        // 성별 변환: 남성 -> MALE, 여성 -> FEMALE, 비공개 -> PREFER_NOT_TO_SAY
        String genderCode;
        switch (surveyData.gender) {
          case '남성':
            genderCode = 'MALE';
            break;
          case '여성':
            genderCode = 'FEMALE';
            break;
          default:
            genderCode = 'PREFER_NOT_TO_SAY';
        }

        await _userRepository.saveInitialInfo(
          birthDate: surveyData.birthDate!,
          gender: genderCode,
          height: surveyData.height!,
          weight: surveyData.weight!,
        );
      }

      // 2. pain-survey API 호출 (POST /api/users/{userId}/pain-survey)
      final result = await _painSurveyRepository.createPainSurvey(surveyData);
      state = state.copyWith(isLoading: false, result: result);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.userMessage);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '설문 제출 중 오류가 발생했습니다.',
      );
      return false;
    }
  }

  // ──────────────────────────────────────
  // 초기화
  // ──────────────────────────────────────

  /// 설문 데이터 초기화 (새로운 설문 시작 시)
  void reset() {
    state = SurveyState(surveyData: SurveyData());
  }
}

/// Survey Provider (Riverpod)
final surveyProvider =
    StateNotifierProvider<SurveyNotifier, SurveyState>((ref) {
  return SurveyNotifier();
});
