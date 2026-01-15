import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dduduk_app/models/auth/post_auth_login.dart';
import 'package:dduduk_app/repositories/auth_repository.dart';
import 'package:dduduk_app/api/api_exception.dart';

/// 인증 상태
enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
}

/// 인증 상태 클래스
class AuthState {
  final AuthStatus status;
  final int? userId;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.userId,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    int? userId,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
}

/// 인증 상태 관리 Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier({AuthRepository? repository})
      : _repository = repository ?? AuthRepository(),
        super(const AuthState());

  /// 초기 인증 상태 확인
  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    try {
      final isLoggedIn = await _repository.isLoggedIn();
      final userId = await _repository.getCurrentUserId();

      state = state.copyWith(
        status: isLoggedIn ? AuthStatus.authenticated : AuthStatus.unauthenticated,
        userId: userId,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        isLoading: false,
      );
    }
  }

  /// 소셜 로그인
  Future<bool> login(LoginRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.login(request);
      state = state.copyWith(
        status: AuthStatus.authenticated,
        userId: response.userId,
        isLoading: false,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        isLoading: false,
        error: e.userMessage,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        isLoading: false,
        error: '로그인 중 오류가 발생했습니다.',
      );
      return false;
    }
  }

  /// 토큰 갱신
  Future<bool> refreshToken() async {
    try {
      await _repository.refresh();
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: '세션이 만료되었습니다. 다시 로그인해주세요.',
      );
      return false;
    }
  }

  /// 로그아웃
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _repository.logout();
    } finally {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  /// 에러 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Auth Provider (Riverpod)
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
