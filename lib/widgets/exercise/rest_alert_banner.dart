import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';

/// 휴식 관련 알림을 표시하는 배너 위젯
///
/// [message] - 표시할 메시지
/// [isVisible] - 표시 여부
class RestAlertBanner extends StatefulWidget {
  const RestAlertBanner({
    super.key,
    required this.message,
    required this.isVisible,
    this.duration = const Duration(seconds: 3),
    this.onDismiss,
  });

  /// 표시할 메시지
  final String message;

  /// 배너 표시 여부
  final bool isVisible;

  /// 자동 숨김 시간 (기본 3초)
  final Duration duration;

  /// 배너가 사라질 때 호출되는 콜백
  final VoidCallback? onDismiss;

  @override
  State<RestAlertBanner> createState() => _RestAlertBannerState();
}

class _RestAlertBannerState extends State<RestAlertBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (widget.isVisible) {
      _controller.forward();
      _scheduleAutoDismiss();
    }
  }

  @override
  void didUpdateWidget(RestAlertBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _controller.forward();
      _scheduleAutoDismiss();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _controller.reverse();
    }
  }

  void _scheduleAutoDismiss() {
    Future.delayed(widget.duration, () {
      if (mounted && widget.isVisible) {
        widget.onDismiss?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.lineNeutral),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 시계 아이콘
              SvgPicture.asset(
                'assets/icons/ic_clock.svg',
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  AppColors.textNeutral,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              // 메시지 텍스트
              Text(
                widget.message,
                style: AppTextStyles.body14Medium.copyWith(
                  color: AppColors.textNeutral,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
