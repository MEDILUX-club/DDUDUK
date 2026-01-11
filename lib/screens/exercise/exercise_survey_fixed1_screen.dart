import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/exercise/exercise_routine_card.dart';

/// 운동 루틴 목록 화면 (exercise_fixed_screen 다음 화면)
///
/// 오늘의 운동 루틴을 보여주고 시작하기 버튼을 제공합니다.
class ExerciseFixed1Screen extends StatelessWidget {
  const ExerciseFixed1Screen({
    super.key,
    this.dayNumber = 1,
    this.exercises = const [],
    this.onStartPressed,
  });

  /// 운동 일차 (1일차, 2일차 등)
  final int dayNumber;

  /// 운동 목록
  final List<ExerciseRoutineData> exercises;

  /// 시작하기 버튼 클릭 콜백
  final VoidCallback? onStartPressed;

  @override
  Widget build(BuildContext context) {
    // 기본 테스트 데이터
    final displayExercises = exercises.isNotEmpty
        ? exercises
        : [
            const ExerciseRoutineData(
              name: '스쿼트',
              sets: 3,
              reps: 10,
              difficulty: 2,
            ),
            const ExerciseRoutineData(
              name: '스쿼트',
              sets: 3,
              reps: 10,
              difficulty: 4,
            ),
            const ExerciseRoutineData(
              name: '스쿼트',
              sets: 3,
              reps: 10,
              difficulty: 3,
            ),
            const ExerciseRoutineData(
              name: '스쿼트',
              sets: 3,
              reps: 10,
              difficulty: 2,
            ),
          ];

    return SurveyLayout(
      appBarTitle: '',
      titleWidget: RichText(
        text: TextSpan(
          style: AppTextStyles.body20Bold.copyWith(
            color: AppColors.textStrong,
          ),
          children: [
            const TextSpan(text: '오늘은 운동 '),
            TextSpan(
              text: '$dayNumber일차',
              style: AppTextStyles.body20Bold.copyWith(
                color: AppColors.primary,
              ),
            ),
            const TextSpan(text: '예요'),
          ],
        ),
      ),
      description: '오늘도 힘차게 시작해보아요!',
      showProgressBar: false,
      bottomButtons: SurveyButtonsConfig(
        nextText: '시작하기',
        onNext: onStartPressed ??
            () {
              // exercise_play 화면으로 이동
              context.push('/exercise/play');
            },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 오늘 운동 루틴 라벨
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: IconLabel(
              icon: Icons.access_time,
              text: '오늘 운동 루틴',
            ),
          ),
          // 운동 목록
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: displayExercises.length,
              itemBuilder: (context, index) {
                return ExerciseRoutineCard(
                  exercise: displayExercises[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
