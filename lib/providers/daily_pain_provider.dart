import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dduduk_app/models/exercise/daily_pain.dart';
import 'package:dduduk_app/repositories/daily_pain_repository.dart';
import 'package:dduduk_app/api/api_exception.dart';

/// 일일 통증 상태 클래스
class DailyPainState {
  final int? currentPainLevel;
  final int recoveryRate;
  final DailyPainResponse? lastRecord;
  final bool isLoading;
  final String? error;

  const DailyPainState({
    this.currentPainLevel,
    this.recoveryRate = 0,
    this.lastRecord,
    this.isLoading = false,
    this.error,
  });

  DailyPainState copyWith({
    int? currentPainLevel,
    int? recoveryRate,
    DailyPainResponse? lastRecord,
    bool? isLoading,
    String? error,
  }) {
    return DailyPainState(
      currentPainLevel: currentPainLevel ?? this.currentPainLevel,
      recoveryRate: recoveryRate ?? this.recoveryRate,
      lastRecord: lastRecord ?? this.lastRecord,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// 통증이 기록되었는지 확인
  bool get hasPainRecord => currentPainLevel != null;
}

/// 일일 통증 상태 관리 Notifier
class DailyPainNotifier extends StateNotifier<DailyPainState> {
  final DailyPainRepository _repository;

  DailyPainNotifier({DailyPainRepository? repository})
      : _repository = repository ?? DailyPainRepository(),
        super(const DailyPainState());

  /// 일일 통증 기록 생성/업데이트
  Future<bool> recordDailyPain({
    required String recordDate,
    required int painLevel,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.createOrUpdateDailyPain(
        recordDate: recordDate,
        painLevel: painLevel,
      );
      state = state.copyWith(
        currentPainLevel: painLevel,
        lastRecord: response,
        isLoading: false,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.userMessage,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '통증 기록 저장 중 오류가 발생했습니다.',
      );
      return false;
    }
  }

  /// 현재 통증 레벨 설정 (UI 상태만 업데이트)
  void setCurrentPainLevel(int painLevel) {
    state = state.copyWith(currentPainLevel: painLevel);
  }

  /// 회복률 조회
  Future<void> fetchRecoveryRate({String? date}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final recoveryRate = await _repository.getRecoveryRate(date: date);
      state = state.copyWith(
        recoveryRate: recoveryRate,
        isLoading: false,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.userMessage,
      );
    } catch (e) {
      state = state.copyWith(
        recoveryRate: 0,
        isLoading: false,
      );
    }
  }

  /// 에러 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// 상태 초기화
  void reset() {
    state = const DailyPainState();
  }

  /// 통증 레벨 초기화
  void clearPainLevel() {
    state = state.copyWith(currentPainLevel: null);
  }
}

/// Daily Pain Provider (Riverpod)
final dailyPainProvider = StateNotifierProvider<DailyPainNotifier, DailyPainState>((ref) {
  return DailyPainNotifier();
});
