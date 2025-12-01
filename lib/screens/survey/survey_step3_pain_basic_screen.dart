import 'package:flutter/material.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/screens/survey/survey_step4_pain_detail_screen.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dduduk_app/widgets/survey/pain_since_options.dart';

class SurveyStep3PainLevelScreen extends StatefulWidget {
  const SurveyStep3PainLevelScreen({super.key});

  @override
  State<SurveyStep3PainLevelScreen> createState() =>
      _SurveyStep3PainLevelScreenState();
}

class _SurveyStep3PainLevelScreenState
    extends State<SurveyStep3PainLevelScreen> {
  String? _selectedKnee;
  final List<String> _selectedPainAreas = [];
  String? _painSince;

  final List<_KneePainArea> _kneePainAreas = const [
    _KneePainArea(label: '무릎 안쪽', iconPath: 'assets/icons/ic_knee_inside.svg'),
    _KneePainArea(
      label: '무릎 바깥쪽',
      iconPath: 'assets/icons/ic_knee_outside.svg',
    ),
    _KneePainArea(label: '무릎 앞쪽', iconPath: 'assets/icons/ic_knee_front.svg'),
  ];

  static const List<String> _painSinceOptions = [
    '원인 기억은 없는데 서서히 아파졌어요',
    '최근 활동이 많아서 심해졌어요',
    '넘어지거나 꺾이거나 부딪힌 뒤부터 아파요',
    '무리하게 운동한 후부터 아파요',
  ];

  void _selectKnee(String knee) {
    setState(() {
      _selectedKnee = knee;
    });
  }

  void _togglePainArea(String area) {
    setState(() {
      if (_selectedPainAreas.contains(area)) {
        _selectedPainAreas.remove(area);
        return;
      }
      if (_selectedPainAreas.length >= 2) return;
      _selectedPainAreas.add(area);
    });
  }

  void _selectPainSince(String value) {
    setState(() {
      _painSince = value;
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
                  const SizedBox(height: AppDimens.space12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '최대 2개 선택 가능',
                      style: AppTextStyles.body12Regular.copyWith(
                        color: AppColors.textDisabled,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.space12),
                  Column(
                    children: _kneePainAreas
                        .map(
                          (area) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppDimens.space8,
                            ),
                            child: _KneePainAreaCard(
                              label: area.label,
                              iconPath: area.iconPath,
                              selected: _selectedPainAreas.contains(area.label),
                              onTap: () => _togglePainArea(area.label),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: AppDimens.space24),
                  Text('Q2.', style: AppTextStyles.body14Medium),
                  const SizedBox(height: AppDimens.space6),
                  Text('언제부터 아팠어요?', style: AppTextStyles.body18SemiBold),
                  const SizedBox(height: AppDimens.space12),
                  PainSinceOptions(
                    selected: _painSince,
                    onSelect: _selectPainSince,
                    options: _painSinceOptions,
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

class _KneePainArea {
  const _KneePainArea({required this.label, required this.iconPath});

  final String label;
  final String iconPath;
}

class _KneePainAreaCard extends StatelessWidget {
  const _KneePainAreaCard({
    required this.label,
    required this.iconPath,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String iconPath;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color borderColor = selected
        ? AppColors.primary
        : AppColors.linePrimary;
    final Color backgroundColor = selected
        ? AppColors.primaryLight
        : AppColors.fillBoxDefault;
    final Color textColor = selected ? AppColors.primary : AppColors.textNormal;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.space12,
          vertical: AppDimens.space12,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: AppDimens.space48,
              height: AppDimens.space48,
            ),
            const SizedBox(width: AppDimens.space12),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body16Regular.copyWith(color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
