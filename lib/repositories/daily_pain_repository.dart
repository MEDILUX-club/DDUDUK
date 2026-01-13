import 'package:flutter/foundation.dart';
import 'package:dduduk_app/api/api_client.dart';
import 'package:dduduk_app/api/endpoints.dart';
import 'package:dduduk_app/models/exercise/daily_pain.dart';
import 'package:dduduk_app/services/token_service.dart';

/// 일일 통증 기록 API Repository
class DailyPainRepository {
  final ApiClient _apiClient;

  DailyPainRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  /// 일일 통증 기록 생성/업데이트
  /// 
  /// 운동 전 매 회차마다 통증정보 업데이트
  Future<DailyPainResponse?> createOrUpdateDailyPain({
    required String recordDate,
    required int painLevel,
  }) async {
    final userId = TokenService.instance.getUserId();

    debugPrint('Daily Pain 제출 시도');
    debugPrint('  - User ID: $userId');
    debugPrint('  - Record Date: $recordDate');
    debugPrint('  - Pain Level: $painLevel');

    if (userId == null) {
      throw Exception('User not logged in');
    }

    final request = DailyPainRequest(
      recordDate: recordDate,
      painLevel: painLevel,
    );

    final response = await _apiClient.post(
      Endpoints.dailyPain(userId),
      data: request.toJson(),
    );

    debugPrint('Daily Pain 응답 타입: ${response.data.runtimeType}');
    debugPrint('Daily Pain 응답 데이터: ${response.data}');

    // API 응답이 문자열인 경우 (성공 메시지만 반환하는 경우)
    if (response.data is String) {
      debugPrint('Daily Pain 저장 성공 (문자열 응답)');
      return null;
    }

    // API 응답이 Map인 경우
    if (response.data is Map<String, dynamic>) {
      return DailyPainResponse.fromJson(response.data as Map<String, dynamic>);
    }

    return null;
  }
}
