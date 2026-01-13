import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/layouts/home_layout.dart';
import 'package:dduduk_app/widgets/exercise/exercise_start_card.dart';
import 'package:dduduk_app/services/token_service.dart';
import 'package:go_router/go_router.dart';

/// 운동 메인 화면 (빈 상태)
class ExerciseMainEmptyScreen extends StatefulWidget {
  const ExerciseMainEmptyScreen({super.key});

  @override
  State<ExerciseMainEmptyScreen> createState() =>
      _ExerciseMainEmptyScreenState();
}

class _ExerciseMainEmptyScreenState extends State<ExerciseMainEmptyScreen> {
  int _currentNavIndex = 1; // 운동 탭 선택됨
  final String _userName = '황두현님'; // 사용자 이름 (추후 API 연동 시 변경)

  void _onNavTap(int index) {
    if (index == _currentNavIndex) return;

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        // 이미 운동 탭에 있으므로 유지
        break;
      case 2:
        context.go('/mypage');
        break;
    }
  }

  void _onStartExercise() async {
    // 운동을 시작했으므로 플래그 설정 (다음 로그인부터 exercise_main_screen 표시)
    await TokenService.instance.setHasStartedExercise(true);
    if (mounted) {
      // 컨디션 체크 화면으로 이동 (여기서 신규/기존 유저 분기)
      context.push('/exercise/fixed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomeLayout(
      title: '운동하기',
      currentNavIndex: _currentNavIndex,
      onNavTap: _onNavTap,
      child: Column(
        children: [
          // 상단 그린 카드
          ExerciseStartCard(
            userName: _userName,
            onStartPressed: _onStartExercise,
          ),
          const SizedBox(height: AppDimens.space24),

          // 빈 상태 메시지
          _buildEmptyState(),
        ],
      ),
    );
  }



  Widget _buildEmptyState() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 블러 처리된 배경 콘텐츠
        _buildBlurredContent(),
        // 중앙 오버레이 메시지
        _buildOverlayMessage(),
      ],
    );
  }

  Widget _buildBlurredContent() {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Opacity(
        opacity: 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이번 주 진행 상황 (블러됨)
            Row(
              children: [
                const Icon(
                  Icons.auto_graph,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '이번 주 진행 상황',
                  style: AppTextStyles.body18SemiBold.copyWith(
                    color: AppColors.textStrong,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.space12),
            Row(
              children: [
                Expanded(child: _buildPlaceholderCard('운동 횟수', '0회')),
                const SizedBox(width: AppDimens.itemSpacing),
                Expanded(child: _buildPlaceholderCard('총 시간', '0분')),
              ],
            ),
            const SizedBox(height: AppDimens.space24),

            // 다음 운동 루틴 (블러됨)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.fitness_center,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '다음 운동 루틴',
                      style: AppTextStyles.body18SemiBold.copyWith(
                        color: AppColors.textStrong,
                      ),
                    ),
                  ],
                ),
                Text(
                  '전체보기',
                  style: AppTextStyles.body14Regular.copyWith(
                    color: AppColors.textAssistive,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.space12),
            _buildPlaceholderExerciseCard(),
            const SizedBox(height: AppDimens.space8),
            _buildPlaceholderExerciseCard(),
            const SizedBox(height: AppDimens.space8),
            _buildPlaceholderExerciseCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.space16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lineNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.body12Regular.copyWith(
              color: AppColors.textAssistive,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.titleHeader.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textStrong,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                width: 60,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.lineNeutral,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderExerciseCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimens.space16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lineNeutral),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.fillDefault,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: AppDimens.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.lineNeutral,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 120,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.lineNeutral,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayMessage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 경고 아이콘
        SvgPicture.asset('assets/icons/ic_warning.svg', width: 48, height: 48),
        const SizedBox(height: AppDimens.space16),
        Text(
          '오늘 첫 운동을 시작해볼까요?',
          style: AppTextStyles.body18SemiBold.copyWith(
            color: AppColors.textStrong,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimens.space8),
        Text(
          '운동을 시작하고',
          style: AppTextStyles.body14Regular.copyWith(
            color: AppColors.textAssistive,
          ),
        ),
        Text(
          '나만의건강한 루틴을 만들어보아요',
          style: AppTextStyles.body14Regular.copyWith(
            color: AppColors.textAssistive,
          ),
        ),
      ],
    );
  }
}
