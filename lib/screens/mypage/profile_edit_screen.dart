import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dduduk_app/layouts/default_layout.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/common/custom_text_field.dart';
import 'package:dduduk_app/widgets/mypage/profile_photo_picker.dart';
import 'package:dduduk_app/repositories/user_repository.dart';

/// 프로필 설정 화면
class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _nicknameController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _userRepository = UserRepository();

  File? _profileImage;
  bool _isLoading = true;
  bool _isSaving = false;

  // 닉네임 유효성 검사 관련 상태
  String? _nicknameError;
  bool _isCheckingNickname = false;

  // 닉네임 제한 상수
  static const int _minNicknameLength = 2;
  static const int _maxNicknameLength = 14;

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(_onNicknameChanged);
    _loadProfile();
  }

  /// 서버에서 프로필 정보 로드
  Future<void> _loadProfile() async {
    try {
      final profile = await _userRepository.getProfile();
      if (mounted) {
        setState(() {
          _nicknameController.text = profile.nickname;
          _heightController.text = profile.height?.toString() ?? '';
          _weightController.text = profile.weight?.toString() ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('프로필 로딩 오류: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// 프로필 저장 (닉네임만 수정 가능)
  Future<void> _saveProfile() async {
    if (_isSaving) return;
    
    setState(() => _isSaving = true);

    try {
      await _userRepository.updateDisplayInfo(
        nickname: _nicknameController.text,
        // profileImageUrl: 이미지 업로드 후 URL 전달 필요 (추후 구현)
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('프로필이 저장되었습니다.')),
        );
        context.pop();
      }
    } catch (e) {
      debugPrint('프로필 저장 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('프로필 저장 중 오류가 발생했습니다.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _nicknameController.removeListener(_onNicknameChanged);
    _nicknameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  /// 닉네임 입력 변경 시 호출
  void _onNicknameChanged() {
    final nickname = _nicknameController.text;

    // 길이 유효성 검사
    if (nickname.isNotEmpty) {
      if (nickname.length < _minNicknameLength) {
        setState(() {
          _nicknameError = '닉네임은 $_minNicknameLength자 이상이어야 합니다.';
        });
        return;
      } else if (nickname.length > _maxNicknameLength) {
        setState(() {
          _nicknameError = '닉네임은 $_maxNicknameLength자 이하여야 합니다.';
        });
        return;
      }
    }

    // 유효한 길이인 경우 에러 초기화
    setState(() {
      _nicknameError = null;
    });
  }

  /// 닉네임 글자수가 유효한지 확인
  bool get _isNicknameLengthValid {
    final length = _nicknameController.text.length;
    return length >= _minNicknameLength && length <= _maxNicknameLength;
  }

  /// 서버에서 닉네임 중복 확인
  Future<void> _checkNicknameDuplicate() async {
    if (!_isNicknameLengthValid) return;

    setState(() {
      _isCheckingNickname = true;
    });

    try {
      // 실제 서버 API 호출
      final isAvailable = await _userRepository.checkNicknameDuplicate(
        _nicknameController.text,
      );

      if (!isAvailable) {
        setState(() {
          _nicknameError = '이미 사용중인 닉네임이에요!';
        });
      } else {
        setState(() {
          _nicknameError = null;
        });
      }
    } catch (e) {
      // 에러 처리
      debugPrint('닉네임 중복 확인 오류: $e');
      setState(() {
        _nicknameError = '닉네임 확인 중 오류가 발생했습니다.';
      });
    } finally {
      setState(() {
        _isCheckingNickname = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '프로필 설정',
      onBack: () => context.pop(),
      bottomNavigationBar: _buildBottomButton(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimens.space24),
            // 프로필 사진 섹션
            ProfilePhotoPicker(
              initialImage: _profileImage,
              onImageChanged: (image) {
                setState(() {
                  _profileImage = image;
                });
              },
            ),
            const SizedBox(height: AppDimens.space32),
            // 닉네임 섹션
            _buildNicknameSection(),
            const SizedBox(height: AppDimens.space32),
            // 키/몸무게 섹션
            _buildBodyInfoSection(),
            const SizedBox(height: AppDimens.space24),
          ],
        ),
      ),
    );
  }

  Widget _buildNicknameSection() {
    final bool hasError = _nicknameError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '닉네임',
          style: AppTextStyles.body16SemiBold.copyWith(
            color: AppColors.textStrong,
          ),
        ),
        const SizedBox(height: AppDimens.space12),
        Focus(
          onFocusChange: (hasFocus) {
            // 포커스를 잃었을 때 서버에서 닉네임 중복 확인
            if (!hasFocus && _isNicknameLengthValid) {
              _checkNicknameDuplicate();
            }
          },
          child: CustomTextField(
            controller: _nicknameController,
            hintText: '닉네임을 입력하세요',
            maxLength: _maxNicknameLength,
            hasError: hasError,
          ),
        ),
        const SizedBox(height: AppDimens.space8),
        // 에러 메시지 표시
        if (hasError)
          Row(
            children: [
              Container(
                width: 4,
                height: 4,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: AppColors.statusDestructive,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                _nicknameError!,
                style: AppTextStyles.body14Regular.copyWith(
                  color: AppColors.statusDestructive,
                ),
              ),
            ],
          )
        else
          Row(
            children: [
              Container(
                width: 4,
                height: 4,
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(
                  color: AppColors.textAssistive,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                '2~14자 이내로 입력해주세요.',
                style: AppTextStyles.body14Regular.copyWith(
                  color: AppColors.textAssistive,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildBodyInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '키/몸무게',
          style: AppTextStyles.body16SemiBold.copyWith(
            color: AppColors.textStrong,
          ),
        ),
        const SizedBox(height: AppDimens.space12),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _heightController,
                suffixText: 'cm',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: AppDimens.space12),
            Expanded(
              child: CustomTextField(
                controller: _weightController,
                suffixText: 'kg',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    // 닉네임이 유효하고 에러가 없으며 확인/저장 중이 아닐 때만 버튼 활성화
    final bool isButtonEnabled =
        _isNicknameLengthValid && _nicknameError == null && !_isCheckingNickname && !_isSaving && !_isLoading;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space16),
        child: SizedBox(
          width: double.infinity,
          height: AppDimens.buttonHeight,
          child: ElevatedButton(
            onPressed: isButtonEnabled ? _saveProfile : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isButtonEnabled ? AppColors.primary : AppColors.interactionDisabled,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: (_isCheckingNickname || _isSaving)
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    '저장하기',
                    style: AppTextStyles.body16SemiBold.copyWith(
                      color: isButtonEnabled ? Colors.white : AppColors.textDisabled,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
