import 'package:dduduk_app/api/api_client.dart';
import 'package:dduduk_app/models/exercise/exercise_recommendation.dart';
import 'package:dduduk_app/models/exercise/workout_record.dart';
import 'package:dduduk_app/services/token_service.dart';

class ExerciseRepository {
  final ApiClient _apiClient;

  ExerciseRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  /// 날짜별 운동 루틴 조회 (GET /api/routines/date)
  Future<ExerciseRecommendationResponse> getRoutineByDate(String date) async {
    final userId = TokenService.instance.getUserId();
    if (userId == null) {
      throw Exception('User not logged in');
    }

    try {
      final response = await _apiClient.get(
        '/api/routines/date',
        queryParameters: {
          'userId': userId,
          'date': date,
        },
      );

      return ExerciseRecommendationResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 최초 운동 추천 생성 (POST /api/exercise-recommendation/initial)
  /// 
  /// 반환값: AI가 추천한 운동 리스트
  Future<ExerciseRecommendationResponse> createInitialRecommendation(String routineDate) async {
    final userId = TokenService.instance.getUserId();
    if (userId == null) {
      throw Exception('User not logged in');
    }

    try {
      final response = await _apiClient.post(
        '/api/exercise-recommendation/initial',
        queryParameters: {
          'userId': userId,
          'routineDate': routineDate,
        },
      );
      
      return ExerciseRecommendationResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 추천 운동 기록 저장 (POST /api/routines)
  /// 
  /// AI 추천 결과를 루틴으로 저장
  Future<ExerciseRecommendationResponse> saveRoutines({
    required String routineDate,
    required List<RecommendedExercise> exercises,
  }) async {
    final userId = TokenService.instance.getUserId();
    if (userId == null) {
      throw Exception('User not logged in');
    }

    try {
      final response = await _apiClient.post(
        '/api/routines',
        data: {
          'userId': userId,
          'routineDate': routineDate,
          'exercises': exercises.map((e) => e.toJson()).toList(),
        },
      );
      
      return ExerciseRecommendationResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 운동 기록 저장 (POST /api/workout-records)
  ///
  /// 완료된 운동 기록을 서버에 저장
  Future<void> saveWorkoutRecords({
    required String date,
    required List<WorkoutRecord> records,
  }) async {
    final userId = TokenService.instance.getUserId();
    if (userId == null) {
      throw Exception('User not logged in');
    }

    if (records.isEmpty) {
      return; // 저장할 기록이 없으면 API 호출 스킵
    }

    try {
      await _apiClient.post(
        '/api/workout-records',
        queryParameters: {
          'userId': userId,
        },
        data: {
          'date': date,
          'records': records.map((r) => r.toJson()).toList(),
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 운동 후 피드백 저장 (POST /api/users/{userId}/workout-feedback)
  ///
  /// 운동 후 RPE, 근육 자극 정도, 땀 배출 정도 피드백 저장
  Future<void> saveWorkoutFeedback({
    required String rpeResponse,
    required String muscleStimulationResponse,
    required String sweatResponse,
  }) async {
    final userId = TokenService.instance.getUserId();
    if (userId == null) {
      throw Exception('User not logged in');
    }

    try {
      await _apiClient.post(
        '/api/users/$userId/workout-feedback',
        data: {
          'rpeResponse': rpeResponse,
          'muscleStimulationResponse': muscleStimulationResponse,
          'sweatResponse': sweatResponse,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 날짜별 운동 기록 조회 (GET /api/workout-records/date)
  ///
  /// 특정 날짜의 완료된 운동 기록 조회
  Future<List<WorkoutRecord>> getWorkoutRecordsByDate(String date) async {
    final userId = TokenService.instance.getUserId();
    if (userId == null) {
      throw Exception('User not logged in');
    }

    try {
      final response = await _apiClient.get(
        '/api/workout-records/date',
        queryParameters: {
          'userId': userId,
          'date': date,
        },
      );

      if (response.data is List) {
        return (response.data as List)
            .map((json) => WorkoutRecord.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// 운동 기록이 있는 날짜 목록 조회 (GET /api/workout-records/dates)
  ///
  /// 해당 유저의 운동 기록이 있는 모든 날짜 리스트 반환
  Future<List<String>> getWorkoutRecordDates() async {
    final userId = TokenService.instance.getUserId();
    if (userId == null) {
      throw Exception('User not logged in');
    }

    try {
      final response = await _apiClient.get(
        '/api/workout-records/dates',
        queryParameters: {
          'userId': userId,
        },
      );

      if (response.data is List) {
        return (response.data as List)
            .map((date) => date.toString())
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}

