import 'package:flutter/material.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/exercise/exercise_condition_card.dart';
import 'package:go_router/go_router.dart';
/// 운동 설문 4 - 플랭크 시간 설문
class ExerciseSurvey4Screen extends StatefulWidget {
  const ExerciseSurvey4Screen({super.key, this.onComplete});

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
      imagePath: 'assets/images/img_plank_15.png',
      value: 15,
    ),
    ExerciseOption(
      label: '30초 이하',
      imagePath: 'assets/images/img_plank_30.png',
      value: 30,
    ),
    ExerciseOption(
      label: '60초 이하',
      imagePath: 'assets/images/img_plank_60down.png',
      value: 60,
    ),
    ExerciseOption(
      label: '60초 이상',
      imagePath: 'assets/images/img_plank_60up.png',
      value: 61,
    ),
  ];

  void _onPrevPressed() {
    Navigator.of(context).pop();
  }

  void _onNextPressed() {
    if (_selectedValue != null) {
      widget.onComplete?.call();
      // 설문 완료 후 운동 루틴 화면(1일차)으로 이동
      context.go('/exercise/fixed1');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SurveyLayout(
      appBarTitle: '운동 능력 체크',
      stepLabel: '컨디션 체크',
      currentStep: 4,
      totalSteps: 4,
      titleWidget: Text(
        '연속으로 플랭크를\n몇 개까지 할 수 있나요?',
        style: AppTextStyles.body20Bold,
      ),
      bottomButtons: SurveyButtonsConfig(
        nextText: '다음으로',
        onNext: _onNextPressed,
        prevText: '이전으로',
        onPrev: _onPrevPressed,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppDimens.itemSpacing,
          mainAxisSpacing: AppDimens.itemSpacing,
          childAspectRatio: 1.4,
        ),
        itemCount: _options.length,
        itemBuilder: (context, index) {
          final option = _options[index];
          return ExerciseConditionCard(
            label: option.label,
            imagePath: option.imagePath,
            selected: _selectedValue == option.value,
            onTap: () => setState(() => _selectedValue = option.value),
          );
        },
      ),
    );
  }
}
