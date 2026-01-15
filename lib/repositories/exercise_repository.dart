import 'package:dduduk_app/api/api_client.dart';
import 'package:dduduk_app/api/endpoints.dart';
import 'package:dduduk_app/models/exercise/exercise_recommendation.dart';
import 'package:dduduk_app/models/exercise/workout_record.dart';
import 'package:dduduk_app/models/exercise/weekly_workout_summary.dart';
import 'package:dduduk_app/services/token_service.dart';

class ExerciseRepository {
  final ApiClient _apiClient;

  ExerciseRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  /// 현재 로그인된 사용자 ID 가져오기
  int get _userId {
    final userId = TokenService.instance.getUserId();
    if (userId == null) {
      throw Exception('User not logged in');
    }
    return userId;
  }

  /// 날짜별 운동 루틴 조회 (GET /api/routines/date)
  Future<ExerciseRecommendationResponse> getRoutineByDate(String date) async {
    final response = await _apiClient.get(
      Endpoints.routinesDate,
      queryParameters: {
        'userId': _userId,
        'date': date,
      },
    );

    return ExerciseRecommendationResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  /// 최초 운동 추천 생성 (POST /api/exercise-recommendation/initial)
  ///
  /// 반환값: AI가 추천한 운동 리스트
  Future<ExerciseRecommendationResponse> createInitialRecommendation(String routineDate) async {
    final response = await _apiClient.post(
      Endpoints.exerciseRecommendationInitial,
      queryParameters: {
        'userId': _userId,
        'routineDate': routineDate,
      },
    );

    return ExerciseRecommendationResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  /// 반복 운동 추천 생성 (POST /api/exercise-recommendation/repeat)
  ///
  /// 이전 루틴 기반 운동 추천
  /// 반환값: AI가 추천한 운동 리스트
  Future<ExerciseRecommendationResponse> createRepeatRecommendation({
    required String routineDate,
    required String previousRoutineDate,
  }) async {
    final response = await _apiClient.post(
      Endpoints.exerciseRecommendationRepeat,
      queryParameters: {
        'userId': _userId,
        'routineDate': routineDate,
        'previousRoutineDate': previousRoutineDate,
      },
    );

    return ExerciseRecommendationResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  /// 추천 운동 기록 저장 (POST /api/routines)
  /// 
  /// AI 추천 결과를 루틴으로 저장
  Future<ExerciseRecommendationResponse> saveRoutines({
    required String routineDate,
    required List<RecommendedExercise> exercises,
  }) async {
    final response = await _apiClient.post(
      Endpoints.routines,
      data: {
        'userId': _userId,
        'routineDate': routineDate,
        'exercises': exercises.map((e) => e.toJson()).toList(),
      },
    );
    
    return ExerciseRecommendationResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  /// 운동 기록 저장 (POST /api/workout-records)
  ///
  /// 완료된 운동 기록을 서버에 저장
  Future<void> saveWorkoutRecords({
    required String date,
    required List<WorkoutRecord> records,
  }) async {
    if (records.isEmpty) {
      return; // 저장할 기록이 없으면 API 호출 스킵
    }

    await _apiClient.post(
      Endpoints.workoutRecords,
      queryParameters: {
        'userId': _userId,
      },
      data: {
        'date': date,
        'records': records.map((r) => r.toJson()).toList(),
      },
    );
  }

  /// 운동 후 피드백 저장 (POST /api/users/{userId}/workout-feedback)
  ///
  /// 운동 후 RPE, 근육 자극 정도, 땀 배출 정도 피드백 저장
  Future<void> saveWorkoutFeedback({
    required String rpeResponse,
    required String muscleStimulationResponse,
    required String sweatResponse,
  }) async {
    await _apiClient.post(
      Endpoints.workoutFeedback(_userId),
      data: {
        'rpeResponse': rpeResponse,
        'muscleStimulationResponse': muscleStimulationResponse,
        'sweatResponse': sweatResponse,
      },
    );
  }

  /// 날짜별 운동 기록 조회 (GET /api/workout-records/date)
  ///
  /// 특정 날짜의 완료된 운동 기록 조회
  Future<List<WorkoutRecord>> getWorkoutRecordsByDate(String date) async {
    final response = await _apiClient.get(
      Endpoints.workoutRecordsDate,
      queryParameters: {
        'userId': _userId,
        'date': date,
      },
    );

    if (response.data is List) {
      return (response.data as List)
          .map((json) => WorkoutRecord.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// 운동 기록이 있는 날짜 목록 조회 (GET /api/workout-records/dates)
  ///
  /// 해당 유저의 운동 기록이 있는 모든 날짜 리스트 반환
  Future<List<String>> getWorkoutRecordDates() async {
    final response = await _apiClient.get(
      Endpoints.workoutRecordsDates,
      queryParameters: {
        'userId': _userId,
      },
    );

    if (response.data is List) {
      return (response.data as List)
          .map((date) => date.toString())
          .toList();
    }
    return [];
  }

  /// 주간 운동 요약 조회 (GET /api/workout-records/weekly-summary)
  ///
  /// 이번 주와 지난 주의 운동 횟수와 총 시간 비교
  Future<WeeklyWorkoutSummary> getWeeklySummary({
    required String referenceDate,
  }) async {
    final response = await _apiClient.get(
      Endpoints.workoutRecordsWeeklySummary,
      queryParameters: {
        'userId': _userId,
        'referenceDate': referenceDate,
      },
    );

    return WeeklyWorkoutSummary.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
