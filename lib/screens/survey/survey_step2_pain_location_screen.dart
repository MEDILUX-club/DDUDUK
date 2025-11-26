import 'package:flutter/material.dart';
import 'package:dduduk_app/layouts/default_layout.dart';
import 'package:dduduk_app/screens/survey/survey_step3_pain_level_screen.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';
import 'package:dduduk_app/widgets/survey/pain_location_card.dart';
import 'package:dduduk_app/widgets/common/step_badge.dart';
import 'package:dduduk_app/widgets/common/step_progress_bar.dart';

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
    return DefaultLayout(
      title: '통증부위',
      child: Column(
        children: [
          const SizedBox(height: AppDimens.space16),
          const StepProgressBar(
            currentStep: 2,
            totalSteps: 3,
            horizontalBleed: AppDimens.screenPadding,
          ),
          const SizedBox(height: AppDimens.space24),
          const StepBadge(label: '2. 통증부위'),
          const SizedBox(height: AppDimens.space12),
          Column(
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
            ],
          ),
          const SizedBox(height: AppDimens.space24),
          Expanded(
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
          const SizedBox(height: AppDimens.space16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: AppDimens.buttonHeight,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.linePrimary),
                      backgroundColor: AppColors.fillBoxDefault,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      foregroundColor: AppColors.textNormal,
                    ),
                    child: Text('이전으로', style: AppTextStyles.body14Medium),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.itemSpacing),
              Expanded(
                child: BaseButton(
                  text: '다음으로',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SurveyStep3PainLevelScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.space16),
        ],
      ),
    );
  }
}
