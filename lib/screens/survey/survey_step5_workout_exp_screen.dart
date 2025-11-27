import 'package:flutter/material.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/screens/survey/survey_step6_preferred_time_screen.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/survey/lifestyle_option_card.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SurveyStep5WorkoutExpScreen extends StatefulWidget {
  const SurveyStep5WorkoutExpScreen({super.key});

  @override
  State<SurveyStep5WorkoutExpScreen> createState() =>
      _SurveyStep5WorkoutExpScreenState();
}

class _SurveyStep5WorkoutExpScreenState
    extends State<SurveyStep5WorkoutExpScreen> {
  double _experience = 0;
  String _selectedType = 'cardio';

  final Map<double, String> _experienceLabels = {
    0: '0',
    1: '3개월',
    2: '6개월',
    3: '12개월',
    4: '이상',
  };

  final List<Map<String, dynamic>> _types = [
    {
      'key': 'cardio',
      'title': '유산소 운동',
      'subtitle': '가볍게 걷거나 뛰는 걸 좋아해요',
      'imagePath': 'assets/images/img_emoji_walk.png',
    },
    {
      'key': 'strength',
      'title': '근력 운동',
      'subtitle': '근력 위주의 운동을 해요',
      'imagePath': 'assets/images/img_emoji_strength.png',
    },
    {
      'key': 'mixed',
      'title': '복합',
      'subtitle': '여러 가지 운동을 함께 해요',
      'imagePath': 'assets/images/img_emoji_mixed.png',
    },
    {
      'key': 'flexibility',
      'title': '유연성',
      'subtitle': '몸을 풀어주는 운동을 해요',
      'imagePath': 'assets/images/img_emoji_flexibility.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SurveyLayout(
      title: '평소 운동경험은 어떻게 되나요?',
      description: '어떤 운동을 선호하시는지 알려주세요',
      stepLabel: '5. 운동 경험',
      currentStep: 5,
      totalSteps: 6,
      bottomButtons: SurveyButtonsConfig(
        prevText: '이전으로',
        onPrev: () => Navigator.of(context).pop(),
        nextText: '다음으로',
        onNext: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const SurveyStep6PreferredTimeScreen(),
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
                  SfSliderTheme(
                    data: SfSliderThemeData(
                      activeTrackHeight: 12,
                      inactiveTrackHeight: 12,
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: AppColors.fillBoxDefault,
                      thumbColor: AppColors.primary,
                      overlayColor: AppColors.primaryLight.withValues(
                        alpha: 0.6,
                      ),
                      tooltipBackgroundColor: AppColors.primary,
                      tooltipTextStyle: AppTextStyles.body12Medium.copyWith(
                        color: AppColors.textWhite,
                      ),
                      activeTickColor: AppColors.primary,
                      inactiveTickColor: AppColors.primaryLight,
                      tickSize: const Size(4, 4),
                    ),
                    child: SfSlider(
                      min: 0.0,
                      max: 4.0,
                      interval: 1,
                      stepSize: 1,
                      value: _experience,
                      showTicks: true,
                      shouldAlwaysShowTooltip: true,
                      tooltipTextFormatterCallback:
                          (dynamic actualValue, String _) {
                            return _experienceLabels[actualValue] ?? '';
                          },
                      onChanged: (value) {
                        setState(() {
                          _experience = (value as double);
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: AppDimens.space8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _experienceLabels.entries
                        .map(
                          (e) => Text(
                            e.value,
                            style: AppTextStyles.body12Medium.copyWith(
                              color: AppColors.textNeutral,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: AppDimens.space32),
                  Text('운동 유형', style: AppTextStyles.titleText1),
                  const SizedBox(height: AppDimens.space12),
                  Column(
                    children: _types.map((type) {
                      final key = type['key'] as String;
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimens.space12,
                        ),
                        child: LifestyleOptionCard(
                          imagePath: type['imagePath'] as String,
                          title: type['title'] as String,
                          subtitle: type['subtitle'] as String,
                          selected: _selectedType == key,
                          onTap: () {
                            setState(() {
                              _selectedType = key;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
