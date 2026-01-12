import 'package:dduduk_app/api/api_client.dart';
import 'package:dduduk_app/api/endpoints.dart';
import 'package:dduduk_app/models/auth/post_auth_login.dart';
import 'package:dduduk_app/services/token_service.dart';

/// 인증 관련 API Repository
class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  /// 소셜 로그인 → 서버 토큰 발급
  ///
  /// 소셜 로그인 완료 후 호출하여 서버에서 JWT 토큰을 발급받습니다.
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _apiClient.post(
      Endpoints.login,
      data: request.toJson(),
    );

    final loginResponse = LoginResponse.fromJson(
      response.data as Map<String, dynamic>,
    );

    // 토큰 저장
    final tokenService = await TokenService.getInstance();
    await tokenService.saveTokens(
      accessToken: loginResponse.accessToken,
      refreshToken: loginResponse.refreshToken,
      userId: loginResponse.user.id,
    );

    return loginResponse;
  }

  /// 토큰 갱신
  Future<LoginResponse> refresh() async {
    final tokenService = await TokenService.getInstance();
    final refreshToken = tokenService.getRefreshToken();

    if (refreshToken == null) {
      throw Exception('Refresh token not found');
    }

    final response = await _apiClient.post(
      Endpoints.refresh,
      data: {'refreshToken': refreshToken},
    );

    final loginResponse = LoginResponse.fromJson(
      response.data as Map<String, dynamic>,
    );

    // 새 토큰 저장
    await tokenService.saveTokens(
      accessToken: loginResponse.accessToken,
      refreshToken: loginResponse.refreshToken,
      userId: loginResponse.user.id,
    );

    return loginResponse;
  }

  /// 로그아웃
  Future<void> logout() async {
    final tokenService = await TokenService.getInstance();
    await tokenService.clearAll();
  }

  /// 현재 로그인 상태 확인
  Future<bool> isLoggedIn() async {
    final tokenService = await TokenService.getInstance();
    return tokenService.isLoggedIn;
  }

  /// 현재 사용자 ID 가져오기
  Future<int?> getCurrentUserId() async {
    final tokenService = await TokenService.getInstance();
    return tokenService.getUserId();
  }
}
