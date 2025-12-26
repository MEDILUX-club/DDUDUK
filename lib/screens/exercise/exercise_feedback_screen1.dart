import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/common/header_bar.dart';
import 'package:dduduk_app/widgets/common/step_badge.dart';
import 'package:dduduk_app/widgets/common/step_progress_bar.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';

/// 운동 후 피드백 1단계: 운동 끝난 후 몸은 어떤가요?
class ExerciseFeedbackScreen1 extends StatefulWidget {
  const ExerciseFeedbackScreen1({super.key});

  @override
  State<ExerciseFeedbackScreen1> createState() =>
      _ExerciseFeedbackScreen1State();
}

class _ExerciseFeedbackScreen1State extends State<ExerciseFeedbackScreen1> {
  int? _selectedOption;

  final List<Map<String, String>> _options = [
    {'emoji': '😀', 'text': '아직 여유가 있어요'},
    {'emoji': '🙂', 'text': '딱 좋아요'},
    {'emoji': '😓', 'text': '조금 지쳤어요'},
    {'emoji': '😰', 'text': '완전 힘들어요'},
  ];

  void _onOptionSelected(int index) {
    setState(() {
      _selectedOption = index;
    });
  }

  void _onNext() {
    if (_selectedOption != null) {
      context.push('/exercise/feedback-2');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fillDefault,
      appBar: const HeaderBar(title: '사후 설문'),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            const StepProgressBar(
              currentStep: 1,
              totalSteps: 3,
              horizontalBleed: AppDimens.space20,
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.space20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppDimens.space16),

                    // Step badge
                    const StepBadge(label: '자가평가'),

                    const SizedBox(height: AppDimens.space16),

                    // Question text
                    Text(
                      '1. 운동 끝난 후 몸은 어떤가요?',
                      style: AppTextStyles.titleText1.copyWith(
                        color: AppColors.textNormal,
                      ),
                    ),

                    const SizedBox(height: AppDimens.space24),

                    // Options
                    ..._options.asMap().entries.map((entry) {
                      final index = entry.key;
                      final option = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimens.space12,
                        ),
                        child: _FeedbackOptionCard(
                          emoji: option['emoji']!,
                          text: option['text']!,
                          isSelected: _selectedOption == index,
                          onTap: () => _onOptionSelected(index),
                        ),
                      );
                    }),

                    const Spacer(),

                    // Next button
                    BaseButton(
                      text: '다음으로',
                      onPressed: _onNext,
                      isEnabled: _selectedOption != null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 이모지와 텍스트가 있는 피드백 옵션 카드
class _FeedbackOptionCard extends StatelessWidget {
  const _FeedbackOptionCard({
    required this.emoji,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String emoji;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isSelected
        ? AppColors.primary
        : AppColors.lineNeutral;
    final Color backgroundColor = isSelected
        ? AppColors.primaryLight
        : AppColors.fillBoxDefault;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimens.space14,
          horizontal: AppDimens.space16,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: AppDimens.space12),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.body14Medium.copyWith(
                  color: AppColors.textNormal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
