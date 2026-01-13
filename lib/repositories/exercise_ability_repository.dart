import 'package:flutter/foundation.dart';
import 'package:dduduk_app/api/api_client.dart';
import 'package:dduduk_app/api/endpoints.dart';
import 'package:dduduk_app/models/exercise/exercise_ability.dart';
import 'package:dduduk_app/services/token_service.dart';

/// 운동 능력 평가 API Repository
class ExerciseAbilityRepository {
  final ApiClient _apiClient;

  ExerciseAbilityRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  /// 운동 능력 평가 생성 (exercise_survey1~4 완료 후 호출)
  Future<ExerciseAbilityResponse> createExerciseAbility(
    ExerciseAbilityRequest request,
  ) async {
    final userId = TokenService.instance.getUserId();

    debugPrint('Exercise Ability 제출 시도');
    debugPrint('  - User ID: $userId');

    if (userId == null) {
      throw Exception('User not logged in');
    }

    final response = await _apiClient.post(
      Endpoints.exerciseAbility(userId),
      data: request.toJson(),
    );

    return ExerciseAbilityResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  /// 운동 능력 평가 조회
  Future<ExerciseAbilityResponse?> getExerciseAbility() async {
    final userId = TokenService.instance.getUserId();
    if (userId == null) {
      throw Exception('User not logged in');
    }

    try {
      final response = await _apiClient.get(
        Endpoints.exerciseAbility(userId),
      );

      debugPrint('Exercise Ability 응답 타입: ${response.data.runtimeType}');
      
      // API 응답이 Map인 경우에만 파싱
      if (response.data is Map<String, dynamic>) {
        return ExerciseAbilityResponse.fromJson(response.data as Map<String, dynamic>);
      }
      
      return null;
    } catch (e) {
      // 평가가 없는 경우 (404 등) null 반환
      debugPrint('Exercise Ability 조회 오류: $e');
      return null;
    }
  }
}
