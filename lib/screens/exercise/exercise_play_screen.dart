import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/widgets/exercise/exercise_video_player.dart';
import 'package:dduduk_app/widgets/exercise/exercise_control_panel.dart';

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
  bool _isFullScreen = false; // 전체 화면 모드 여부
  bool _isLandscape = false; // 가로 모드 여부

  @override
  void dispose() {
    // 앱 종료 시 세로 모드로 복원
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

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  void _toggleLandscape() {
    setState(() {
      _isLandscape = !_isLandscape;
    });
    if (_isLandscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPrevious = widget.currentIndex > 0;
    final hasNext = widget.currentIndex < widget.totalCount - 1;

    return Scaffold(
      backgroundColor: AppColors.fillBoxDefault,
      body: SafeArea(
        child: _isLandscape
            ? _buildLandscapeMode(hasPrevious, hasNext)
            : _isFullScreen
            ? _buildFullScreenMode(hasPrevious, hasNext)
            : _buildNormalMode(hasPrevious, hasNext),
      ),
    );
  }

  /// 일반 모드 (비디오 작게 + 운동 정보 패널)
  Widget _buildNormalMode(bool hasPrevious, bool hasNext) {
    return Column(
      children: [
        // 커스텀 AppBar
        _buildAppBar(),

        // 비디오 플레이어 (작은 크기, 고정)
        ExerciseVideoPlayer(
          key: _videoPlayerKey,
          videoUrl: widget.videoUrl,
          onPlayStateChanged: _onPlayStateChanged,
          onPositionChanged: _onPositionChanged,
          showExpandButton: false, // 비디오 플레이어 내부 버튼 숨김
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
              onTap: _toggleFullScreen,
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
              currentTime: _currentPosition,
              isPlaying: _isPlaying,
              hasPrevious: hasPrevious,
              hasNext: hasNext,
              onPreviousPressed: hasPrevious ? _handlePrevious : null,
              onPlayPausePressed: _handlePlayPause,
              onNextPressed: hasNext ? _handleNext : null,
              // 운동 정보 표시
              showExerciseInfo: true,
              exerciseName: widget.exerciseName,
              exerciseDescription: widget.exerciseDescription,
              sets: widget.sets,
              reps: widget.reps,
            ),
          ),
        ),
      ],
    );
  }

  /// 전체 화면 모드 (비디오 크게 + 컨트롤만)
  Widget _buildFullScreenMode(bool hasPrevious, bool hasNext) {
    return Column(
      children: [
        // 커스텀 AppBar (축소 버튼 포함)
        _buildFullScreenAppBar(),

        // 비디오 플레이어 (큰 크기)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: ExerciseVideoPlayer(
                key: _videoPlayerKey,
                videoUrl: widget.videoUrl,
                onPlayStateChanged: _onPlayStateChanged,
                onPositionChanged: _onPositionChanged,
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
              onTap: _toggleLandscape,
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
              currentTime: _currentPosition,
              isPlaying: _isPlaying,
              hasPrevious: hasPrevious,
              hasNext: hasNext,
              onPreviousPressed: hasPrevious ? _handlePrevious : null,
              onPlayPausePressed: _handlePlayPause,
              onNextPressed: hasNext ? _handleNext : null,
              // 전체 화면에서는 운동 정보 숨김
              showExerciseInfo: false,
            ),
          ),
        ),
      ],
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

  Widget _buildFullScreenAppBar() {
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
          // 축소 버튼
          IconButton(
            icon: const Icon(Icons.fullscreen_exit),
            color: AppColors.textAssistive,
            onPressed: _toggleFullScreen,
          ),
        ],
      ),
    );
  }

  /// 가로 모드 (비디오 + 오른쪽 컨트롤)
  Widget _buildLandscapeMode(bool hasPrevious, bool hasNext) {
    return Row(
      children: [
        // 왼쪽: 뒤로가기 버튼 + 비디오 영역
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              // 비디오 플레이어
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(8),
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
                left: 8,
                top: 8,
                child: IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  color: AppColors.textAssistive,
                  onPressed: _toggleLandscape,
                ),
              ),
              // 회전 버튼 (오른쪽 하단)
              Positioned(
                right: 16,
                bottom: 16,
                child: GestureDetector(
                  onTap: _toggleLandscape,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0x4D454545),
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
                      onTap: _handlePrevious,
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
                      onTap: _handleNext,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required String svgPath,
    required VoidCallback onTap,
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
        child: Center(child: SvgPicture.asset(svgPath, width: 20, height: 20)),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
