import 'package:flutter/material.dart';
import 'package:dduduk_app/layouts/default_layout.dart';
import 'package:dduduk_app/screens/survey/survey_step6_preferred_time_screen.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/buttons/button_group.dart';
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
  String _selectedFrequency = '주 1-2회';

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
      'icon': Icons.directions_run,
    },
    {
      'key': 'strength',
      'title': '근력 운동',
      'subtitle': '근력 위주로 운동해요',
      'icon': Icons.fitness_center,
    },
    {
      'key': 'mixed',
      'title': '혼합',
      'subtitle': '다양한 운동을 섞어서 해요',
      'icon': Icons.diversity_3,
    },
    {
      'key': 'flexibility',
      'title': '유연성',
      'subtitle': '몸을 풀어주는 운동을 해요',
      'icon': Icons.self_improvement,
    },
  ];

  final List<String> _frequencies = const ['주 1-2회', '주 3-5회', '주 6-7회'];

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '운동 경험',
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimens.space24),
                  Text('평소 운동경험은 어떻게 되나요?', style: AppTextStyles.titleText1),
                  const SizedBox(height: AppDimens.space8),
                  Text(
                    '어떤 운동이 적합할지 알려주세요',
                    style: AppTextStyles.body14Regular.copyWith(
                      color: AppColors.textNeutral,
                    ),
                  ),
                  const SizedBox(height: AppDimens.space20),
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
                          icon: type['icon'] as IconData,
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
                  const SizedBox(height: AppDimens.space20),
                  Text('운동 빈도', style: AppTextStyles.titleText1),
                  const SizedBox(height: AppDimens.space12),
                  Column(
                    children: _frequencies.map((freq) {
                      final bool selected = _selectedFrequency == freq;
                      final Color borderColor = selected
                          ? AppColors.primary
                          : AppColors.lineNeutral;
                      final Color iconColor = selected
                          ? AppColors.primary
                          : AppColors.textNeutral;
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimens.space12,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            setState(() {
                              _selectedFrequency = freq;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppDimens.space14,
                              horizontal: AppDimens.space16,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.fillBoxDefault,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    freq,
                                    style: AppTextStyles.body14Medium.copyWith(
                                      color: AppColors.textNormal,
                                    ),
                                  ),
                                ),
                                Icon(
                                  selected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: iconColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.space12),
          ButtonGroup(
            subText: '이전으로',
            mainText: '다음으로',
            onSubPressed: () => Navigator.of(context).pop(),
            onMainPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SurveyStep6PreferredTimeScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: AppDimens.space16),
        ],
      ),
    );
  }
}
