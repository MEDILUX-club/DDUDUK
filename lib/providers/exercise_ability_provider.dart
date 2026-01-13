import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dduduk_app/models/exercise/exercise_ability.dart';
import 'package:dduduk_app/repositories/exercise_ability_repository.dart';
import 'package:dduduk_app/api/api_exception.dart';

/// 운동 능력 평가 설문 데이터
class ExerciseAbilityData {
  String? squatResponse;   // survey1: 스쿼트 응답
  String? pushupResponse;  // survey2: 푸쉬업 응답
  String? stepupResponse;  // survey3: 계단오르기 응답
  String? plankResponse;   // survey4: 플랭크 응답

  ExerciseAbilityData({
    this.squatResponse,
    this.pushupResponse,
    this.stepupResponse,
    this.plankResponse,
  });

  /// API 요청 객체로 변환
  ExerciseAbilityRequest toRequest() {
    return ExerciseAbilityRequest(
      squatResponse: squatResponse ?? '',
      pushupResponse: pushupResponse ?? '',
      stepupResponse: stepupResponse ?? '',
      plankResponse: plankResponse ?? '',
    );
  }

  /// 모든 설문이 완료되었는지 확인
  bool get isComplete =>
      squatResponse != null &&
      pushupResponse != null &&
      stepupResponse != null &&
      plankResponse != null;
}

/// 운동 능력 평가 상태
class ExerciseAbilityState {
  final ExerciseAbilityData data;
  final bool isLoading;
  final String? error;
  final ExerciseAbilityResponse? result;

  const ExerciseAbilityState({
    required this.data,
    this.isLoading = false,
    this.error,
    this.result,
  });

  ExerciseAbilityState copyWith({
    ExerciseAbilityData? data,
    bool? isLoading,
    String? error,
    ExerciseAbilityResponse? result,
  }) {
    return ExerciseAbilityState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      result: result ?? this.result,
    );
  }
}

/// 운동 능력 평가 상태 관리 Notifier
class ExerciseAbilityNotifier extends StateNotifier<ExerciseAbilityState> {
  final ExerciseAbilityRepository _repository;

  ExerciseAbilityNotifier({
    ExerciseAbilityRepository? repository,
  })  : _repository = repository ?? ExerciseAbilityRepository(),
        super(ExerciseAbilityState(data: ExerciseAbilityData()));

  // ──────────────────────────────────────
  // Survey 1: 스쿼트
  // ──────────────────────────────────────
  void updateSquatResponse(String value) {
    state.data.squatResponse = value;
    state = state.copyWith(data: state.data);
  }

  // ──────────────────────────────────────
  // Survey 2: 푸쉬업
  // ──────────────────────────────────────
  void updatePushupResponse(String value) {
    state.data.pushupResponse = value;
    state = state.copyWith(data: state.data);
  }

  // ──────────────────────────────────────
  // Survey 3: 계단오르기
  // ──────────────────────────────────────
  void updateStepupResponse(String value) {
    state.data.stepupResponse = value;
    state = state.copyWith(data: state.data);
  }

  // ──────────────────────────────────────
  // Survey 4: 플랭크
  // ──────────────────────────────────────
  void updatePlankResponse(String value) {
    state.data.plankResponse = value;
    state = state.copyWith(data: state.data);
  }

  // ──────────────────────────────────────
  // API 제출
  // ──────────────────────────────────────
  
  /// 운동 능력 평가 데이터를 API에 제출
  Future<bool> submitExerciseAbility() async {
    if (!state.data.isComplete) {
      state = state.copyWith(error: '모든 설문을 완료해주세요.');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _repository.createExerciseAbility(
        state.data.toRequest(),
      );
      state = state.copyWith(isLoading: false, result: result);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.userMessage);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '운동 능력 평가 제출 중 오류가 발생했습니다.',
      );
      return false;
    }
  }

  // ──────────────────────────────────────
  // 초기화
  // ──────────────────────────────────────
  
  /// 설문 데이터 초기화 (새로운 설문 시작 시)
  void reset() {
    state = ExerciseAbilityState(data: ExerciseAbilityData());
  }
}

/// Exercise Ability Provider (Riverpod)
final exerciseAbilityProvider =
    StateNotifierProvider<ExerciseAbilityNotifier, ExerciseAbilityState>((ref) {
  return ExerciseAbilityNotifier();
});
