import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dduduk_app/models/user/put_users_profile.dart';
import 'package:dduduk_app/repositories/user_repository.dart';
import 'package:dduduk_app/api/api_exception.dart';

/// 사용자 상태 클래스
class UserState {
  final UserProfileResponse? profile;
  final bool isLoading;
  final String? error;

  const UserState({
    this.profile,
    this.isLoading = false,
    this.error,
  });

  UserState copyWith({
    UserProfileResponse? profile,
    bool? isLoading,
    String? error,
  }) {
    return UserState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// 프로필이 로드되었는지 확인
  bool get hasProfile => profile != null;

  /// 닉네임 (없으면 기본값)
  String get nickname => profile?.nickname ?? '사용자';

  /// 프로필 이미지 URL
  String? get profileImageUrl => profile?.profileImageUrl;
}

/// 사용자 상태 관리 Notifier
class UserNotifier extends StateNotifier<UserState> {
  final UserRepository _repository;

  UserNotifier({UserRepository? repository})
      : _repository = repository ?? UserRepository(),
        super(const UserState());

  /// 프로필 조회
  Future<void> fetchProfile() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final profile = await _repository.getProfile();
      state = state.copyWith(
        profile: profile,
        isLoading: false,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.userMessage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '프로필을 불러오는 중 오류가 발생했습니다.',
      );
    }
  }

  /// 프로필 업데이트
  Future<bool> updateProfile(UpdateUserRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final profile = await _repository.updateProfile(request);
      state = state.copyWith(
        profile: profile,
        isLoading: false,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.userMessage,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '프로필 업데이트 중 오류가 발생했습니다.',
      );
      return false;
    }
  }

  /// 닉네임만 업데이트
  Future<bool> updateNickname(String nickname) async {
    return updateProfile(UpdateUserRequest(nickname: nickname));
  }

  /// 프로필 이미지 업로드
  Future<bool> uploadProfileImage(File imageFile) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final imageUrl = await _repository.uploadProfileImage(imageFile);

      // 프로필 다시 조회하여 최신 상태로 업데이트
      await fetchProfile();
      return imageUrl != null;
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.userMessage,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '이미지 업로드 중 오류가 발생했습니다.',
      );
      return false;
    }
  }

  /// 닉네임 중복 확인
  Future<bool> checkNicknameDuplicate(String nickname) async {
    try {
      return await _repository.checkNicknameDuplicate(nickname);
    } catch (e) {
      return false;
    }
  }

  /// 모든 설문 초기화
  Future<bool> resetSurveys() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.resetSurveys();
      state = state.copyWith(isLoading: false);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.userMessage,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '설문 초기화 중 오류가 발생했습니다.',
      );
      return false;
    }
  }

  /// 에러 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// 상태 초기화 (로그아웃 시)
  void reset() {
    state = const UserState();
  }
}

/// User Provider (Riverpod)
final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
