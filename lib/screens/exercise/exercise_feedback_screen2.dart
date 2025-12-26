import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/common/header_bar.dart';
import 'package:dduduk_app/widgets/common/step_badge.dart';
import 'package:dduduk_app/widgets/common/step_progress_bar.dart';
import 'package:dduduk_app/widgets/buttons/button_group.dart';

/// 운동 후 피드백 2단계: 오늘 내 근육은 어떻게 느꼈나요?
class ExerciseFeedbackScreen2 extends StatefulWidget {
  const ExerciseFeedbackScreen2({super.key});

  @override
  State<ExerciseFeedbackScreen2> createState() =>
      _ExerciseFeedbackScreen2State();
}

class _ExerciseFeedbackScreen2State extends State<ExerciseFeedbackScreen2> {
  int? _selectedOption;

  final List<String> _options = ['아무 느낌이 없어요', '뻐근한 정도에요', '타는 듯한 느낌을 받았어요'];

  void _onOptionSelected(int index) {
    setState(() {
      _selectedOption = index;
    });
  }

  void _onPrevious() {
    context.pop();
  }

  void _onNext() {
    if (_selectedOption != null) {
      context.push('/exercise/feedback-3');
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
              currentStep: 2,
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
                      '2. 오늘 내 근육은 어떻게 느꼈나요?',
                      style: AppTextStyles.titleText1.copyWith(
                        color: AppColors.textNormal,
                      ),
                    ),

                    const SizedBox(height: AppDimens.space24),

                    // Options
                    ..._options.asMap().entries.map((entry) {
                      final index = entry.key;
                      final text = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimens.space12,
                        ),
                        child: _NumberedOptionCard(
                          number: index + 1,
                          text: text,
                          isSelected: _selectedOption == index,
                          onTap: () => _onOptionSelected(index),
                        ),
                      );
                    }),

                    const Spacer(),

                    // Navigation buttons
                    ButtonGroup(
                      subText: '이전으로',
                      mainText: '다음으로',
                      onSubPressed: _onPrevious,
                      onMainPressed: _onNext,
                      isMainEnabled: _selectedOption != null,
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

/// 번호와 텍스트가 있는 옵션 카드
class _NumberedOptionCard extends StatelessWidget {
  const _NumberedOptionCard({
    required this.number,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final int number;
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
            Text(
              '$number.',
              style: AppTextStyles.body14Medium.copyWith(
                color: AppColors.textNormal,
              ),
            ),
            const SizedBox(width: AppDimens.space8),
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
