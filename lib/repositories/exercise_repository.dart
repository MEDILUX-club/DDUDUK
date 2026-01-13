import 'package:dduduk_app/api/api_client.dart';
import 'package:dduduk_app/models/exercise/exercise_recommendation.dart';
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
}
