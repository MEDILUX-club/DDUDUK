import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/exercise/exercise_condition_card.dart';
import 'package:dduduk_app/providers/exercise_ability_provider.dart';
import 'package:go_router/go_router.dart';

/// 운동 설문 4 - 플랭크 시간 설문
class ExerciseSurvey4Screen extends ConsumerStatefulWidget {
  const ExerciseSurvey4Screen({super.key, this.onComplete});

  /// 설문 완료 시 콜백
  final VoidCallback? onComplete;

  @override
  ConsumerState<ExerciseSurvey4Screen> createState() => _ExerciseSurvey4ScreenState();
}

class _ExerciseSurvey4ScreenState extends ConsumerState<ExerciseSurvey4Screen> {
  int? _selectedValue;
  bool _isSubmitting = false;

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

  Future<void> _onNextPressed() async {
    if (_selectedValue == null || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      // Provider에 플랭크 응답 저장
      ref.read(exerciseAbilityProvider.notifier).updatePlankResponse(
        _getResponseLabel(_selectedValue!),
      );

      // API 제출
      final success = await ref.read(exerciseAbilityProvider.notifier).submitExerciseAbility();

      if (!mounted) return;

      if (success) {
        widget.onComplete?.call();
        // 설문 완료 후 운동 루틴 화면(1일차)으로 이동
        context.go('/exercise/fixed1');
      } else {
        // 에러 표시
        final error = ref.read(exerciseAbilityProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? '제출 중 오류가 발생했습니다.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  /// 선택된 값의 라벨 반환
  String _getResponseLabel(int value) {
    final option = _options.firstWhere((o) => o.value == value);
    return option.label;
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
        nextText: _isSubmitting ? '제출 중...' : '다음으로',
        onNext: _isSubmitting ? null : _onNextPressed,
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
            onTap: () {
              if (!_isSubmitting) {
                setState(() => _selectedValue = option.value);
              }
            },
          );
        },
      ),
    );
  }
}
