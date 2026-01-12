import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dduduk_app/layouts/default_layout.dart';
import 'package:dduduk_app/screens/survey/survey_step1_basic_info_screen.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/providers/survey_provider.dart';

class SurveyIntroScreen extends ConsumerWidget {
  const SurveyIntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: '',
      backgroundColor: AppColors.fillDefault,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.space24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimens.space24),
              Text('셀프 설문을 시작합니다.', style: AppTextStyles.titleHeader),
              const SizedBox(height: AppDimens.space12),
              Text(
                '당신에게 꼭 맞는 운동 프로그램을 위해\n몇 가지 질문에 답해주세요',
                style: AppTextStyles.body14Regular.copyWith(
                  color: AppColors.textNeutral,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: AppDimens.space32),
              Center(
                child: SizedBox(
                  width: 240,
                  height: 240,
                  child: Stack(
                    children: const [
                      Positioned(
                        right: 36,
                        bottom: 36,
                        child: Image(
                          width: 186,
                          height: 186,
                          image: AssetImage(
                            'assets/images/img_bg_find_in_page.png',
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Image(
                          width: 186,
                          height: 186,
                          image: AssetImage(
                            'assets/images/img_fg_find_in_page.png',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.space32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimens.space20),
                decoration: BoxDecoration(
                  color: AppColors.fillBoxDefault,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow(
                      icon: Icons.access_time,
                      title: '소요시간',
                      description: '약 2-3분 내외로 완료할 수 있어요',
                    ),
                    const SizedBox(height: AppDimens.space16),
                    _InfoRow(
                      icon: Icons.add_task,
                      title: '맞춤형 분석',
                      description: '답변을 바탕으로 개인화된 운동 프로그램을 제공해요',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.space16),
              Row(
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 16,
                    color: AppColors.textAssistive,
                  ),
                  const SizedBox(width: AppDimens.space8),
                  Text(
                    '당신의 정보는 안전하게 보호됩니다',
                    style: AppTextStyles.body12Regular.copyWith(
                      color: AppColors.textAssistive,
                    ),
                  ),
                ],
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
                    // Reset survey data for new survey
                    ref.read(surveyProvider.notifier).reset();

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SurveyStep1BasicInfoScreen(),
                      ),
                    );
                  },
                  child: Text(
                    '시작하기',
                    style: AppTextStyles.body14Medium.copyWith(
                      color: AppColors.textWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: AppDimens.space12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body14Medium.copyWith(
                  color: AppColors.textNormal,
                ),
              ),
              const SizedBox(height: AppDimens.space4),
              Text(
                description,
                style: AppTextStyles.body14Regular.copyWith(
                  color: AppColors.textNeutral,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
