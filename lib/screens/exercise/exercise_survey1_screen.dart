import 'package:flutter/material.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/exercise/exercise_condition_card.dart';
import 'package:go_router/go_router.dart';

/// 운동 설문 1 - 스쿼트 개수 설문
class ExerciseSurvey1Screen extends StatefulWidget {
  const ExerciseSurvey1Screen({super.key});

  @override
  State<ExerciseSurvey1Screen> createState() => _ExerciseSurvey1ScreenState();
}

class _ExerciseSurvey1ScreenState extends State<ExerciseSurvey1Screen> {
  int? _selectedValue;

  static const List<ExerciseOption> _options = [
    ExerciseOption(
      label: '5개 이하',
      imagePath: 'assets/images/img_squat_5.png',
      value: 5,
    ),
    ExerciseOption(
      label: '10개 이하',
      imagePath: 'assets/images/img_squat_10.png',
      value: 10,
    ),
    ExerciseOption(
      label: '15개 이하',
      imagePath: 'assets/images/img_squat_15.png',
      value: 15,
    ),
    ExerciseOption(
      label: '20개 이하',
      imagePath: 'assets/images/img_squat_20.png',
      value: 20,
    ),
  ];

  void _onPrevPressed() {
    Navigator.of(context).pop();
  }

  void _onNextPressed() {
    if (_selectedValue != null) {
      context.push('/exercise/survey2');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SurveyLayout(
      appBarTitle: '운동 능력 체크',
      stepLabel: '컨디션 체크',
      currentStep: 1,
      totalSteps: 4,
      titleWidget: Text(
        '연속으로 스쿼트를\n몇 개까지 할 수 있나요?',
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
