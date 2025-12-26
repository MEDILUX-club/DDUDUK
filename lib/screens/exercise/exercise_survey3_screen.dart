import 'package:flutter/material.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/exercise/exercise_condition_card.dart';
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
    return SurveyLayout(
      appBarTitle: '운동 능력 체크',
      stepLabel: '컨디션 체크',
      currentStep: 3,
      totalSteps: 4,
      titleWidget: Text(
        '연속으로 계단을\n몇 개까지 오를 수 있나요?',
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
