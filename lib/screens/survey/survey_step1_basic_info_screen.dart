import 'package:flutter/material.dart';
import 'package:dduduk_app/layouts/default_layout.dart';
import 'package:dduduk_app/screens/survey/survey_step2_pain_location_screen.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';

class SurveyStep1BasicInfoScreen extends StatelessWidget {
  const SurveyStep1BasicInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'Step 1 - 기본정보',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'survey_step1_basic_info_screen.dart',
                style: AppTextStyles.body14Regular,
              ),
              SizedBox(height: 8),
              Text(
                'Step 1 - 생년월일, 키, 몸무게 입력',
                style: AppTextStyles.body14Regular,
              ),
            ],
          ),
          PrimaryButton(
            text: '다음: Step 2 통증 부위',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SurveyStep2PainLocationScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
