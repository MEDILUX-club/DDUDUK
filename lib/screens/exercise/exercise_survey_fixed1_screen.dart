import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/exercise/exercise_routine_card.dart';
import 'package:dduduk_app/providers/exercise_provider.dart';
import 'package:dduduk_app/screens/exercise/exercise_play_flow.dart';

/// 운동 루틴 목록 화면 (exercise_fixed_screen 다음 화면)
class ExerciseFixed1Screen extends ConsumerStatefulWidget {
  const ExerciseFixed1Screen({super.key});

  @override
  ConsumerState<ExerciseFixed1Screen> createState() => _ExerciseFixed1ScreenState();
}

class _ExerciseFixed1ScreenState extends ConsumerState<ExerciseFixed1Screen> {
  /// 운동 일차 (서버 데이터 기반으로 자동 계산)
  int _dayNumber = 1;

  @override
  void initState() {
    super.initState();
    // Provider 수정은 build 이후에 수행해야 함 (필수!)
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    // 1. 운동 일차 계산
    await _calculateDayNumber();
    
    // 2. 운동 루틴 로드
    await _loadRecommendation();
  }

  /// 운동 일차 계산: 운동한 날짜 개수 + 1 (오늘이 새 운동일 경우)
  Future<void> _calculateDayNumber() async {
    await ref.read(exerciseProvider.notifier).fetchWorkoutDates();
    final exerciseState = ref.read(exerciseProvider);
    final workoutDates = exerciseState.workoutDates;

    // 오늘 날짜
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    // 오늘이 이미 운동 기록에 있으면 → 날짜 개수 그대로
    // 오늘이 새 운동일이면 → 날짜 개수 + 1
    final todayAlreadyExists = workoutDates.contains(todayStr);
    final calculatedDayNumber = todayAlreadyExists 
        ? workoutDates.length 
        : workoutDates.length + 1;

    if (mounted) {
      setState(() {
        _dayNumber = calculatedDayNumber > 0 ? calculatedDayNumber : 1;
      });
    }

    debugPrint('운동 일차 계산: ${workoutDates.length}일 기록, 오늘 존재: $todayAlreadyExists → $_dayNumber일차');
  }

  Future<void> _loadRecommendation() async {
    final now = DateTime.now();
    final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    // 1차: GET으로 루틴 조회 시도
    await ref.read(exerciseProvider.notifier).fetchRoutineByDate(dateStr);

    final state = ref.read(exerciseProvider);

    // 루틴이 없으면 생성 시도
    if (!state.hasRoutine && state.error == null) {
      debugPrint('GET 루틴 조회 실패, AI 운동 추천 생성 시도...');

      // 2차: POST로 생성
      final created = await ref.read(exerciseProvider.notifier).createInitialRecommendation(dateStr);

      if (created) {
        final newState = ref.read(exerciseProvider);
        if (newState.currentRoutine != null) {
          // 2-2. 추천 운동 저장
          await ref.read(exerciseProvider.notifier).saveRoutines(
            routineDate: dateStr,
            exercises: newState.currentRoutine!.exercises,
          );
          debugPrint('추천 운동 저장 완료');

          // 2-3. 다시 GET으로 조회 (저장된 데이터 확인)
          await ref.read(exerciseProvider.notifier).fetchRoutineByDate(dateStr);
        }
      }
    }

    // 최종 에러 확인
    if (!mounted) return;
    final finalState = ref.read(exerciseProvider);
    if (!finalState.hasRoutine && finalState.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('운동 루틴을 불러오지 못했습니다. 잠시 후 다시 시도해주세요.'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _onStartPressed() {
    final exerciseState = ref.read(exerciseProvider);
    if (!exerciseState.hasRoutine) return;

    // 운동 재생 플로우로 이동
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ExercisePlayFlow(exercises: exerciseState.currentRoutine!.exercises),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exerciseState = ref.watch(exerciseProvider);
    final isLoading = exerciseState.isLoading;
    final exercises = exerciseState.currentRoutine?.exercises ?? [];

    return SurveyLayout(
      appBarTitle: '',
      showProgressBar: false,
      titleWidget: RichText(
        text: TextSpan(
          style: AppTextStyles.body20Bold.copyWith(
            color: AppColors.textStrong,
          ),
          children: [
            const TextSpan(text: '오늘은 운동 '),
            TextSpan(
              text: '$_dayNumber일차',
              style: AppTextStyles.body20Bold.copyWith(
                color: AppColors.primary,
              ),
            ),
            const TextSpan(text: '예요'),
          ],
        ),
      ),
      description: '오늘도 힘차게 시작해보아요!',
      bottomButtons: SurveyButtonsConfig(
        nextText: isLoading ? '로딩 중...' : '시작하기',
        onNext: (isLoading || exercises.isEmpty) ? null : _onStartPressed,
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : exercises.isEmpty
                    ? const Center(
                        child: Text(
                          '준비된 운동 루틴이 없습니다.\n잠시 후 다시 시도해주세요.',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: exercises.length,
                        itemBuilder: (context, index) {
                          final exercise = exercises[index];
                          // UI 표시용 데이터 변환
                          final uiData = ExerciseRoutineData(
                            name: exercise.nameKo,
                            sets: exercise.recommendedSets,
                            reps: exercise.recommendedReps,
                            difficulty: _parseDifficulty(exercise.difficulty),
                            imagePath: 'assets/images/img_squat_10.png', // 임시 이미지
                          );

                          return ExerciseRoutineCard(exercise: uiData);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  int _parseDifficulty(String diff) {
    if (diff.contains('초급')) return 1;
    if (diff.contains('중급')) return 2;
    if (diff.contains('고급')) return 3;
    return 1;
  }
}
