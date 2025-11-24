import 'package:flutter/material.dart';
import 'package:dduduk_app/screens/survey/survey_step6_preferred_time_screen.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';

class SurveyStep5WorkoutExpScreen extends StatelessWidget {
  const SurveyStep5WorkoutExpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fillDefault,
      appBar: AppBar(
        backgroundColor: AppColors.fillDefault,
        elevation: 0,
        title: const Text('Step 5 - 운동 경험', style: AppTextStyles.titleHeader),
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
                  'survey_step5_workout_exp_screen.dart',
                  style: AppTextStyles.body14Regular,
                ),
                SizedBox(height: 8),
                Text('Step 5 - 운동 경험 및 횟수', style: AppTextStyles.body14Regular),
              ],
            ),
            PrimaryButton(
              text: '다음: Step 6 선호 시간대',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SurveyStep6PreferredTimeScreen(),
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
