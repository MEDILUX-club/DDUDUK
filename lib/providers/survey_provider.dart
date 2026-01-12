import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dduduk_app/models/survey/survey_data.dart';
import 'package:dduduk_app/models/survey/post_users_pain_survey.dart';
import 'package:dduduk_app/repositories/pain_survey_repository.dart';
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
  final PainSurveyRepository _repository;

  SurveyNotifier({PainSurveyRepository? repository})
      : _repository = repository ?? PainSurveyRepository(),
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
  Future<bool> submitSurvey() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _repository.createPainSurvey(state.surveyData);
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
