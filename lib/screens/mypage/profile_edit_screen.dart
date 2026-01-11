import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dduduk_app/layouts/default_layout.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/common/custom_text_field.dart';
import 'package:dduduk_app/widgets/mypage/profile_photo_picker.dart';

/// 프로필 설정 화면
class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _nicknameController = TextEditingController(text: 'johnDoe');
  final _heightController = TextEditingController(text: '160');
  final _weightController = TextEditingController(text: '160');

  File? _profileImage;

  @override
  void dispose() {
    _nicknameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
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
        CustomTextField(
          controller: _nicknameController,
          hintText: '닉네임을 입력하세요',
        ),
        const SizedBox(height: AppDimens.space8),
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space16),
        child: SizedBox(
          width: double.infinity,
          height: AppDimens.buttonHeight,
          child: ElevatedButton(
            onPressed: () {
              // TODO: 저장 로직
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              '다음으로',
              style: AppTextStyles.body16SemiBold.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
