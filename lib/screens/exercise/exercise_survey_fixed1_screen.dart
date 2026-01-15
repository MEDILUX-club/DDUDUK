import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/exercise/exercise_routine_card.dart';
import 'package:dduduk_app/providers/exercise_provider.dart';
import 'package:dduduk_app/models/exercise/exercise_recommendation.dart';
import 'package:dduduk_app/models/exercise/workout_record.dart';
import 'package:dduduk_app/screens/exercise/exercise_play_screen.dart';
import 'package:dduduk_app/screens/exercise/exercise_rest_screen.dart';

/// 운동 루틴 목록 화면 (exercise_fixed_screen 다음 화면)
class ExerciseFixed1Screen extends ConsumerStatefulWidget {
  const ExerciseFixed1Screen({
    super.key,
    this.dayNumber = 1,
  });

  /// 운동 일차
  final int dayNumber;

  @override
  ConsumerState<ExerciseFixed1Screen> createState() => _ExerciseFixed1ScreenState();
}

class _ExerciseFixed1ScreenState extends ConsumerState<ExerciseFixed1Screen> {
  @override
  void initState() {
    super.initState();
    _loadRecommendation();
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
              text: '${widget.dayNumber}일차',
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

/// 운동 재생 플로우 관리 위젯 (순차 재생)
///
/// 운동 → 휴식 → 운동 → 휴식 → ... → 완료
class ExercisePlayFlow extends ConsumerStatefulWidget {
  final List<RecommendedExercise> exercises;

  const ExercisePlayFlow({super.key, required this.exercises});

  @override
  ConsumerState<ExercisePlayFlow> createState() => _ExercisePlayFlowState();
}

class _ExercisePlayFlowState extends ConsumerState<ExercisePlayFlow> {
  int _currentIndex = 0;
  bool _showingRest = false; // true: 휴식 화면, false: 운동 화면

  /// 완료된 운동 인덱스 리스트 (휴식 화면으로 넘어갈 때 추가)
  final List<int> _completedExerciseIndices = [];

  /// 운동 시작 시간 (전체 운동 세션 시작 시간)
  DateTime? _workoutStartTime;

  @override
  void initState() {
    super.initState();
    // 첫 운동 시작 시간 기록
    _workoutStartTime = DateTime.now();
  }

  /// 다음 단계로 이동
  void _goToNext() {
    if (_showingRest) {
      // 휴식 화면에서 → 다음 운동으로
      if (_currentIndex < widget.exercises.length - 1) {
        setState(() {
          _currentIndex++;
          _showingRest = false;
        });
      } else {
        // 모든 운동 완료 → 전체 저장 후 이동
        _saveAndExit(saveAll: true);
      }
    } else {
      // 운동 화면에서 → 휴식 화면으로 (현재 운동 완료 처리)
      _completedExerciseIndices.add(_currentIndex);
      debugPrint('운동 ${_currentIndex + 1} 완료 (총 ${_completedExerciseIndices.length}개 완료)');

      if (_currentIndex < widget.exercises.length - 1) {
        setState(() {
          _showingRest = true;
        });
      } else {
        // 마지막 운동이면 휴식 없이 완료 → 전체 저장 후 이동
        _saveAndExit(saveAll: true);
      }
    }
  }

  void _prevExercise() {
    if (_showingRest) {
      // 휴식 화면에서 뒤로 → 현재 운동으로
      setState(() {
        _showingRest = false;
      });
    } else if (_currentIndex > 0) {
      // 운동 화면에서 뒤로 → 이전 운동으로
      setState(() {
        _currentIndex--;
      });
    } else {
      // 첫 번째 운동에서 뒤로가면 종료
      Navigator.of(context).pop();
    }
  }

  /// 운동 영상 중 나가기 (현재 운동 미저장)
  void _exitFromPlayScreen() {
    debugPrint('운동 영상 중 나가기: ${_completedExerciseIndices.length}개 운동 저장');
    _saveAndExit(saveAll: false);
  }

  /// 휴식 중 나가기 (현재 운동까지 저장)
  void _exitFromRestScreen() {
    debugPrint('휴식 중 나가기: ${_completedExerciseIndices.length}개 운동 저장');
    _saveAndExit(saveAll: false);
  }

  /// 완료된 운동을 서버에 저장하고 메인 화면으로 이동
  Future<void> _saveAndExit({required bool saveAll}) async {
    // 총 운동 시간 계산 (초 단위)
    int totalDurationSeconds = 0;
    if (_workoutStartTime != null) {
      final endTime = DateTime.now();
      totalDurationSeconds = endTime.difference(_workoutStartTime!).inSeconds;
      debugPrint('총 소요 시간: $totalDurationSeconds초 (${(totalDurationSeconds / 60).toStringAsFixed(1)}분)');
    }

    // 저장할 운동 목록 생성
    final recordsToSave = <WorkoutRecord>[];

    // 각 운동에 동일한 시간을 분배 (간단한 방법)
    final durationPerExercise = _completedExerciseIndices.isNotEmpty
        ? (totalDurationSeconds / _completedExerciseIndices.length).round()
        : 0;

    for (final index in _completedExerciseIndices) {
      final exercise = widget.exercises[index];
      recordsToSave.add(WorkoutRecord(
        exerciseId: exercise.exerciseId,
        exerciseName: exercise.nameKo,
        actualSets: exercise.recommendedSets,
        actualReps: exercise.recommendedReps,
        durationSeconds: durationPerExercise, // 실제 소요 시간 반영
      ));
    }

    if (recordsToSave.isNotEmpty) {
      final now = DateTime.now();
      final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      // Provider를 통해 운동 기록 저장
      final success = await ref.read(exerciseProvider.notifier).saveWorkoutRecords(
        date: dateStr,
        records: recordsToSave,
      );

      if (success) {
        debugPrint('운동 기록 저장 완료: ${recordsToSave.length}개');
      } else {
        debugPrint('운동 기록 저장 실패');
      }
    } else {
      debugPrint('저장할 운동 기록 없음');
    }

    // 메인 화면으로 이동
    if (mounted) {
      if (saveAll) {
        context.go('/exercise/complete');
      } else {
        context.go('/exercise/main');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.exercises.isEmpty) return const SizedBox.shrink();

    final exercise = widget.exercises[_currentIndex];

    // 휴식 화면 표시 (세로모드)
    if (_showingRest) {
      // 다음 운동 목록 생성
      final nextExercises = <ExerciseRoutineData>[];
      for (int i = _currentIndex + 1; i < widget.exercises.length && nextExercises.length < 2; i++) {
        final next = widget.exercises[i];
        nextExercises.add(ExerciseRoutineData(
          name: next.nameKo,
          sets: next.recommendedSets,
          reps: next.recommendedReps,
        ));
      }

      return ExerciseRestScreen(
        initialRestSeconds: 30,
        extensionSeconds: 20,
        maxExtensions: 3,
        nextExercises: nextExercises,
        onNextExercise: _goToNext,
        onRestComplete: _goToNext,
        onExit: _exitFromRestScreen,
      );
    }

    // 운동 화면 표시 (가로모드)
    return ExercisePlayScreen(
      key: ValueKey('exercise_${exercise.exerciseId}_$_currentIndex'),
      videoUrl: exercise.videoUrl,
      exerciseName: exercise.nameKo,
      exerciseDescription: exercise.description ?? '',
      sets: exercise.recommendedSets,
      reps: exercise.recommendedReps,
      currentIndex: _currentIndex,
      totalCount: widget.exercises.length,
      onNextExercise: _goToNext,
      onPreviousExercise: _prevExercise,
      onExit: _exitFromPlayScreen,
    );
  }
}
