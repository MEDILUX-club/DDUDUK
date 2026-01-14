import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/widgets/common/selectable_option_card.dart';

/// 운동 후 피드백 3단계: 운동 중 땀은 어느정도 났나요?
class ExerciseFeedbackScreen3 extends StatefulWidget {
  const ExerciseFeedbackScreen3({super.key});

  @override
  State<ExerciseFeedbackScreen3> createState() =>
      _ExerciseFeedbackScreen3State();
}

class _ExerciseFeedbackScreen3State extends State<ExerciseFeedbackScreen3> {
  int? _selectedOption;

  final List<String> _options = [
    '안 났어요',
    '약간 났어요',
    '땀이 흐르는 정도에요',
    '땀이 흠뻑 젖을 정도에요',
  ];

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
      // 피드백 완료 - 운동 예약 화면으로 이동
      context.go('/exercise/reservation');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SurveyLayout(
      appBarTitle: '운동 만족도',
      stepLabel: '자가평가',
      currentStep: 3,
      totalSteps: 3,
      titleWidget: Text(
        '3. 운동 중 땀은 어느정도 났나요?',
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
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
