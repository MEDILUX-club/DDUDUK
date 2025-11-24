import 'package:flutter/material.dart';
import 'package:dduduk_app/screens/auth/sign_in_screen.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fillDefault,
      appBar: AppBar(
        backgroundColor: AppColors.fillDefault,
        elevation: 0,
        title: const Text('Onboarding', style: AppTextStyles.titleHeader),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'onboarding_screen.dart',
                  style: AppTextStyles.body14Regular,
                ),
                SizedBox(height: 8),
                Text('앱 소개 슬라이드 화면', style: AppTextStyles.body14Regular),
              ],
            ),
            PrimaryButton(
              text: '다음: 로그인',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SignInScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
