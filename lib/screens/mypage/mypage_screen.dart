import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dduduk_app/layouts/home_layout.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 마이페이지 화면
class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  final int _currentNavIndex = 2; // 마이페이지 탭 선택

  void _onNavTap(int index) {
    if (index == _currentNavIndex) return;

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/exercise/main');
        break;
      case 2:
        context.go('/mypage');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomeLayout(
      title: '마이페이지',
      currentNavIndex: _currentNavIndex,
      onNavTap: _onNavTap,
      child: Column(
        children: [
          const SizedBox(height: AppDimens.space16),
          // 프로필 카드
          const _ProfileCard(
            userName: 'johnDoe',
            recoveryPercent: 70,
            conditionType: '무릎 과사용성 유형',
          ),
          const SizedBox(height: AppDimens.space16),
          // 메뉴 항목들
          _MenuItemCard(
            icon: Icons.schedule_outlined,
            title: '다음 운동 일정 변경',
            onTap: () {
              // TODO: 운동 일정 변경 화면으로 이동
            },
          ),
          const SizedBox(height: AppDimens.space12),
          _MenuItemCard(
            icon: Icons.description_outlined,
            title: '셀프 설문 응답 확인',
            onTap: () {
              // TODO: 셀프 설문 응답 확인 화면으로 이동
            },
          ),
          const SizedBox(height: AppDimens.space12),
          _MenuItemCard(
            svgIconPath: 'assets/icons/ic_profile.svg',
            title: '운동 부위 변경하기',
            onTap: () {
              // TODO: 운동 부위 변경 화면으로 이동
            },
          ),
          const SizedBox(height: AppDimens.space24),
        ],
      ),
    );
  }
}

/// 프로필 카드 위젯
class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.userName,
    required this.recoveryPercent,
    required this.conditionType,
  });

  final String userName;
  final int recoveryPercent;
  final String conditionType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.space20),
      decoration: BoxDecoration(
        color: AppColors.fillBoxDefault,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // 프로필 이미지
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.linePrimary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              size: 40,
              color: AppColors.textDisabled,
            ),
          ),
          const SizedBox(width: AppDimens.space16),
          // 사용자 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 이름 + 편집 버튼
                Row(
                  children: [
                    Text(
                      '$userName님',
                      style: AppTextStyles.body20SemiBold.copyWith(
                        color: AppColors.textStrong,
                      ),
                    ),
                    const SizedBox(width: AppDimens.space8),
                    GestureDetector(
                      onTap: () {
                        context.push('/mypage/profile-edit');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: SvgPicture.asset(
                          'assets/icons/ic_pencil.svg',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.space8),
                // 상태 배지
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.space12,
                    vertical: AppDimens.space6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$recoveryPercent% $conditionType',
                    style: AppTextStyles.body14Medium.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 메뉴 항목 카드 위젯
class _MenuItemCard extends StatelessWidget {
  const _MenuItemCard({
    this.icon,
    this.svgIconPath,
    required this.title,
    required this.onTap,
  }) : assert(
         icon != null || svgIconPath != null,
         'icon 또는 svgIconPath 중 하나는 필수입니다',
       );

  final IconData? icon;
  final String? svgIconPath;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.space16,
          vertical: AppDimens.space20,
        ),
        decoration: BoxDecoration(
          color: AppColors.fillBoxDefault,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // 아이콘
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.fillDefault,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: svgIconPath != null
                    ? SvgPicture.asset(
                        svgIconPath!,
                        width: 22,
                        height: 22,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primary,
                          BlendMode.srcIn,
                        ),
                      )
                    : Icon(icon, size: 22, color: AppColors.primary),
              ),
            ),
            const SizedBox(width: AppDimens.space12),
            // 제목
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body16Medium.copyWith(
                  color: AppColors.textStrong,
                ),
              ),
            ),
            // 화살표
            const Icon(
              Icons.chevron_right,
              size: 24,
              color: AppColors.textAssistive,
            ),
          ],
        ),
      ),
    );
  }
}
