import 'package:flutter/material.dart';
import 'package:dduduk_app/screens/survey/survey_step4_lifestyle_screen.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';

class SurveyStep3PainLevelScreen extends StatelessWidget {
  const SurveyStep3PainLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fillDefault,
      appBar: AppBar(
        backgroundColor: AppColors.fillDefault,
        elevation: 0,
        title: const Text('Step 3 - 통증 정도', style: AppTextStyles.titleHeader),
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
                  'survey_step3_pain_level_screen.dart',
                  style: AppTextStyles.body14Regular,
                ),
                SizedBox(height: 8),
                Text(
                  'Step 3 - 통증 정도 슬라이더 및 기본 질문',
                  style: AppTextStyles.body14Regular,
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SurveyStep4LifestyleScreen(),
                    ),
                  );
                },
                child: Text(
                  '다음: Step 4 생활 패턴',
                  style: AppTextStyles.body14Medium.copyWith(
                    color: AppColors.textWhite,
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
