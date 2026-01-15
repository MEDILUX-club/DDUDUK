import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:dduduk_app/theme/app_colors.dart';

/// 운동 동영상 재생 위젯 (YouTube 전용 - Native Player)
///
/// [videoUrl] - 재생할 YouTube URL
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
    this.onVideoEnded,
  });

  final String videoUrl;
  final ValueChanged<bool>? onPlayStateChanged;
  final ValueChanged<Duration>? onPositionChanged;
  final VoidCallback? onExpandPressed;
  final bool showExpandButton;
  final VoidCallback? onVideoEnded;

  @override
  State<ExerciseVideoPlayer> createState() => ExerciseVideoPlayerState();
}

class ExerciseVideoPlayerState extends State<ExerciseVideoPlayer> {
  late YoutubePlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    if (videoId != null && videoId.isNotEmpty) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          hideControls: true,
          controlsVisibleAtStart: false,
          enableCaption: false,
        ),
      );

      _controller.addListener(_onPlayerStateChanged);
    } else {
      // Invalid URL
    }
  }

  void _onPlayerStateChanged() {
    if (!mounted) return;

    final isPlaying = _controller.value.isPlaying;
    final position = _controller.value.position;

    if (_isPlaying != isPlaying) {
      setState(() {
        _isPlaying = isPlaying;
      });
      widget.onPlayStateChanged?.call(isPlaying);
    }

    widget.onPositionChanged?.call(position);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void togglePlay() {
    if (_isPlaying) {
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

  /// 재생 중인지 여부
  bool get isPlaying => _isPlaying;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.fillOption,
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            Positioned.fill(
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: false,
                onReady: () {
                  // Player Ready
                },
                onEnded: (metadata) {
                  widget.onVideoEnded?.call();
                },
              ),
            ),
            
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
    );
  }
}
