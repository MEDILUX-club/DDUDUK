import 'package:flutter/material.dart';
import 'package:dduduk_app/layouts/default_layout.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';
import 'package:dduduk_app/widgets/common/step_badge.dart';
import 'package:dduduk_app/widgets/common/step_progress_bar.dart';
import 'package:dduduk_app/widgets/exercise/exercise_option_card.dart';
import 'package:go_router/go_router.dart';

/// 운동 설문 3 - 계단 오르기 층수 설문
class ExerciseSurvey3Screen extends StatefulWidget {
  const ExerciseSurvey3Screen({super.key});

  @override
  State<ExerciseSurvey3Screen> createState() => _ExerciseSurvey3ScreenState();
}

class _ExerciseSurvey3ScreenState extends State<ExerciseSurvey3Screen> {
  int? _selectedValue;

  static const List<ExerciseOption> _options = [
    ExerciseOption(
      label: '1층 이하',
      imagePath: 'assets/images/img_stair_1.png',
      value: 1,
    ),
    ExerciseOption(
      label: '3층 이하',
      imagePath: 'assets/images/img_stair_3.png',
      value: 3,
    ),
    ExerciseOption(
      label: '4층 이하',
      imagePath: 'assets/images/img_stair_4.png',
      value: 4,
    ),
    ExerciseOption(
      label: '5층 이하',
      imagePath: 'assets/images/img_stair_5.png',
      value: 5,
    ),
  ];

  void _onPrevPressed() {
    Navigator.of(context).pop();
  }

  void _onNextPressed() {
    if (_selectedValue != null) {
      context.push('/exercise/survey4');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '사전 설문',
      bottomNavigationBar: _buildBottomButtons(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로그레스 바
          StepProgressBar(
            currentStep: 3,
            totalSteps: 4,
            horizontalBleed: AppDimens.screenPadding,
          ),
          const SizedBox(height: AppDimens.space24),

          // 스텝 배지
          const StepBadge(label: '컨디션 체크'),
          const SizedBox(height: AppDimens.space12),

          // 타이틀
          Text('연속으로 계단을\n몇 개까지 오를 수 있나요?', style: AppTextStyles.titleHeader),
          const SizedBox(height: AppDimens.space24),

          // 옵션 그리드
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppDimens.itemSpacing,
                mainAxisSpacing: AppDimens.itemSpacing,
                childAspectRatio: 1.0,
              ),
              itemCount: _options.length,
              itemBuilder: (context, index) {
                final option = _options[index];
                return ExerciseOptionCard(
                  label: option.label,
                  imagePath: option.imagePath,
                  selected: _selectedValue == option.value,
                  onTap: () => setState(() => _selectedValue = option.value),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.screenPadding,
          AppDimens.space12,
          AppDimens.screenPadding,
          AppDimens.space16,
        ),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: AppDimens.buttonHeight,
                child: OutlinedButton(
                  onPressed: _onPrevPressed,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.linePrimary),
                    backgroundColor: AppColors.fillBoxDefault,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    foregroundColor: AppColors.textNormal,
                  ),
                  child: Text('이전으로', style: AppTextStyles.body14Medium),
                ),
              ),
            ),
            const SizedBox(width: AppDimens.itemSpacing),
            Expanded(
              child: SizedBox(
                height: AppDimens.buttonHeight,
                child: BaseButton(text: '다음으로', onPressed: _onNextPressed),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
