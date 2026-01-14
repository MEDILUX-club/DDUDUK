import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/widgets/exercise/exercise_video_player.dart';
import 'package:dduduk_app/widgets/exercise/rest_exit_modal.dart';
import 'package:dduduk_app/widgets/exercise/exercise_info_badge.dart';


/// 비디오의 확대 버튼을 누르면 전체 화면 모드로 전환
class ExercisePlayScreen extends StatefulWidget {
  const ExercisePlayScreen({
    super.key,
    required this.videoUrl,
    required this.exerciseName,
    this.exerciseDescription = '',
    this.sets = 3,
    this.reps = 10,
    this.currentIndex = 0,
    this.totalCount = 1,
    this.onPreviousExercise,
    this.onNextExercise,
    this.onExit,
  });

  /// 재생할 동영상 URL
  final String videoUrl;

  /// 운동 이름
  final String exerciseName;

  /// 운동 설명
  final String exerciseDescription;

  /// 세트 수
  final int sets;

  /// 횟수
  final int reps;

  /// 현재 운동 인덱스 (0부터 시작)
  final int currentIndex;

  /// 전체 운동 개수
  final int totalCount;

  /// 이전 운동 콜백
  final VoidCallback? onPreviousExercise;

  /// 다음 운동 콜백
  final VoidCallback? onNextExercise;

  /// 나가기 콜백 (운동 영상 중 나가기 - 현재 운동 미저장)
  final VoidCallback? onExit;

  @override
  State<ExercisePlayScreen> createState() => _ExercisePlayScreenState();
}

class _ExercisePlayScreenState extends State<ExercisePlayScreen> {
  final GlobalKey<ExerciseVideoPlayerState> _videoPlayerKey = GlobalKey();

  Duration _currentPosition = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    // 세로 모드 유지 (가로 모드 이슈는 나중에 해결)
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onPlayStateChanged(bool isPlaying) {
    setState(() {
      _isPlaying = isPlaying;
    });
  }

  void _onPositionChanged(Duration position) {
    setState(() {
      _currentPosition = position;
    });
  }

  void _handlePlayPause() {
    debugPrint('[PlayScreen] 재생/일시정지 버튼 클릭 (현재 상태: ${_isPlaying ? "재생 중" : "일시정지"})');
    _videoPlayerKey.currentState?.togglePlay();
  }

  void _handlePrevious() {
    widget.onPreviousExercise?.call();
  }

  void _handleNext() {
    widget.onNextExercise?.call();
  }

  Future<void> _handleBack() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => const RestExitModal(),
    );

    if (shouldExit == true && mounted) {
      widget.onExit?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {


        final hasPrevious = widget.currentIndex > 0;

        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Row(
              children: [
                // 왼쪽: 뒤로가기 버튼 + 비디오 영역
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      // 비디오 플레이어
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: ExerciseVideoPlayer(
                            key: _videoPlayerKey,
                            videoUrl: widget.videoUrl,
                            onPlayStateChanged: _onPlayStateChanged,
                            onPositionChanged: _onPositionChanged,
                            showExpandButton: false,
                            onVideoEnded: _handleNext, // 영상 종료 시 자동으로 다음으로
                          ),
                        ),
                      ),
                      // 뒤로가기 버튼 (왼쪽 상단)
                      Positioned(
                        left: 16,
                        top: 16,
                        child: GestureDetector(
                          onTap: _handleBack,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                               color: Colors.black.withValues(alpha: 0.4),
                               shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 오른쪽: 컨트롤 패널 (흰색 배경)
                Container(
                  width: 200,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        // 타이머 (상단)
                        Text(
                          _formatDuration(_currentPosition),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textStrong,
                          ),
                        ),
                        const Spacer(),
                        // 세트와 랩수 정보 (재생 버튼 위)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ExerciseInfoBadge(
                              iconPath: 'assets/icons/ic_set.svg',
                              value: widget.sets,
                            ),
                            const SizedBox(width: 12),
                            ExerciseInfoBadge(
                              iconPath: 'assets/icons/ic_lap.svg',
                              value: widget.reps,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // 버튼들 (하단)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 이전 버튼
                            _buildControlButton(
                              svgPath: 'assets/icons/ic_previous.svg',
                              onTap: hasPrevious ? _handlePrevious : null,
                              isEnabled: hasPrevious,
                            ),
                            const SizedBox(width: 12),
                            // 재생/일시정지 버튼
                            GestureDetector(
                              onTap: _handlePlayPause,
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // 다음 버튼 (항상 활성화 - 마지막 운동에서는 완료 화면으로 이동)
                            _buildControlButton(
                              svgPath: 'assets/icons/ic_next.svg',
                              onTap: _handleNext,
                              isEnabled: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlButton({
    required String svgPath,
    required VoidCallback? onTap,
    bool isEnabled = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.fillDefault,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            svgPath, 
            width: 20, 
            height: 20,
            colorFilter: isEnabled ? null : const ColorFilter.mode(AppColors.textDisabled, BlendMode.srcIn),
          )
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
