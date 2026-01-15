import 'package:dduduk_app/api/api_client.dart';
import 'package:dduduk_app/api/endpoints.dart';
import 'package:dduduk_app/models/exercise/exercise_ability.dart';
import 'package:dduduk_app/services/token_service.dart';

/// 운동 능력 평가 API Repository
class ExerciseAbilityRepository {
  final ApiClient _apiClient;

  ExerciseAbilityRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  /// 현재 로그인된 사용자 ID 가져오기
  int get _userId {
    final userId = TokenService.instance.getUserId();
    if (userId == null) {
      throw Exception('User not logged in');
    }
    return userId;
  }

  /// 운동 능력 평가 생성 (exercise_survey1~4 완료 후 호출)
  Future<ExerciseAbilityResponse> createExerciseAbility(
    ExerciseAbilityRequest request,
  ) async {
    final response = await _apiClient.post(
      Endpoints.exerciseAbility(_userId),
      data: request.toJson(),
    );

    return ExerciseAbilityResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  /// 운동 능력 평가 조회
  Future<ExerciseAbilityResponse?> getExerciseAbility() async {
    try {
      final response = await _apiClient.get(
        Endpoints.exerciseAbility(_userId),
      );

      // API 응답이 Map인 경우에만 파싱
      if (response.data is Map<String, dynamic>) {
        return ExerciseAbilityResponse.fromJson(response.data as Map<String, dynamic>);
      }
      
      return null;
    } catch (e) {
      // 평가가 없는 경우 (404 등) null 반환
      return null;
    }
  }
}
