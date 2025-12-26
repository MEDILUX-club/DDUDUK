import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';

/// 휴식 시간을 표시하는 원형 타이머 위젯
///
/// [remainingSeconds] - 남은 휴식 시간 (초)
/// [totalSeconds] - 전체 휴식 시간 (초)
class RestTimerCircle extends StatelessWidget {
  const RestTimerCircle({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
  });

  /// 남은 휴식 시간 (초)
  final int remainingSeconds;

  /// 전체 휴식 시간 (초)
  final int totalSeconds;

  @override
  Widget build(BuildContext context) {
    // 진행률 계산 (0.0 ~ 1.0)
    final progress = totalSeconds > 0 ? remainingSeconds / totalSeconds : 0.0;

    return SizedBox(
      width: 280,
      height: 280,
      child: CustomPaint(
        painter: _TimerCirclePainter(
          progress: progress.clamp(0.0, 1.0),
          backgroundColor: AppColors.linePrimary,
          progressColor: AppColors.primary,
          strokeWidth: 8,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // "휴식시간" 라벨
              Text(
                '휴식시간',
                style: AppTextStyles.body14Medium.copyWith(
                  color: AppColors.textNeutral,
                ),
              ),
              const SizedBox(height: 8),
              // MM:SS 형식의 시간
              Text(
                _formatTime(remainingSeconds),
                style: AppTextStyles.titleText1.copyWith(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textStrong,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 초를 MM:SS 형식으로 변환
  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }
}

/// 원형 진행바를 그리는 CustomPainter
class _TimerCirclePainter extends CustomPainter {
  _TimerCirclePainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // 배경 원 (회색)
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // 진행률 원 (초록색)
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // 시작 각도: 상단 (-90도 = -π/2)
    // 진행 각도: 시계 방향으로 progress만큼
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TimerCirclePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
