import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dduduk_app/api/api_client.dart';
import 'package:dduduk_app/api/endpoints.dart';
import 'package:dduduk_app/models/user/put_users_profile.dart';
import 'package:dduduk_app/models/user/get_users_check_nickname.dart';
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

  /// 닉네임만 업데이트 (마이페이지용)
  /// 
  /// 프로필 이미지는 [uploadProfileImage]로 별도 업로드
  Future<UserProfileResponse> updateDisplayInfo({
    String? nickname,
  }) async {
    return updateProfile(UpdateUserRequest(
      nickname: nickname,
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

  /// 닉네임 중복 확인
  ///
  /// 사용 가능하면 true, 이미 사용 중이면 false 반환
  Future<bool> checkNicknameDuplicate(String nickname) async {
    final response = await _apiClient.get(
      Endpoints.checkNickname,
      queryParameters: {'nickname': nickname},
    );

    final result = CheckNicknameResponse.fromJson(
      response.data as Map<String, dynamic>,
    );

    return result.available;
  }

  /// 모든 설문 초기화
  ///
  /// 통증설문, 운동능력평가, 일일통증기록, 운동피드백을 모두 삭제
  /// 통증 부위 변경 시 사용
  Future<void> resetSurveys() async {
    final userId = TokenService.instance.getUserId();
    if (userId == null) {
      throw Exception('User not logged in');
    }

    await _apiClient.delete(Endpoints.resetSurveys(userId));
  }

  /// 프로필 이미지 업로드/업데이트
  /// 
  /// POST /api/users/{userId}/profile-image
  /// Multipart/FormData로 파일 전송
  /// 반환값: 업로드된 이미지 URL
  Future<String?> uploadProfileImage(File imageFile) async {
    final userId = TokenService.instance.getUserId();
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imageFile.path,
        filename: 'profile_image.jpg',
      ),
    });

    final response = await _apiClient.post(
      '/api/users/$userId/profile-image',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );

    // 응답에서 URL 추출 (API 응답 형태에 따라 조정 필요)
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      // additionalProp1, additionalProp2 등 키가 어떤 것인지 확인 필요
      return data.values.firstOrNull?.toString();
    }
    return null;
  }
}
