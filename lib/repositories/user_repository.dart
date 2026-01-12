import 'package:dduduk_app/api/api_client.dart';
import 'package:dduduk_app/api/endpoints.dart';
import 'package:dduduk_app/models/user/put_users_profile.dart';
import 'package:dduduk_app/services/token_service.dart';

/// 사용자 프로필 API Repository
class UserRepository {
  final ApiClient _apiClient;

  UserRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  /// 사용자 프로필 조회
  Future<UserProfileResponse> getProfile() async {
    final userId = TokenService.instance.getUserId();
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final response = await _apiClient.get(Endpoints.user(userId));
    return UserProfileResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  /// 사용자 프로필 업데이트
  /// 
  /// birthDate, gender는 최초 1회만 설정 가능
  Future<UserProfileResponse> updateProfile(UpdateUserRequest request) async {
    final userId = TokenService.instance.getUserId();
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final response = await _apiClient.put(
      Endpoints.user(userId),
      data: request.toJson(),
    );
    return UserProfileResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  /// 닉네임과 프로필 이미지만 업데이트 (마이페이지용)
  Future<UserProfileResponse> updateDisplayInfo({
    String? nickname,
    String? profileImageUrl,
  }) async {
    return updateProfile(UpdateUserRequest(
      nickname: nickname,
      profileImageUrl: profileImageUrl,
    ));
  }

  /// 초기 설문에서 수집한 정보 저장 (최초 1회)
  Future<UserProfileResponse> saveInitialInfo({
    required String birthDate,
    required String gender,
    required int height,
    required int weight,
  }) async {
    return updateProfile(UpdateUserRequest(
      birthDate: birthDate,
      gender: gender.toUpperCase(),  // MALE, FEMALE
      height: height,
      weight: weight,
    ));
  }
}
