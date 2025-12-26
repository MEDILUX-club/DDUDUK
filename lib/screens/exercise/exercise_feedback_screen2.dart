import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/widgets/common/selectable_option_card.dart';

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
    return SurveyLayout(
      appBarTitle: '운동 만족도',
      stepLabel: '자가평가',
      currentStep: 2,
      totalSteps: 3,
      titleWidget: Text(
        '2. 오늘 내 근육은 어떻게 느꼈나요?',
        style: AppTextStyles.body20Bold,
      ),
      bottomButtons: SurveyButtonsConfig(
        prevText: '이전으로',
        onPrev: _onPrevious,
        nextText: '다음으로',
        onNext: _onNext,
        isNextEnabled: _selectedOption != null,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: _options.asMap().entries.map((entry) {
            final index = entry.key;
            final text = entry.value;
            return Padding(
              padding: const EdgeInsets.only(
                bottom: AppDimens.space12,
              ),
                child: SelectableOptionCard(
                leading: Text(
                  '${index + 1}.',
                  style: AppTextStyles.body14Medium.copyWith(
                    color: AppColors.textNormal,
                  ),
                ),
                text: text,
                selected: _selectedOption == index,
                onTap: () => _onOptionSelected(index),
              ),     );
          }).toList(),
        ),
      ),
    );
  }
}
