import 'package:flutter/material.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/screens/survey/survey_step3_pain_level_screen.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/survey/pain_location_card.dart';

class SurveyStep2PainLocationScreen extends StatefulWidget {
  const SurveyStep2PainLocationScreen({super.key});

  @override
  State<SurveyStep2PainLocationScreen> createState() =>
      _SurveyStep2PainLocationScreenState();
}

class _SurveyStep2PainLocationScreenState
    extends State<SurveyStep2PainLocationScreen> {
  final Set<String> selectedParts = {};

  final List<Map<String, String>> _parts = [
    {'label': '목', 'iconPath': 'assets/icons/ic_neck.svg'},
    {'label': '팔꿈치', 'iconPath': 'assets/icons/ic_elbow.svg'},
    {'label': '어깨', 'iconPath': 'assets/icons/ic_shoulder.svg'},
    {'label': '손목', 'iconPath': 'assets/icons/ic_wrist.svg'},
    {'label': '허리', 'iconPath': 'assets/icons/ic_waist.svg'},
    {'label': '고관절', 'iconPath': 'assets/icons/ic_hip_joint.svg'},
    {'label': '무릎', 'iconPath': 'assets/icons/ic_knee.svg'},
    {'label': '발목', 'iconPath': 'assets/icons/ic_ankle.svg'},
  ];

  void _togglePart(String label) {
    setState(() {
      if (selectedParts.contains(label)) {
        selectedParts.clear();
      } else {
        selectedParts
          ..clear()
          ..add(label);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SurveyLayout(
      title: '통증부위',
      stepLabel: '2. 통증부위',
      currentStep: 2,
      totalSteps: 6,
      bottomButtons: SurveyButtonsConfig(
        prevText: '이전으로',
        onPrev: () => Navigator.of(context).pop(),
        nextText: '다음으로',
        onNext: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const SurveyStep3PainLevelScreen(),
            ),
          );
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('어디가 아프신가요?', style: AppTextStyles.titleText1),
          const SizedBox(height: AppDimens.space8),
          Text(
            '통증이 있는 부위를 모두 선택해주세요.',
            style: AppTextStyles.body14Regular.copyWith(
              color: AppColors.textNeutral,
            ),
          ),
          const SizedBox(height: AppDimens.space24),
          Flexible(
            child: GridView.builder(
              itemCount: _parts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppDimens.itemSpacing,
                crossAxisSpacing: AppDimens.itemSpacing,
                childAspectRatio: 1.3,
              ),
              itemBuilder: (_, index) {
                final item = _parts[index];
                final String label = item['label'] as String;
                final String iconPath = item['iconPath'] as String;
                final bool isSelected = selectedParts.contains(label);
                return PainLocationCard(
                  label: label,
                  iconPath: iconPath,
                  isSelected: isSelected,
                  onTap: () => _togglePart(label),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
