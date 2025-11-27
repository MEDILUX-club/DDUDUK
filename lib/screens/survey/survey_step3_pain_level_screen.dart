import 'package:flutter/material.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/screens/survey/survey_step4_lifestyle_screen.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/survey/survey_value_slider.dart';

class SurveyStep3PainLevelScreen extends StatefulWidget {
  const SurveyStep3PainLevelScreen({super.key});

  @override
  State<SurveyStep3PainLevelScreen> createState() =>
      _SurveyStep3PainLevelScreenState();
}

class _SurveyStep3PainLevelScreenState
    extends State<SurveyStep3PainLevelScreen> {
  double _painLevel = 0;
  String _selectedKnee = '왼쪽';

  final Map<double, String> _painLabels = {
    0.0: '0',
    2.0: '2',
    4.0: '4',
    6.0: '6',
    8.0: '8',
    10.0: '10',
  };

  String _painText(double painValue) {
    if (painValue <= 0) return '아프지 않음';
    if (painValue <= 4) return '약함';
    if (painValue <= 8) return '아픔';
    return '매우 아픔';
  }

  void _selectKnee(String knee) {
    setState(() {
      _selectedKnee = knee;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SurveyLayout(
      title: '통증 정보를 알려주세요',
      description: '정확한 운동 프로그램을 위해 필요해요',
      stepLabel: '3. 통증 기본 정보',
      currentStep: 3,
      totalSteps: 6,
      bottomButtons: SurveyButtonsConfig(
        prevText: '이전으로',
        onPrev: () => Navigator.of(context).pop(),
        nextText: '다음으로',
        onNext: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const SurveyStep4LifestyleScreen(),
            ),
          );
        },
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimens.space16),
                  Text('Q1.', style: AppTextStyles.body14Medium),
                  const SizedBox(height: AppDimens.space6),
                  Text('어느 쪽 무릎이 아프신가요?', style: AppTextStyles.body18SemiBold),
                  const SizedBox(height: AppDimens.space12),
                  Row(
                    children: [
                      _KneeOption(
                        label: '왼쪽',
                        selected: _selectedKnee == '왼쪽',
                        onTap: () => _selectKnee('왼쪽'),
                      ),
                      const SizedBox(width: AppDimens.itemSpacing),
                      _KneeOption(
                        label: '오른쪽',
                        selected: _selectedKnee == '오른쪽',
                        onTap: () => _selectKnee('오른쪽'),
                      ),
                      const SizedBox(width: AppDimens.itemSpacing),
                      _KneeOption(
                        label: '모두',
                        selected: _selectedKnee == '모두',
                        onTap: () => _selectKnee('모두'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.space24),
                  Text('Q2.', style: AppTextStyles.body14Medium),
                  const SizedBox(height: AppDimens.space6),
                  Text(
                    '현재 무릎 통증 정도를 선택해주세요',
                    style: AppTextStyles.body18SemiBold,
                  ),
                  const SizedBox(height: AppDimens.space16),
                  SurveyValueSlider(
                    value: _painLevel,
                    min: 0,
                    max: 10,
                    interval: 2,
                    stepSize: 1,
                    labels: _painLabels,
                    bubbleTextBuilder: _painText,
                    onChanged: (double newValue) {
                      setState(() {
                        _painLevel = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: AppDimens.space16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KneeOption extends StatelessWidget {
  const _KneeOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color borderColor = selected
        ? AppColors.primary
        : AppColors.lineNeutral;
    final Color backgroundColor = selected
        ? AppColors.primaryLight
        : AppColors.fillBoxDefault;
    final Color textColor = selected ? AppColors.primary : AppColors.textNormal;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppDimens.space12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.body14Medium.copyWith(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
