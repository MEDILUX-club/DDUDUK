import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:dduduk_app/theme/app_colors.dart';

/// 운동 동영상 재생 위젯
///
/// [videoUrl] - 재생할 동영상 URL (네트워크 또는 로컬 경로)
/// [onPlayStateChanged] - 재생 상태 변경 콜백
/// [onExpandPressed] - 확대 버튼 클릭 콜백
/// [showExpandButton] - 확대 버튼 표시 여부
class ExerciseVideoPlayer extends StatefulWidget {
  const ExerciseVideoPlayer({
    super.key,
    required this.videoUrl,
    this.onPlayStateChanged,
    this.onPositionChanged,
    this.onExpandPressed,
    this.showExpandButton = true,
  });

  final String videoUrl;
  final ValueChanged<bool>? onPlayStateChanged;
  final ValueChanged<Duration>? onPositionChanged;
  final VoidCallback? onExpandPressed;
  final bool showExpandButton;

  @override
  State<ExerciseVideoPlayer> createState() => ExerciseVideoPlayerState();
}

class ExerciseVideoPlayerState extends State<ExerciseVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    // 네트워크 URL인지 로컬 파일인지 확인
    if (widget.videoUrl.startsWith('http')) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );
    } else {
      _controller = VideoPlayerController.asset(widget.videoUrl);
    }

    await _controller.initialize();
    _controller.addListener(_onVideoUpdate);

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  void _onVideoUpdate() {
    if (!mounted) return;

    final isPlaying = _controller.value.isPlaying;
    if (_isPlaying != isPlaying) {
      setState(() {
        _isPlaying = isPlaying;
      });
      widget.onPlayStateChanged?.call(isPlaying);
    }

    widget.onPositionChanged?.call(_controller.value.position);
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoUpdate);
    _controller.dispose();
    super.dispose();
  }

  /// 재생/일시정지 토글
  void togglePlay() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  /// 재생
  void play() {
    _controller.play();
  }

  /// 일시정지
  void pause() {
    _controller.pause();
  }

  /// 현재 재생 위치
  Duration get position => _controller.value.position;

  /// 총 길이
  Duration get duration => _controller.value.duration;

  /// 재생 중인지 여부
  bool get isPlaying => _isPlaying;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fillOption,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: [
              // 비디오 플레이어
              if (_isInitialized)
                Positioned.fill(child: VideoPlayer(_controller)),

              // 확대 버튼 (우측 하단)
              if (widget.showExpandButton && widget.onExpandPressed != null)
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: GestureDetector(
                    onTap: widget.onExpandPressed,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.fullscreen,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
