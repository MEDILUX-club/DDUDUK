import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/widgets/common/selectable_option_card.dart';
import 'package:dduduk_app/providers/exercise_provider.dart';

/// 운동 후 피드백 3단계: 운동 중 땀은 어느정도 났나요?
class ExerciseFeedbackScreen3 extends ConsumerStatefulWidget {
  final Map<String, dynamic>? feedbackData;

  const ExerciseFeedbackScreen3({super.key, this.feedbackData});

  @override
  ConsumerState<ExerciseFeedbackScreen3> createState() =>
      _ExerciseFeedbackScreen3State();
}

class _ExerciseFeedbackScreen3State extends ConsumerState<ExerciseFeedbackScreen3> {
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

  Future<void> _onNext() async {
    if (_selectedOption == null) return;

    final exerciseState = ref.read(exerciseProvider);
    if (exerciseState.isLoading) return;

    // 세 화면의 모든 피드백 데이터 수집
    final selectedText = _options[_selectedOption!];
    final rpeResponse = widget.feedbackData?['rpeResponse'] ?? '';
    final muscleStimulationResponse =
        widget.feedbackData?['muscleStimulationResponse'] ?? '';

    // Provider를 통해 API 호출
    final success = await ref.read(exerciseProvider.notifier).saveWorkoutFeedback(
      rpeResponse: rpeResponse,
      muscleStimulationResponse: muscleStimulationResponse,
      sweatResponse: selectedText,
    );

    if (!mounted) return;

    if (success) {
      // 피드백 완료 - 운동 예약 화면으로 이동
      context.go('/exercise/reservation');
    } else {
      // 에러 처리
      final error = ref.read(exerciseProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? '피드백 저장에 실패했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final exerciseState = ref.watch(exerciseProvider);
    final isSubmitting = exerciseState.isLoading;

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
        nextText: isSubmitting ? '저장 중...' : '다음으로',
        onNext: _onNext,
        isNextEnabled: _selectedOption != null && !isSubmitting,
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
