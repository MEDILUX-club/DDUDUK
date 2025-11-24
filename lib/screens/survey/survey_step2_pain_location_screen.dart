import 'package:flutter/material.dart';
import 'package:dduduk_app/screens/survey/survey_step3_pain_level_screen.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';

class SurveyStep2PainLocationScreen extends StatelessWidget {
  const SurveyStep2PainLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fillDefault,
      appBar: AppBar(
        backgroundColor: AppColors.fillDefault,
        elevation: 0,
        title: const Text('Step 2 - 통증 부위', style: AppTextStyles.titleHeader),
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
                  'survey_step2_pain_location_screen.dart',
                  style: AppTextStyles.body14Regular,
                ),
                SizedBox(height: 8),
                Text(
                  'Step 2 - 통증 부위 선택 (바디맵)',
                  style: AppTextStyles.body14Regular,
                ),
              ],
            ),
            PrimaryButton(
              text: '다음: Step 3 통증 정도',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SurveyStep3PainLevelScreen(),
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
