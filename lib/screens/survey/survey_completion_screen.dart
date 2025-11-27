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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '셀프설문이 완료되었습니다',
                      style: AppTextStyles.titleHeader,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimens.space12),
                    Text(
                      '답변을 바탕으로 맞춤 운동을 제공해드릴게요',
                      style: AppTextStyles.body14Regular.copyWith(
                        color: AppColors.textAssistive,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimens.space48),
                    SizedBox(
                      width: 170,
                      height: 170,
                      child: Stack(
                        children: const [
                          Positioned(
                            right: 26,
                            bottom: 26,
                            child: Image(
                              width: 132,
                              height: 132,
                              image: AssetImage(
                                'assets/images/img_bg_assignment_turned_in.png',
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Image(
                              width: 132,
                              height: 132,
                              image: AssetImage(
                                'assets/images/img_fg_assignment_turned_in.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimens.space32),
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
                  Navigator.of(context).pop();
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
