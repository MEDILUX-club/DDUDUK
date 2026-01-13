import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/exercise/exercise_routine_card.dart';
import 'package:dduduk_app/repositories/exercise_repository.dart';
import 'package:dduduk_app/models/exercise/exercise_recommendation.dart';
import 'package:dduduk_app/screens/exercise/exercise_play_screen.dart';

/// 운동 루틴 목록 화면 (exercise_fixed_screen 다음 화면)
class ExerciseFixed1Screen extends StatefulWidget {
  const ExerciseFixed1Screen({
    super.key,
    this.dayNumber = 1,
  });

  /// 운동 일차
  final int dayNumber;

  @override
  State<ExerciseFixed1Screen> createState() => _ExerciseFixed1ScreenState();
}

class _ExerciseFixed1ScreenState extends State<ExerciseFixed1Screen> {
  final _exerciseRepository = ExerciseRepository();
  bool _isLoading = true;
  List<RecommendedExercise> _exercises = [];

  @override
  void initState() {
    super.initState();
    _loadRecommendation();
  }

  Future<void> _loadRecommendation() async {
    try {
      final now = DateTime.now();
      final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      
      // 오직 GET API만 호출 (생성 시도 로직 제거)
      final response = await _exerciseRepository.getRoutineByDate(dateStr);
      
      if (mounted) {
        setState(() {
          _exercises = response.exercises;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('운동 추천 로딩 오류: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // 에러 상황 사용자에게 알림
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('운동 루틴을 불러오지 못했습니다. (오류: ${e.toString()})'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _onStartPressed() {
    if (_exercises.isEmpty) return;

    // 운동 재생 플로우로 이동
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ExercisePlayFlow(exercises: _exercises),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        nextText: _isLoading ? '로딩 중...' : '시작하기',
        onNext: (_isLoading || _exercises.isEmpty) ? null : _onStartPressed,
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _exercises.isEmpty
                    ? const Center(
                        child: Text(
                          '준비된 운동 루틴이 없습니다.\n잠시 후 다시 시도해주세요.',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _exercises.length,
                        itemBuilder: (context, index) {
                          final exercise = _exercises[index];
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
class ExercisePlayFlow extends StatefulWidget {
  final List<RecommendedExercise> exercises;

  const ExercisePlayFlow({super.key, required this.exercises});

  @override
  State<ExercisePlayFlow> createState() => _ExercisePlayFlowState();
}

class _ExercisePlayFlowState extends State<ExercisePlayFlow> {
  int _currentIndex = 0;

  void _nextExercise() {
    if (_currentIndex < widget.exercises.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // 모든 운동 완료 시 메인으로 이동
      context.go('/exercise/main');
    }
  }

  void _prevExercise() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.exercises.isEmpty) return const SizedBox.shrink();

    final exercise = widget.exercises[_currentIndex];
    
    return ExercisePlayScreen(
      // key를 변경하여 위젯이 완전히 다시 빌드되도록 함 (비디오 플레이어 초기화)
      key: ValueKey(exercise.exerciseId + _currentIndex.toString()), 
      videoUrl: exercise.videoUrl,
      exerciseName: exercise.nameKo,
      exerciseDescription: exercise.description ?? '',
      sets: exercise.recommendedSets,
      reps: exercise.recommendedReps,
      currentIndex: _currentIndex,
      totalCount: widget.exercises.length,
      onNextExercise: _nextExercise,
      onPreviousExercise: _prevExercise,
    );
  }
}
