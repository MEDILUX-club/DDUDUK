import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // 개발 모드에서 URL로 직접 접근 시 리다이렉트 건너뛰기
    if (kDebugMode) {
      final uri = Uri.base;
      final path = uri.fragment.isNotEmpty ? uri.fragment : uri.path;
      if (path != '/' && path.isNotEmpty) {
        // URL에 특정 경로가 있으면 해당 경로로 이동
        Timer(const Duration(milliseconds: 100), () {
          if (!mounted) return;
          context.go(path);
        });
        return;
      }
    }

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.go('/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: _SplashBody(),
    );
  }
}

class _SplashBody extends StatelessWidget {
  const _SplashBody();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double scale = (size.width / 375).clamp(0.9, 1.2);
    final double fontSize = 20 * scale;
    final double letterSpacing = 2.4 * scale;

    return Center(
      child: Text(
        'DDUDUK',
        style: AppTextStyles.titleHeader.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: AppColors.textWhite,
          letterSpacing: letterSpacing,
        ),
      ),
    );
  }
}
