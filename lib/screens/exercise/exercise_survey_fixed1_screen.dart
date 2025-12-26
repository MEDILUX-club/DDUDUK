import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';

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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AppBar
            _buildAppBar(context),

            // 헤더 섹션
            _buildHeader(),

            // 오늘 운동 루틴 라벨
            _buildRoutineLabel(),

            // 운동 목록
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: displayExercises.length,
                itemBuilder: (context, index) {
                  return _ExerciseRoutineCard(
                    exercise: displayExercises[index],
                  );
                },
              ),
            ),

            // 시작하기 버튼
            _buildStartButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            color: AppColors.textNormal,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 오늘은 운동 N일차예요
          RichText(
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
          const SizedBox(height: 4),
          // 부제목
          Text(
            '오늘도 힘차게 시작해보아요!',
            style: AppTextStyles.body14Regular.copyWith(
              color: AppColors.textNeutral,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/ic_clock.svg',
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              AppColors.textNeutral,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '오늘 운동 루틴',
            style: AppTextStyles.body14Medium.copyWith(
              color: AppColors.textNeutral,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: SizedBox(
          height: 52,
          child: BaseButton(
            text: '시작하기',
            onPressed:
                onStartPressed ??
                () {
                  // 기본: exercise_rest 화면으로 이동
                  context.push('/exercise/rest');
                },
          ),
        ),
      ),
    );
  }
}

/// 운동 루틴 카드 위젯
class _ExerciseRoutineCard extends StatelessWidget {
  const _ExerciseRoutineCard({required this.exercise});

  final ExerciseRoutineData exercise;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lineNeutral),
      ),
      child: Row(
        children: [
          // 운동 이미지 플레이스홀더
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.fillDefault,
              borderRadius: BorderRadius.circular(8),
            ),
            child: exercise.imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(exercise.imagePath!, fit: BoxFit.cover),
                  )
                : Center(
                    child: Icon(
                      Icons.fitness_center,
                      size: 28,
                      color: AppColors.textAssistive,
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          // 운동 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 운동 이름 + 난이도
                Row(
                  children: [
                    Text(
                      exercise.name,
                      style: AppTextStyles.body16Regular.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textStrong,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 난이도 라벨
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '난이도',
                            style: AppTextStyles.body12Regular.copyWith(
                              color: AppColors.primary,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(width: 4),
                          // 난이도 점
                          ...List.generate(4, (index) {
                            return Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.only(right: 2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index < exercise.difficulty
                                    ? AppColors.primary
                                    : AppColors.linePrimary,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // 세트/횟수 정보
                Row(
                  children: [
                    // 세트 아이콘 + 텍스트
                    SvgPicture.asset(
                      'assets/icons/ic_set.svg',
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        AppColors.textAssistive,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${exercise.sets}세트',
                      style: AppTextStyles.body14Regular.copyWith(
                        color: AppColors.textAssistive,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 횟수 아이콘 + 텍스트
                    SvgPicture.asset(
                      'assets/icons/ic_lap.svg',
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        AppColors.textAssistive,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${exercise.reps}회',
                      style: AppTextStyles.body14Regular.copyWith(
                        color: AppColors.textAssistive,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 운동 루틴 데이터 클래스
class ExerciseRoutineData {
  const ExerciseRoutineData({
    required this.name,
    required this.sets,
    required this.reps,
    required this.difficulty,
    this.imagePath,
  });

  /// 운동 이름
  final String name;

  /// 세트 수
  final int sets;

  /// 횟수
  final int reps;

  /// 난이도 (1~4)
  final int difficulty;

  /// 운동 이미지 경로 (optional)
  final String? imagePath;
}
