import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final hasPrevious = widget.currentIndex > 0;
    final hasNext = widget.currentIndex < widget.totalCount - 1;

    return Scaffold(
      backgroundColor: AppColors.fillBoxDefault,
      body: SafeArea(
        child: _isFullScreen
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

        // 비디오 플레이어 (작은 크기)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ExerciseVideoPlayer(
            key: _videoPlayerKey,
            videoUrl: widget.videoUrl,
            onPlayStateChanged: _onPlayStateChanged,
            onPositionChanged: _onPositionChanged,
            onExpandPressed: _toggleFullScreen,
            showExpandButton: true,
          ),
        ),

        const Spacer(),

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
                onExpandPressed: _toggleFullScreen,
                showExpandButton: false, // 전체 화면에서는 확대 버튼 숨김
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
}
