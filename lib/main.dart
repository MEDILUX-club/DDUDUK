// lib/main.dart
import 'package:dduduk_app/screens/auth/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
//import 'package:dduduk_app/screens/auth/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dduduk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // 1. 배경색을 회색(fillDefault)으로 고정
        scaffoldBackgroundColor: AppColors.fillDefault,

        // 2. 앱의 "브랜드 컬러"를 초록색으로 지정 (이게 핵심!)
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary, // 버튼, 앱바 등이 이 색을 따라감
        ),

        // 3. 버튼의 기본 모양 지정 (모든 버튼에 적용됨)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary, // 버튼 배경 = 초록색
            foregroundColor: AppColors.textWhite, // 버튼 글자 = 흰색
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // 전역 폰트를 설정해 텍스트 위젯이 동일한 타이포를 사용
        fontFamily: AppTextStyles.fontFamily,

        useMaterial3: true,
      ),
      //home: const SplashScreen(),
      home: const OnboardingScreen(),
    );
  }
}
