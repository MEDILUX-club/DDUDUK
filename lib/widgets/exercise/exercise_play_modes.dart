import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/widgets/exercise/exercise_video_player.dart';
import 'package:dduduk_app/widgets/exercise/exercise_control_panel.dart';

/// 일반 모드 재생 화면 (비디오 작게 + 운동 정보 패널)
class ExercisePlayModeNormal extends StatelessWidget {
  const ExercisePlayModeNormal({
    super.key,
    required this.videoUrl,
    required this.videoPlayerKey,
    required this.exerciseName,
    required this.exerciseDescription,
    required this.sets,
    required this.reps,
    required this.currentIndex,
    required this.totalCount,
    required this.currentPosition,
    required this.isPlaying,
    required this.onPlayStateChanged,
    required this.onPositionChanged,
    required this.onPlayPausePressed,
    required this.onPreviousPressed,
    required this.onNextPressed,
    required this.onToggleFullScreen,
    required this.onBack,
  });

  final String videoUrl;
  final GlobalKey<ExerciseVideoPlayerState> videoPlayerKey;
  final String exerciseName;
  final String exerciseDescription;
  final int sets;
  final int reps;
  final int currentIndex;
  final int totalCount;
  final Duration currentPosition;
  final bool isPlaying;
  
  final ValueChanged<bool> onPlayStateChanged;
  final ValueChanged<Duration> onPositionChanged;
  final VoidCallback onPlayPausePressed;
  final VoidCallback? onPreviousPressed;
  final VoidCallback? onNextPressed;
  final VoidCallback onToggleFullScreen;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    // hasPrevious, hasNext는 전달받은 콜백 null 여부로 판단 가능하다고 가정하거나,
    // 명시적으로 받지 않고 상위에서 처리된 콜백을 사용.
    final hasPrevious = onPreviousPressed != null;
    final hasNext = onNextPressed != null;

    return Column(
      children: [
        // 커스텀 AppBar
        _buildAppBar(context),

        // 비디오 플레이어 (작은 크기, 고정)
        // Padding 제거됨 (이전 요청 반영)
        ExerciseVideoPlayer(
          key: videoPlayerKey,
          videoUrl: videoUrl,
          onPlayStateChanged: onPlayStateChanged,
          onPositionChanged: onPositionChanged,
          showExpandButton: false, 
        ),

        // 여백 (컨트롤 패널과 비디오 사이)
        const SizedBox(height: 16),

        const Spacer(),

        // 확대 버튼 (컨트롤 패널 바로 위)
        Padding(
          padding: const EdgeInsets.only(right: 16, bottom: 12),
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onToggleFullScreen,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0x4D454545),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/ic_zoom.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
          ),
        ),

        // 컨트롤 패널 (운동 정보 포함)
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: ExerciseControlPanel(
              currentTime: currentPosition,
              isPlaying: isPlaying,
              hasPrevious: hasPrevious,
              hasNext: hasNext,
              onPreviousPressed: onPreviousPressed,
              onPlayPausePressed: onPlayPausePressed,
              onNextPressed: onNextPressed,
              // 운동 정보 표시
              showExerciseInfo: true,
              exerciseName: exerciseName,
              exerciseDescription: exerciseDescription,
              sets: sets,
              reps: reps,
            ),
          ),
        ),
      ],
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
            onPressed: onBack,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

/// 전체 화면 모드 재생 화면 (비디오 크게 + 컨트롤만)
class ExercisePlayModeFullScreen extends StatelessWidget {
  const ExercisePlayModeFullScreen({
    super.key,
    required this.videoUrl,
    required this.videoPlayerKey,
    required this.currentPosition,
    required this.isPlaying,
    required this.onPlayStateChanged,
    required this.onPositionChanged,
    required this.onPlayPausePressed,
    required this.onPreviousPressed,
    required this.onNextPressed,
    required this.onToggleFullScreen,
    required this.onToggleLandscape,
    required this.onBack,
  });

  final String videoUrl;
  final GlobalKey<ExerciseVideoPlayerState> videoPlayerKey;
  final Duration currentPosition;
  final bool isPlaying;
  
  final ValueChanged<bool> onPlayStateChanged;
  final ValueChanged<Duration> onPositionChanged;
  final VoidCallback onPlayPausePressed;
  final VoidCallback? onPreviousPressed;
  final VoidCallback? onNextPressed;
  final VoidCallback onToggleFullScreen;
  final VoidCallback onToggleLandscape;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final hasPrevious = onPreviousPressed != null;
    final hasNext = onNextPressed != null;

    return Column(
      children: [
        // 커스텀 AppBar (축소 버튼 포함)
        _buildFullScreenAppBar(context),

        // 비디오 플레이어 (큰 크기)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: ExerciseVideoPlayer(
                key: videoPlayerKey,
                videoUrl: videoUrl,
                onPlayStateChanged: onPlayStateChanged,
                onPositionChanged: onPositionChanged,
                showExpandButton: false,
              ),
            ),
          ),
        ),

        // 회전 버튼 (컨트롤 패널 바로 위)
        Padding(
          padding: const EdgeInsets.only(right: 16, bottom: 12),
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onToggleLandscape,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0x4D454545),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: const Icon(
                    Icons.screen_rotation,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ),

        // 컨트롤 패널 (운동 정보 없이)
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: ExerciseControlPanel(
              currentTime: currentPosition,
              isPlaying: isPlaying,
              hasPrevious: hasPrevious,
              hasNext: hasNext,
              onPreviousPressed: onPreviousPressed,
              onPlayPausePressed: onPlayPausePressed,
              onNextPressed: onNextPressed,
              // 전체 화면에서는 운동 정보 숨김
              showExerciseInfo: false,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFullScreenAppBar(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            color: AppColors.textNormal,
            onPressed: onBack,
          ),
          const Spacer(),
          // 축소 버튼
          IconButton(
            icon: const Icon(Icons.fullscreen_exit),
            color: AppColors.textAssistive,
            onPressed: onToggleFullScreen,
          ),
        ],
      ),
    );
  }
}
