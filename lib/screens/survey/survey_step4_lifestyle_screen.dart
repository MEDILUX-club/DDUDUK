import 'package:flutter/material.dart';
import 'package:dduduk_app/layouts/default_layout.dart';
import 'package:dduduk_app/screens/survey/survey_step5_workout_exp_screen.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';

class SurveyStep4LifestyleScreen extends StatelessWidget {
  const SurveyStep4LifestyleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'Step 4 - 생활 패턴',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'survey_step4_lifestyle_screen.dart',
                style: AppTextStyles.body14Regular,
              ),
              SizedBox(height: 8),
              Text(
                'Step 4 - 수면 시간 및 생활 패턴',
                style: AppTextStyles.body14Regular,
              ),
            ],
          ),
          PrimaryButton(
            text: '다음: Step 5 운동 경험',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SurveyStep5WorkoutExpScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
