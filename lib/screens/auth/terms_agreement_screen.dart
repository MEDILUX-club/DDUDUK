import 'package:flutter/material.dart';
import 'package:dduduk_app/screens/survey/survey_intro_screen.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';

class TermsAgreementScreen extends StatelessWidget {
  const TermsAgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fillDefault,
      appBar: AppBar(
        backgroundColor: AppColors.fillDefault,
        elevation: 0,
        title: const Text('Terms of Service', style: AppTextStyles.titleHeader),
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
                  'terms_agreement_screen.dart',
                  style: AppTextStyles.body14Regular,
                ),
                SizedBox(height: 8),
                Text('서비스 이용 약관 동의 화면', style: AppTextStyles.body14Regular),
              ],
            ),
            PrimaryButton(
              text: '다음: 설문 안내',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SurveyIntroScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
