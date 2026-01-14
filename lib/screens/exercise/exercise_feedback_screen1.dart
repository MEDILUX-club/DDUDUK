import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/widgets/common/selectable_option_card.dart';

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
    {'imagePath': 'assets/images/img_face_0.png', 'text': '아직 여유가 있어요'},
    {'imagePath': 'assets/images/img_face_2.png', 'text': '딱 좋아요'},
    {'imagePath': 'assets/images/img_face_6.png', 'text': '조금 지쳤어요'},
    {'imagePath': 'assets/images/img_face_10.png', 'text': '완전 힘들어요'},
  ];

  void _onOptionSelected(int index) {
    setState(() {
      _selectedOption = index;
    });
  }

  void _onNext() {
    if (_selectedOption != null) {
      // 선택한 옵션의 텍스트를 다음 화면으로 전달
      final selectedText = _options[_selectedOption!]['text']!;
      context.push('/exercise/feedback-2', extra: {
        'rpeResponse': selectedText,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SurveyLayout(
      appBarTitle: '운동 만족도',
      stepLabel: '자가평가',
      currentStep: 1,
      totalSteps: 3,
      titleWidget: Text(
        '1. 운동 끝난 후 몸은 어떤가요?',
        style: AppTextStyles.body20Bold,
      ),
      bottomButtons: SurveyButtonsConfig(
        nextText: '다음으로',
        onNext: _onNext,
        isNextEnabled: _selectedOption != null,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: _options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            return Padding(
              padding: const EdgeInsets.only(
                bottom: AppDimens.space12,
              ),
              child: SelectableOptionCard(
                leading: Image.asset(
                  option['imagePath']!,
                  width: 16,
                  height: 16,
                  fit: BoxFit.contain,
                ),
                text: option['text']!,
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


