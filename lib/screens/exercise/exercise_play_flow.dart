import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dduduk_app/widgets/exercise/exercise_routine_card.dart';
import 'package:dduduk_app/providers/exercise_provider.dart';
import 'package:dduduk_app/models/exercise/exercise_recommendation.dart';
import 'package:dduduk_app/models/exercise/workout_record.dart';
import 'package:dduduk_app/screens/exercise/exercise_play_screen.dart';
import 'package:dduduk_app/screens/exercise/exercise_rest_screen.dart';

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
