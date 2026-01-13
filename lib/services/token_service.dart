import 'package:shared_preferences/shared_preferences.dart';

/// 토큰 저장 및 관리 서비스
class TokenService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _hasStartedExerciseKey = 'has_started_exercise';

  static TokenService? _instance;
  static SharedPreferences? _prefs;

  TokenService._();

  /// 싱글톤 인스턴스 반환
  static Future<TokenService> getInstance() async {
    if (_instance == null) {
      _instance = TokenService._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  /// 동기적으로 인스턴스 반환 (이미 초기화된 경우에만)
  static TokenService get instance {
    if (_instance == null) {
      throw StateError('TokenService not initialized. Call getInstance() first.');
    }
    return _instance!;
  }

  // ──────────────────────────────────────
  // Access Token
  // ──────────────────────────────────────

  /// Access Token 저장
  Future<void> saveAccessToken(String token) async {
    await _prefs?.setString(_accessTokenKey, token);
  }

  /// Access Token 조회
  String? getAccessToken() {
    return _prefs?.getString(_accessTokenKey);
  }

  /// Access Token 삭제
  Future<void> deleteAccessToken() async {
    await _prefs?.remove(_accessTokenKey);
  }

  // ──────────────────────────────────────
  // Refresh Token
  // ──────────────────────────────────────

  /// Refresh Token 저장
  Future<void> saveRefreshToken(String token) async {
    await _prefs?.setString(_refreshTokenKey, token);
  }

  /// Refresh Token 조회
  String? getRefreshToken() {
    return _prefs?.getString(_refreshTokenKey);
  }

  /// Refresh Token 삭제
  Future<void> deleteRefreshToken() async {
    await _prefs?.remove(_refreshTokenKey);
  }

  // ──────────────────────────────────────
  // User ID
  // ──────────────────────────────────────

  /// User ID 저장
  Future<void> saveUserId(int userId) async {
    await _prefs?.setInt(_userIdKey, userId);
  }

  /// User ID 조회
  int? getUserId() {
    return _prefs?.getInt(_userIdKey);
  }

  /// User ID 삭제
  Future<void> deleteUserId() async {
    await _prefs?.remove(_userIdKey);
  }

  // ──────────────────────────────────────
  // 운동 시작 여부 (첫 운동 진입 확인용)
  // ──────────────────────────────────────

  /// 운동 시작 여부 저장
  Future<void> setHasStartedExercise(bool value) async {
    await _prefs?.setBool(_hasStartedExerciseKey, value);
  }

  /// 운동 시작 여부 조회 (기본값: false)
  bool getHasStartedExercise() {
    return _prefs?.getBool(_hasStartedExerciseKey) ?? false;
  }

  /// 운동 시작 여부 삭제
  Future<void> deleteHasStartedExercise() async {
    await _prefs?.remove(_hasStartedExerciseKey);
  }

  // ──────────────────────────────────────
  // 전체 토큰 관리
  // ──────────────────────────────────────

  /// 모든 토큰 저장
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int userId,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
      saveUserId(userId),
    ]);
  }

  /// 모든 토큰 삭제 (로그아웃 시)
  Future<void> clearAll() async {
    await Future.wait([
      deleteAccessToken(),
      deleteRefreshToken(),
      deleteUserId(),
      deleteHasStartedExercise(),
    ]);
  }

  /// 로그인 상태 확인
  bool get isLoggedIn => getAccessToken() != null;

  /// 토큰 존재 여부 확인
  bool get hasTokens =>
      getAccessToken() != null && getRefreshToken() != null;
}
