import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/exercise/rest_timer_circle.dart';
import 'package:dduduk_app/widgets/exercise/exercise_next_card.dart';
import 'package:dduduk_app/widgets/exercise/rest_alert_banner.dart';

/// 운동 휴식 화면
///
/// 휴식 타이머, 다음 운동 정보, 휴식 연장 기능을 제공합니다.
class ExerciseRestScreen extends StatefulWidget {
  const ExerciseRestScreen({
    super.key,
    this.initialRestSeconds = 30,
    this.extensionSeconds = 20,
    this.maxExtensions = 3,
    this.nextExercises = const [],
    this.onRestComplete,
    this.onNextExercise,
  });

  /// 초기 휴식 시간 (초)
  final int initialRestSeconds;

  /// 연장 시 추가되는 시간 (초)
  final int extensionSeconds;

  /// 최대 연장 횟수
  final int maxExtensions;

  /// 다음 운동 목록
  final List<NextExerciseData> nextExercises;

  /// 휴식 완료 시 호출되는 콜백
  final VoidCallback? onRestComplete;

  /// 다음 운동 버튼 클릭 시 호출되는 콜백
  final VoidCallback? onNextExercise;

  @override
  State<ExerciseRestScreen> createState() => _ExerciseRestScreenState();
}

class _ExerciseRestScreenState extends State<ExerciseRestScreen> {
  late int _remainingSeconds;
  late int _totalSeconds;
  int _extensionCount = 0;
  Timer? _timer;

  bool _showAlert = false;
  String _alertMessage = '';

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialRestSeconds;
    _totalSeconds = widget.initialRestSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        widget.onRestComplete?.call();
      }
    });
  }

  void _handleExtendRest() {
    if (_extensionCount < widget.maxExtensions) {
      // 연장 가능
      setState(() {
        _extensionCount++;
        _remainingSeconds += widget.extensionSeconds;
        _totalSeconds += widget.extensionSeconds;
        _alertMessage = '${widget.extensionSeconds}초 늘어났어요';
        _showAlert = true;
      });
    } else {
      // 최대 연장 횟수 초과
      setState(() {
        _alertMessage = '휴식 연장은 최대 ${widget.maxExtensions}번까지 가능해요';
        _showAlert = true;
      });
    }
  }

  void _dismissAlert() {
    setState(() {
      _showAlert = false;
    });
  }

  void _handleNextExercise() {
    _timer?.cancel();
    widget.onNextExercise?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            _buildAppBar(),

            // 알림 배너
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _showAlert
                    ? RestAlertBanner(
                        key: ValueKey(_alertMessage),
                        message: _alertMessage,
                        isVisible: _showAlert,
                        onDismiss: _dismissAlert,
                      )
                    : const SizedBox(height: 40),
              ),
            ),

            // 타이머 원형
            Expanded(
              child: Center(
                child: RestTimerCircle(
                  remainingSeconds: _remainingSeconds,
                  totalSeconds: _totalSeconds,
                ),
              ),
            ),

            // 다음 운동 섹션
            _buildNextExerciseSection(),

            // 하단 버튼들
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
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

  Widget _buildNextExerciseSection() {
    if (widget.nextExercises.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "다음 운동" 헤더
          Text(
            '다음 운동',
            style: AppTextStyles.body16Regular.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textStrong,
            ),
          ),
          const SizedBox(height: 12),
          // 운동 카드 목록
          ...widget.nextExercises.map(
            (exercise) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ExerciseNextCard(
                exerciseName: exercise.name,
                sets: exercise.sets,
                reps: exercise.reps,
                imagePath: exercise.imagePath,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Row(
        children: [
          // 휴식 늘리기 버튼
          Expanded(
            child: OutlinedButton(
              onPressed: _handleExtendRest,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: AppColors.linePrimary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                '휴식 늘리기',
                style: AppTextStyles.body16Regular.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textStrong,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 다음 운동 버튼
          Expanded(
            child: ElevatedButton(
              onPressed: _handleNextExercise,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                '다음 운동',
                style: AppTextStyles.body16Regular.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 다음 운동 데이터 클래스
class NextExerciseData {
  const NextExerciseData({
    required this.name,
    required this.sets,
    required this.reps,
    this.imagePath,
  });

  final String name;
  final int sets;
  final int reps;
  final String? imagePath;
}
