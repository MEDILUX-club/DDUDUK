import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';

/// 운동 컨트롤 패널 위젯
/// 운동 정보 + 타이머 + 이전/재생/다음 버튼을 포함하는 통합 위젯
class ExerciseControlPanel extends StatelessWidget {
  const ExerciseControlPanel({
    super.key,
    // 운동 정보 관련 파라미터 (UI 상단)
    this.showExerciseInfo = false,
    this.exerciseName = '',
    this.exerciseDescription = '',
    this.sets = 0,
    this.reps = 0,
    // 타이머/컨트롤 관련 파라미터 (UI 하단)
    required this.currentTime,
    required this.isPlaying,
    required this.onPlayPausePressed,
    this.onPreviousPressed,
    this.onNextPressed,
    this.hasPrevious = true,
    this.hasNext = true,
  });

  // 운동 정보 관련 필드 (UI 상단)

  /// 운동 정보 표시 여부
  final bool showExerciseInfo;

  /// 운동 이름
  final String exerciseName;

  /// 운동 설명
  final String exerciseDescription;

  /// 세트 수
  final int sets;

  /// 횟수
  final int reps;

  // 타이머/컨트롤 관련 필드 (UI 하단)

  /// 현재 시간 (Duration)
  final Duration currentTime;

  /// 재생 중인지 여부
  final bool isPlaying;

  /// 재생/일시정지 버튼 콜백
  final VoidCallback onPlayPausePressed;

  /// 이전 운동 버튼 콜백
  final VoidCallback? onPreviousPressed;

  /// 다음 운동 버튼 콜백
  final VoidCallback? onNextPressed;

  /// 이전 운동이 있는지 여부
  final bool hasPrevious;

  /// 다음 운동이 있는지 여부
  final bool hasNext;

  // 운동 정보 빌더 (UI 상단)

  Widget _buildExerciseInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 운동 이름
        Text(
          exerciseName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textStrong,
          ),
        ),
        if (exerciseDescription.isNotEmpty) ...[
          const SizedBox(height: 8),
          // 운동 설명
          Text(
            exerciseDescription,
            style: const TextStyle(fontSize: 14, color: AppColors.textNeutral),
          ),
        ],
        const SizedBox(height: 16),
        // 세트/랩 카드
        Row(
          children: [
            Expanded(
              child: _InfoCard(
                svgPath: 'assets/icons/ic_set.svg',
                label: '세트',
                value: '$sets회',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InfoCard(
                svgPath: 'assets/icons/ic_lap.svg',
                label: '랩',
                value: '$reps회',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 타이머/컨트롤 빌더 (UI 하단)

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 운동 정보 (showExerciseInfo가 true일 때만 표시)
        if (showExerciseInfo) ...[
          _buildExerciseInfo(),
          const SizedBox(height: 24),
        ],

        // 타이머 표시
        Text(
          _formatDuration(currentTime),
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: AppColors.textStrong,
          ),
        ),
        const SizedBox(height: 32),

        // 컨트롤 버튼들
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 이전 운동 버튼
            _NavigationButton(
              label: '이전 운동',
              svgPath: 'assets/icons/ic_previous.svg',
              iconPosition: IconPosition.left,
              backgroundColor: AppColors.fillDefault,
              textColor: AppColors.textNormal,
              onPressed: onPreviousPressed,
            ),
            const SizedBox(width: 16),
            // 재생/일시정지 버튼
            _PlayPauseButton(
              isPlaying: isPlaying,
              onPressed: onPlayPausePressed,
            ),
            const SizedBox(width: 16),
            // 다음 운동 버튼
            _NavigationButton(
              label: '다음 운동',
              svgPath: 'assets/icons/ic_next.svg',
              iconPosition: IconPosition.right,
              backgroundColor: AppColors.fillDefault,
              textColor: AppColors.textNormal,
              onPressed: onNextPressed,
            ),
          ],
        ),
      ],
    );
  }
}

// 운동 정보 관련 위젯 (UI 상단)

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.svgPath,
    required this.label,
    required this.value,
  });

  final String svgPath;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.fillBoxDefault,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.linePrimary),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 아이콘 + 라벨 (상단)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(svgPath, width: 18, height: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textAssistive,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 횟수 (하단)
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textStrong,
            ),
          ),
        ],
      ),
    );
  }
}

// 컨트롤 관련 위젯 (UI 하단)

enum IconPosition { left, right }

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.label,
    required this.svgPath,
    required this.iconPosition,
    required this.backgroundColor,
    required this.textColor,
    this.onPressed,
  });

  final String label;
  final String svgPath;
  final IconPosition iconPosition;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    // 항상 활성화 상태 (비활성화 기능 제거)
    final bgColor = backgroundColor;
    final fgColor = textColor;

    Widget iconWidget = SvgPicture.asset(
      svgPath,
      width: 20,
      height: 20,
      colorFilter: ColorFilter.mode(fgColor, BlendMode.srcIn),
    );

    final children = [
      if (iconPosition == IconPosition.left) iconWidget,
      if (iconPosition == IconPosition.left) const SizedBox(width: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: fgColor,
        ),
      ),
      if (iconPosition == IconPosition.right) const SizedBox(width: 4),
      if (iconPosition == IconPosition.right) iconWidget,
    ];

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(mainAxisSize: MainAxisSize.min, children: children),
        ),
      ),
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton({required this.isPlaying, required this.onPressed});

  final bool isPlaying;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          child: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: AppColors.textWhite,
            size: 32,
          ),
        ),
      ),
    );
  }
}
