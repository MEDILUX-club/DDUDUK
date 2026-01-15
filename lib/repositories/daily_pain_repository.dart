import 'package:dduduk_app/api/api_client.dart';
import 'package:dduduk_app/api/endpoints.dart';
import 'package:dduduk_app/models/exercise/daily_pain.dart';
import 'package:dduduk_app/services/token_service.dart';

/// 일일 통증 기록 API Repository
class DailyPainRepository {
  final ApiClient _apiClient;

  DailyPainRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  /// 현재 로그인된 사용자 ID 가져오기
  int get _userId {
    final userId = TokenService.instance.getUserId();
    if (userId == null) {
      throw Exception('User not logged in');
    }
    return userId;
  }

  /// 일일 통증 기록 생성/업데이트
  /// 
  /// 운동 전 매 회차마다 통증정보 업데이트
  Future<DailyPainResponse?> createOrUpdateDailyPain({
    required String recordDate,
    required int painLevel,
  }) async {
    final request = DailyPainRequest(
      recordDate: recordDate,
      painLevel: painLevel,
    );

    final response = await _apiClient.post(
      Endpoints.dailyPain(_userId),
      data: request.toJson(),
    );

    // API 응답이 문자열인 경우 (성공 메시지만 반환하는 경우)
    if (response.data is String) {
      return null;
    }

    // API 응답이 Map인 경우
    if (response.data is Map<String, dynamic>) {
      return DailyPainResponse.fromJson(response.data as Map<String, dynamic>);
    }

    return null;
  }

  /// 회복률 조회 (GET)
  /// 
  /// 오늘 날짜 기준으로 회복률을 조회합니다.
  /// date 파라미터가 없으면 서버에서 오늘 날짜로 계산합니다.
  Future<int> getRecoveryRate({String? date}) async {
    final queryParams = <String, dynamic>{};
    if (date != null) {
      queryParams['date'] = date;
    }

    final response = await _apiClient.get(
      Endpoints.dailyPain(_userId),
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      final recoveryRate = data['recoveryRate'];
      if (recoveryRate is int) {
        return recoveryRate;
      } else if (recoveryRate is double) {
        return recoveryRate.round();
      }
    }

    return 0; // 기본값
  }
}
