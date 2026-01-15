import 'package:dduduk_app/api/api_client.dart';
import 'package:dduduk_app/api/endpoints.dart';
import 'package:dduduk_app/models/survey/post_users_pain_survey.dart';
import 'package:dduduk_app/models/survey/survey_data.dart';
import 'package:dduduk_app/services/token_service.dart';

/// 통증 설문 API Repository
class PainSurveyRepository {
  final ApiClient _apiClient;

  PainSurveyRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  /// 현재 로그인된 사용자 ID 가져오기
  int get _userId {
    final userId = TokenService.instance.getUserId();
    if (userId == null) {
      throw Exception('User not logged in');
    }
    return userId;
  }

  /// 통증 설문 생성 (step1~5 완료 후 호출)
  ///
  /// [surveyData] 수집된 설문 데이터
  /// Returns AI 진단 결과가 포함된 응답
  Future<PainSurveyResponse> createPainSurvey(SurveyData surveyData) async {
    final response = await _apiClient.post(
      Endpoints.painSurvey(_userId),
      data: surveyData.toApiRequest(),
    );

    return PainSurveyResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  /// 통증 설문 조회
  Future<PainSurveyResponse?> getPainSurvey() async {
    try {
      final response = await _apiClient.get(
        Endpoints.painSurvey(_userId),
      );

      return PainSurveyResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      // 설문이 없는 경우 null 반환
      return null;
    }
  }
}
