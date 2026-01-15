import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/widgets/survey/pain_level_face.dart';
import 'package:dduduk_app/providers/daily_pain_provider.dart';
import 'package:dduduk_app/repositories/exercise_ability_repository.dart';

/// 운동 전 통증 정도 설문 화면 (고정 설문)
///
/// 신규 유저와 기존 유저 모두 "시작하기" 버튼을 누르면 이 화면으로 옵니다.
/// - 신규 유저 (exercise-ability 미완료): → survey1→2→3→4 → fixed1
/// - 기존 유저 (exercise-ability 완료): → fixed1 (survey 스킵)
class ExerciseSurveyFixedScreen extends ConsumerStatefulWidget {
  const ExerciseSurveyFixedScreen({super.key, this.onComplete});

  /// 설문 완료 시 콜백 (통증 레벨 전달)
  final void Function(double painLevel)? onComplete;

  @override
  ConsumerState<ExerciseSurveyFixedScreen> createState() =>
      _ExerciseSurveyFixedScreenState();
}

class _ExerciseSurveyFixedScreenState extends ConsumerState<ExerciseSurveyFixedScreen> {
  double _painLevel = 10;
  final ExerciseAbilityRepository _exerciseAbilityRepository = ExerciseAbilityRepository();

  /// 오늘 날짜를 YYYY-MM-DD 형식으로 반환
  String _getTodayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> _onNextPressed() async {
    final dailyPainState = ref.read(dailyPainProvider);
    if (dailyPainState.isLoading) return;

    widget.onComplete?.call(_painLevel);

    // 1. Provider를 통해 daily-pain API 호출 (통증 정도 저장)
    final success = await ref.read(dailyPainProvider.notifier).recordDailyPain(
      recordDate: _getTodayDateString(),
      painLevel: _painLevel.round(),
    );

    if (!mounted) return;

    if (!success) {
      final error = ref.read(dailyPainProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? '저장 중 오류가 발생했습니다.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 2. exercise-ability 완료 여부 확인
    try {
      final exerciseAbility = await _exerciseAbilityRepository.getExerciseAbility();

      if (!mounted) return;

      if (exerciseAbility != null) {
        // 기존 유저: 운동 능력 평가 완료 → survey 스킵하고 바로 fixed1로 이동
        context.push('/exercise/fixed1');
      } else {
        // 신규 유저: 운동 능력 평가 미완료 → survey1부터 시작
        context.push('/exercise/survey1');
      }
    } catch (e) {
      debugPrint('오류 발생: $e');
      if (!mounted) return;

      // 에러 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('저장 중 오류가 발생했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dailyPainState = ref.watch(dailyPainProvider);
    final isLoading = dailyPainState.isLoading;

    return SurveyLayout(
      appBarTitle: '컨디션 체크',
      showProgressBar: false,
      title: '운동 전 현재 통증의 정도를 알려주세요',
      description: '정확한 운동 프로그램을 위해 필요한 정보예요',
      stepLabel: '통증 세부 정보',
      currentStep: 1,
      totalSteps: 1,
      bottomButtons: SurveyButtonsConfig(
        nextText: isLoading ? '저장 중...' : '다음으로',
        onNext: isLoading ? null : _onNextPressed,
      ),
      child: SingleChildScrollView(
        child: PainLevelSelector(
          value: _painLevel,
          onChanged: (value) => setState(() => _painLevel = value as double),
        ),
      ),
    );
  }
}
