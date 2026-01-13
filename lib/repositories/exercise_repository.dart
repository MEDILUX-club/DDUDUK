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
  Future<void> createInitialRecommendation(String routineDate) async {
    final userId = TokenService.instance.getUserId();
    if (userId == null) {
      throw Exception('User not logged in');
    }

    try {
      await _apiClient.post(
        '/api/exercise-recommendation/initial',
        queryParameters: {
          'userId': userId,
          'routineDate': routineDate,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
