import 'package:flutter/material.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';

/// 메인 화면 상단 "시작하기" 카드 위젯
///
/// 날짜, 사용자 이름, 운동 시작 권유 텍스트, 아령 아이콘, 시작하기 버튼을 포함합니다.
class ExerciseStartCard extends StatelessWidget {
  const ExerciseStartCard({
    super.key,
    required this.onStartPressed,
    required this.userName,
  });

  /// 시작하기 버튼 콜백
  final VoidCallback onStartPressed;

  /// 사용자 이름
  final String userName;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dateString =
        '${today.year}.${today.month.toString().padLeft(2, '0')}.${today.day.toString().padLeft(2, '0')}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.space20),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 날짜
          Text(
            dateString,
            style: AppTextStyles.body14Medium.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppDimens.space8),
          // 이름 + 질문 텍스트 + 아이콘
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: AppTextStyles.body20Bold.copyWith(
                        color: AppColors.textStrong,
                      ),
                    ),
                    Text(
                      '오늘 운동 시작해볼까요?',
                      style: AppTextStyles.body20Bold.copyWith(
                        color: AppColors.textStrong,
                      ),
                    ),
                  ],
                ),
              ),
              // 아령 아이콘 (두 줄 높이에 맞춤)
              const Icon(
                Icons.fitness_center,
                size: 56,
                color: AppColors.primarySecondary,
              ),
            ],
          ),
          const SizedBox(height: AppDimens.space16),
          // 시작하기 버튼 (가로 100%)
          SizedBox(
            width: double.infinity,
            height: AppDimens.buttonHeight,
            child: ElevatedButton(
              onPressed: onStartPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '시작하기',
                    style: AppTextStyles.body16Regular.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
