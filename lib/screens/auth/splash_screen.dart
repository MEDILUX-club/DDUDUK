import 'package:flutter/material.dart';
import 'package:dduduk_app/screens/auth/onboarding_screen.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fillDefault,
      appBar: AppBar(
        backgroundColor: AppColors.fillDefault,
        elevation: 0,
        title: const Text('Splash', style: AppTextStyles.titleHeader),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('splash_screen.dart', style: AppTextStyles.body14Regular),
                SizedBox(height: 8),
                Text('앱 시작 로고 화면', style: AppTextStyles.body14Regular),
              ],
            ),
            PrimaryButton(
              text: '다음: 온보딩',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
