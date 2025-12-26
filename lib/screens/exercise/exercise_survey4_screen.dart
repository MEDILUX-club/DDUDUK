import 'package:flutter/material.dart';
import 'package:dduduk_app/layouts/default_layout.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';
import 'package:dduduk_app/widgets/common/step_badge.dart';
import 'package:dduduk_app/widgets/common/step_progress_bar.dart';
import 'package:dduduk_app/widgets/exercise/exercise_option_card.dart';

/// 운동 설문 4 - 플랭크 시간 설문
class ExerciseSurvey4Screen extends StatefulWidget {
  const ExerciseSurvey4Screen({
    super.key,
    this.onComplete,
  });

  /// 설문 완료 시 콜백
  final VoidCallback? onComplete;

  @override
  State<ExerciseSurvey4Screen> createState() => _ExerciseSurvey4ScreenState();
}

class _ExerciseSurvey4ScreenState extends State<ExerciseSurvey4Screen> {
  int? _selectedValue;

  static const List<ExerciseOption> _options = [
    ExerciseOption(
      label: '15초 이하',
      imagePath: 'assets/icons/ic_plank_15.svg',
      value: 15,
    ),
    ExerciseOption(
      label: '30초 이하',
      imagePath: 'assets/icons/ic_plank_30.svg',
      value: 30,
    ),
    ExerciseOption(
      label: '60초 이하',
      imagePath: 'assets/icons/ic_plank_60down.svg',
      value: 60,
    ),
    ExerciseOption(
      label: '60초 이상',
      imagePath: 'assets/icons/ic_plank_60up.svg',
      value: 61,
    ),
  ];

  void _onPrevPressed() {
    Navigator.of(context).pop();
  }

  void _onNextPressed() {
    if (_selectedValue != null) {
      widget.onComplete?.call();
      // 설문 완료 후 처리 (예: 홈으로 이동 또는 결과 화면으로 이동)
      Navigator.of(context).popUntil((route) => route.isFirst);
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
            currentStep: 4,
            totalSteps: 4,
            horizontalBleed: AppDimens.screenPadding,
          ),
          const SizedBox(height: AppDimens.space24),

          // 스텝 배지
          const StepBadge(label: '컨디션 체크'),
          const SizedBox(height: AppDimens.space12),

          // 타이틀
          Text(
            '연속으로 플랭크를\n몇 개까지 할 수 있나요?',
            style: AppTextStyles.titleHeader,
          ),
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
                child: BaseButton(
                  text: '다음으로',
                  onPressed: _onNextPressed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
