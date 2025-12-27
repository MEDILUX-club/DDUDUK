import 'dart:async';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:dduduk_app/theme/app_colors.dart';

/// 운동 동영상 재생 위젯 (YouTube 전용 - Universal Support)
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
  late YoutubePlayerController _controller;
  bool _isInitialized = false;
  
  // 상태 관리를 위한 변수
  bool _isPlaying = false;
  Timer? _positionTimer;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    final videoId = YoutubePlayerController.convertUrlToId(widget.videoUrl);
    
    if (videoId != null) {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: true,
        params: const YoutubePlayerParams(
          showControls: false, // 커스텀 UI 사용
          showFullscreenButton: false,
          mute: false,
          loop: false,
          strictRelatedVideos: true,
        ),
      );

      // 상태 리스너 등록
      _controller.setFullScreenListener((isFullScreen) {
        // 풀스크린 처리 (필요 시)
      });

      // 재생 상태 및 시간 변경 감지
      _controller.videoStateStream.listen((state) {
        // 영상 상태 업데이트
        _updateState();
      });

      setState(() {
        _isInitialized = true;
      });
    } else {
      debugPrint('Error: Invalid YouTube URL: ${widget.videoUrl}');
    }
  }

  void _updateState() async {
    if (!mounted) return;
    
    final state = await _controller.playerState;
    final isPlaying = state == PlayerState.playing;
    
    if (_isPlaying != isPlaying) {
      setState(() {
        _isPlaying = isPlaying;
      });
      widget.onPlayStateChanged?.call(isPlaying);

      if (isPlaying) {
        _startPositionTimer();
      } else {
        _stopPositionTimer();
      }
    }
  }

  void _startPositionTimer() {
    _positionTimer?.cancel();
    _positionTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) async {
      if (!mounted) return;
      final position = await _controller.currentTime;
      widget.onPositionChanged?.call(Duration(milliseconds: (position * 1000).toInt()));
    });
  }

  void _stopPositionTimer() {
    _positionTimer?.cancel();
    _positionTimer = null;
  }

  @override
  void dispose() {
    _stopPositionTimer();
    _controller.close();
    super.dispose();
  }

  /// 재생/일시정지 토글
  void togglePlay() {
    if (_isPlaying) {
      _controller.pauseVideo();
    } else {
      _controller.playVideo();
    }
  }

  /// 재생
  void play() {
    _controller.playVideo();
  }

  /// 일시정지
  void pause() {
    _controller.pauseVideo();
  }

  /// 현재 재생 위치 (비동기라 즉시 반환 어려움, 타이머가 업데이트함)
  Future<Duration> get position async {
    final secs = await _controller.currentTime;
    return Duration(milliseconds: (secs * 1000).toInt());
  }
 
  /// 재생 중인지 여부
  bool get isPlaying => _isPlaying;

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Container(
        decoration: BoxDecoration(
           color: AppColors.fillOption,
           borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.fillOption,
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            Positioned.fill(
              child: YoutubePlayer(
                controller: _controller,
                aspectRatio: 16 / 9,
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
