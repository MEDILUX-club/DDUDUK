import 'package:flutter/material.dart';
import 'package:dduduk_app/layouts/default_layout.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';

class SurveyCompletionScreen extends StatelessWidget {
  const SurveyCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '셀프 설문',
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimens.space24,
          horizontal: AppDimens.space16,
        ),
        child: Column(
          children: [
            Text(
              '셀프설문이 완료되었습니다',
              style: AppTextStyles.titleHeader,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.space12),
            Text(
              '고객님의 응답을 분석하여\n맞춤 운동을 제공해 드릴게요.',
              style: AppTextStyles.body14Regular.copyWith(
                color: AppColors.textAssistive,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            const Icon(
              Icons.check_circle_rounded,
              size: 100,
              color: AppColors.primary,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: AppDimens.buttonHeight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const MainLayout()),
                    (route) => false,
                  );
                },
                child: Text(
                  '확인',
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

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder main layout. Replace with your actual home UI.
    return const Scaffold(body: Center(child: Text('Main Layout')));
  }
}
