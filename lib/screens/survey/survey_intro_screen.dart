import 'package:flutter/material.dart';
import 'package:dduduk_app/layouts/default_layout.dart';
import 'package:dduduk_app/screens/survey/survey_step1_basic_info_screen.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';

class SurveyIntroScreen extends StatelessWidget {
  const SurveyIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'Survey Intro',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'survey_intro_screen.dart',
                style: AppTextStyles.body14Regular,
              ),
              SizedBox(height: 8),
              Text('설문 시작 안내 화면', style: AppTextStyles.body14Regular),
            ],
          ),
          PrimaryButton(
            text: '다음: Step 1 기본정보',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SurveyStep1BasicInfoScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
