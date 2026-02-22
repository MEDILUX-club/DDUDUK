import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dduduk_app/models/exercise/exercise_recommendation.dart';
import 'package:dduduk_app/models/exercise/workout_record.dart';
import 'package:dduduk_app/models/exercise/weekly_workout_summary.dart';
import 'package:dduduk_app/repositories/exercise_repository.dart';
import 'package:dduduk_app/api/api_exception.dart';

/// 운동 상태 클래스
class ExerciseState {
  final ExerciseRecommendationResponse? currentRoutine;
  final List<WorkoutRecord> completedRecords;
  final WeeklyWorkoutSummary? weeklySummary;
  final List<String> workoutDates;
  final bool isLoading;
  final String? error;

  const ExerciseState({
    this.currentRoutine,
    this.completedRecords = const [],
    this.weeklySummary,
    this.workoutDates = const [],
    this.isLoading = false,
    this.error,
  });

  ExerciseState copyWith({
    ExerciseRecommendationResponse? currentRoutine,
    List<WorkoutRecord>? completedRecords,
    WeeklyWorkoutSummary? weeklySummary,
    List<String>? workoutDates,
    bool? isLoading,
    String? error,
  }) {
    return ExerciseState(
      currentRoutine: currentRoutine ?? this.currentRoutine,
      completedRecords: completedRecords ?? this.completedRecords,
      weeklySummary: weeklySummary ?? this.weeklySummary,
      workoutDates: workoutDates ?? this.workoutDates,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// 오늘 루틴이 있는지 확인
  bool get hasRoutine => currentRoutine != null && currentRoutine!.exercises.isNotEmpty;

  /// 운동 개수
  int get exerciseCount => currentRoutine?.exercises.length ?? 0;
}

/// 운동 상태 관리 Notifier
class ExerciseNotifier extends StateNotifier<ExerciseState> {
  final ExerciseRepository _repository;

  ExerciseNotifier({ExerciseRepository? repository})
      : _repository = repository ?? ExerciseRepository(),
        super(const ExerciseState());

  /// 날짜별 루틴 조회
  Future<void> fetchRoutineByDate(String date) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final routine = await _repository.getRoutineByDate(date);
      state = state.copyWith(
        currentRoutine: routine,
        isLoading: false,
      );
    } on ApiException catch (e) {
      // 403 에러 발생 시 (루틴이 없는 경우) 생성 시도
      if (e.statusCode == 403) {
        try {
          ExerciseRecommendationResponse? generatedRoutine;
          
          // 이전 운동 기록이 있는지 확인하여 Initial / Repeat 결정
          final previousDate = _getPreviousDate(date);
          
          if (previousDate != null) {
            // 2-1. 이전 기록이 있으면: Repeat (반복 추천) 시도
            try {
              generatedRoutine = await _repository.createRepeatRecommendation(
                routineDate: date,
                previousRoutineDate: previousDate,
              );
            } catch (repeatError) {
              // Repeat 실패 시 (예: 403) -> Initial (최초 추천)로 재시도
              generatedRoutine = await _repository.createInitialRecommendation(date);
            }
          } else {
            // 2-2. 이전 기록이 없으면: Initial (최초 추천)
            generatedRoutine = await _repository.createInitialRecommendation(date);
          }

          // 3. 생성된 추천 루틴 저장
          final savedRoutine = await _repository.saveRoutines(
            routineDate: date,
            exercises: generatedRoutine.exercises,
          );

          state = state.copyWith(
            currentRoutine: savedRoutine,
            isLoading: false,
          );
          return;
        } catch (fallbackError) {
          // 생성/저장 실패 시
        }
      }

      state = state.copyWith(
        isLoading: false,
        error: e.userMessage,
      );
    } catch (e) {
      state = state.copyWith(
        currentRoutine: null,
        isLoading: false,
      );
    }
  }

  /// 현재 날짜(date) 직전의 운동 날짜 반환
  String? _getPreviousDate(String currentDate) {
    if (state.workoutDates.isEmpty) return null;

    // 날짜 정렬 (오름차순)
    final sortedDates = [...state.workoutDates]..sort();
    
    // currentDate보다 작은 값 중 가장 큰 값 찾기
    String? lastDate;
    for (final date in sortedDates) {
      if (date.compareTo(currentDate) < 0) {
        lastDate = date;
      } else {
        break; // currentDate보다 크거나 같으면 중단
      }
    }
    return lastDate;
  }

  /// 최초 운동 추천 생성
  Future<bool> createInitialRecommendation(String routineDate) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final routine = await _repository.createInitialRecommendation(routineDate);
      state = state.copyWith(
        currentRoutine: routine,
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
        error: '운동 추천 생성 중 오류가 발생했습니다.',
      );
      return false;
    }
  }

  /// 반복 운동 추천 생성
  Future<bool> createRepeatRecommendation({
    required String routineDate,
    required String previousRoutineDate,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final routine = await _repository.createRepeatRecommendation(
        routineDate: routineDate,
        previousRoutineDate: previousRoutineDate,
      );
      state = state.copyWith(
        currentRoutine: routine,
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
        error: '운동 추천 생성 중 오류가 발생했습니다.',
      );
      return false;
    }
  }

  /// 추천 운동 루틴 저장
  Future<bool> saveRoutines({
    required String routineDate,
    required List<RecommendedExercise> exercises,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final routine = await _repository.saveRoutines(
        routineDate: routineDate,
        exercises: exercises,
      );
      state = state.copyWith(
        currentRoutine: routine,
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
        error: '루틴 저장 중 오류가 발생했습니다.',
      );
      return false;
    }
  }

  /// 운동 기록 저장
  Future<bool> saveWorkoutRecords({
    required String date,
    required List<WorkoutRecord> records,
  }) async {
    if (records.isEmpty) return true;

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.saveWorkoutRecords(date: date, records: records);
      state = state.copyWith(
        completedRecords: records,
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
        error: '운동 기록 저장 중 오류가 발생했습니다.',
      );
      return false;
    }
  }

  /// 날짜별 운동 기록 조회
  Future<void> fetchWorkoutRecordsByDate(String date) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final records = await _repository.getWorkoutRecordsByDate(date);
      state = state.copyWith(
        completedRecords: records,
        isLoading: false,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.userMessage,
      );
    } catch (e) {
      state = state.copyWith(
        completedRecords: [],
        isLoading: false,
      );
    }
  }

  /// 운동 기록이 있는 날짜 목록 조회
  Future<void> fetchWorkoutDates() async {
    try {
      final dates = await _repository.getWorkoutRecordDates();
      state = state.copyWith(workoutDates: dates);
    } catch (e) {
      // 실패해도 무시
    }
  }

  /// 운동 후 피드백 저장
  Future<bool> saveWorkoutFeedback({
    required String rpeResponse,
    required String muscleStimulationResponse,
    required String sweatResponse,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.saveWorkoutFeedback(
        rpeResponse: rpeResponse,
        muscleStimulationResponse: muscleStimulationResponse,
        sweatResponse: sweatResponse,
      );
      state = state.copyWith(isLoading: false);
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
        error: '피드백 저장 중 오류가 발생했습니다.',
      );
      return false;
    }
  }

  /// 주간 운동 요약 조회
  Future<void> fetchWeeklySummary(String referenceDate) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final summary = await _repository.getWeeklySummary(referenceDate: referenceDate);
      state = state.copyWith(
        weeklySummary: summary,
        isLoading: false,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.userMessage,
      );
    } catch (e) {
      state = state.copyWith(
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
    state = const ExerciseState();
  }

  /// 완료된 기록 초기화
  void clearCompletedRecords() {
    state = state.copyWith(completedRecords: []);
  }
}

/// Exercise Provider (Riverpod)
final exerciseProvider = StateNotifierProvider<ExerciseNotifier, ExerciseState>((ref) {
  return ExerciseNotifier();
});
