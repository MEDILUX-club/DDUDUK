import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';

/// 운동 완료 화면
/// 
/// 모든 추천 운동 영상이 끝난 후 표시되며,
/// "다음으로" 버튼 클릭 시 운동 피드백 플로우로 이동합니다.
class ExerciseCompleteScreen extends StatelessWidget {
  const ExerciseCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              // 체크마크 아이콘
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              // 완료 메시지
              Text(
                '운동이 종료되었습니다!',
                style: AppTextStyles.body20Bold.copyWith(
                  color: AppColors.textStrong,
                ),
              ),
              const Spacer(),
              // 다음으로 버튼
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: BaseButton(
                  text: '다음으로',
                  onPressed: () {
                    // 운동 피드백 플로우로 이동
                    context.go('/exercise/feedback1');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
