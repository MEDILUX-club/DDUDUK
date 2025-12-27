import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/widgets/exercise/exercise_video_player.dart';


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
    // 가로 모드 강제 설정
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // 앱 종료(화면 이탈) 시 세로 모드로 복원
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
    _videoPlayerKey.currentState?.togglePlay();
  }

  void _handlePrevious() {
    widget.onPreviousExercise?.call();
  }

  void _handleNext() {
    widget.onNextExercise?.call();
  }

  void _handleBack() {
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {


        final hasPrevious = widget.currentIndex > 0;
        final hasNext = widget.currentIndex < widget.totalCount - 1;

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
                            // 다음 버튼
                            _buildControlButton(
                              svgPath: 'assets/icons/ic_next.svg',
                              onTap: hasNext ? _handleNext : null,
                              isEnabled: hasNext,
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
