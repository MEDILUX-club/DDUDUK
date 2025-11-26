import 'package:flutter/material.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/screens/survey/survey_completion_screen.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/survey/simple_selection_card.dart';

class SurveyStep6PreferredTimeScreen extends StatefulWidget {
  const SurveyStep6PreferredTimeScreen({super.key});

  @override
  State<SurveyStep6PreferredTimeScreen> createState() =>
      _SurveyStep6PreferredTimeScreenState();
}

class _SurveyStep6PreferredTimeScreenState
    extends State<SurveyStep6PreferredTimeScreen> {
  String _selectedDuration = '10분';
  String _selectedFrequency = '주 1-2회';

  final List<Map<String, String?>> _durations = const [
    {'title': '10분', 'subtitle': '짧고 간단하게 운동해요'},
    {'title': '20분', 'subtitle': '편하게 할 수 있는 운동량이에요'},
    {'title': '30분', 'subtitle': '여유 있게 충분히 운동해요'},
    {'title': '30분 이상', 'subtitle': '집중 운동'},
  ];

  final List<Map<String, String?>> _frequencies = const [
    {'title': '주 1-2회', 'subtitle': null},
    {'title': '주 3-5회', 'subtitle': null},
    {'title': '주 6-7회', 'subtitle': null},
  ];

  @override
  Widget build(BuildContext context) {
    return SurveyLayout(
      title: '운동 선호시간',
      stepLabel: '6. 운동 선호시간',
      currentStep: 6,
      totalSteps: 6,
      bottomButtons: SurveyButtonsConfig(
        prevText: '이전으로',
        onPrev: () => Navigator.of(context).pop(),
        nextText: '다음으로',
        onNext: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SurveyCompletionScreen()),
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
                  const SizedBox(height: AppDimens.space24),
                  Text('하루에 운동할 시간을 정해주세요', style: AppTextStyles.titleText1),
                  const SizedBox(height: AppDimens.space8),
                  Text(
                    '현재 설정한 시간은 설정에서 변경이 가능해요',
                    style: AppTextStyles.body14Regular.copyWith(
                      color: AppColors.textNeutral,
                    ),
                  ),
                  const SizedBox(height: AppDimens.space24),
                  Text('운동 시간', style: AppTextStyles.body14Medium),
                  const SizedBox(height: AppDimens.space12),
                  Column(
                    children: _durations.map((item) {
                      final String title = item['title']!;
                      final String? subtitle = item['subtitle'];
                      final bool selected = _selectedDuration == title;
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimens.space12,
                        ),
                        child: SimpleSelectionCard(
                          title: title,
                          subtitle: subtitle,
                          isSelected: selected,
                          onTap: () {
                            setState(() {
                              _selectedDuration = title;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppDimens.space24),
                  Text('운동빈도', style: AppTextStyles.body14Medium),
                  const SizedBox(height: AppDimens.space12),
                  Column(
                    children: _frequencies.map((item) {
                      final String title = item['title']!;
                      final bool selected = _selectedFrequency == title;
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimens.space12,
                        ),
                        child: SimpleSelectionCard(
                          title: title,
                          subtitle: item['subtitle'],
                          isSelected: selected,
                          onTap: () {
                            setState(() {
                              _selectedFrequency = title;
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
