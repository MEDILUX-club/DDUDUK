import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';
import 'package:dduduk_app/widgets/exercise/exercise_routine_card.dart';
import 'package:dduduk_app/widgets/exercise/rest_alert_banner.dart';
import 'package:dduduk_app/widgets/exercise/rest_timer_circle.dart';
import 'package:dduduk_app/widgets/exercise/rest_exit_modal.dart';

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
    this.onExit,
  });

  /// 초기 휴식 시간 (초)
  final int initialRestSeconds;

  /// 연장 시 추가되는 시간 (초)
  final int extensionSeconds;

  /// 최대 연장 횟수
  final int maxExtensions;

  /// 다음 운동 목록
  final List<ExerciseRoutineData> nextExercises;

  /// 휴식 완료 시 호출되는 콜백
  final VoidCallback? onRestComplete;

  /// 다음 운동 버튼 클릭 시 호출되는 콜백
  final VoidCallback? onNextExercise;

  /// 나가기 콜백 (휴식 중 나가기 - 현재 운동까지 저장)
  final VoidCallback? onExit;

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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              _buildBody(),
              _buildBottomButtons(),
            ],
          ),
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
            onPressed: _handleBack,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: Column(
        children: [
          _buildAlertBanner(),
          _buildTimerSection(),
          _buildNextExerciseSection(),
        ],
      ),
    );
  }

  Widget _buildAlertBanner() {
    return Padding(
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
    );
  }

  Widget _buildTimerSection() {
    return Expanded(
      child: Center(
        child: RestTimerCircle(
          remainingSeconds: _remainingSeconds,
          totalSeconds: _totalSeconds,
        ),
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
          Text(
            '다음 운동',
            style: AppTextStyles.body16Regular.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textStrong,
            ),
          ),
          const SizedBox(height: 12),
          ...widget.nextExercises.map(
            (exercise) => ExerciseRoutineCard(exercise: exercise),
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
          Expanded(
            child: SizedBox(
              height: 56,
              child: OutlinedButton(
                onPressed: _handleExtendRest,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.linePrimary),
                  backgroundColor: AppColors.fillBoxDefault,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  foregroundColor: AppColors.textNormal,
                ),
                child: Text(
                  '휴식 늘리기',
                  style: AppTextStyles.body16Medium.copyWith(
                    color: AppColors.textNormal,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: BaseButton(
              text: '다음 운동',
              onPressed: _handleNextExercise,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
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
      setState(() {
        _extensionCount++;
        _remainingSeconds += widget.extensionSeconds;
        _totalSeconds += widget.extensionSeconds;
        _alertMessage = '${widget.extensionSeconds}초 늘어났어요';
        _showAlert = true;
      });
    } else {
      setState(() {
        _alertMessage = '휴식 연장은 최대 ${widget.maxExtensions}번까지 가능해요';
        _showAlert = true;
      });
    }
  }

  void _handleNextExercise() {
    _timer?.cancel();
    widget.onNextExercise?.call();
  }

  Future<void> _handleBack() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => const RestExitModal(),
    );

    if (shouldExit == true && mounted) {
      _timer?.cancel();
      widget.onExit?.call();
    }
  }

  void _dismissAlert() {
    setState(() {
      _showAlert = false;
    });
  }
}

