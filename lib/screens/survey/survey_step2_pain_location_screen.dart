import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/screens/survey/survey_step3_pain_basic_screen.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/widgets/survey/pain_location_card.dart';
import 'package:dduduk_app/providers/survey_provider.dart';

class SurveyStep2PainLocationScreen extends ConsumerStatefulWidget {
  const SurveyStep2PainLocationScreen({
    super.key,
    this.readOnly = false,
    this.initialSelectedParts,
    this.isChangePart = false,
  });

  final bool readOnly;
  final Set<String>? initialSelectedParts;
  final bool isChangePart;

  @override
  ConsumerState<SurveyStep2PainLocationScreen> createState() =>
      _SurveyStep2PainLocationScreenState();
}

class _SurveyStep2PainLocationScreenState
    extends ConsumerState<SurveyStep2PainLocationScreen> {
  late Set<String> selectedParts;

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

  @override
  void initState() {
    super.initState();
    selectedParts = widget.initialSelectedParts ?? {};
  }

  void _togglePart(String label) {
    if (widget.readOnly) return;
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
      readOnly: widget.readOnly,
      title: '어디가 아프신가요?',
      description: '통증이 있는 부위를 모두 선택해주세요.',
      stepLabel: '2. 통증부위',
      currentStep: 2,
      totalSteps: 6,
      bottomButtons: SurveyButtonsConfig(
        prevText: '이전으로',
        onPrev: () => Navigator.of(context).pop(),
        nextText: '다음으로',
        onNext: () {
          // Save to provider
          if (selectedParts.isNotEmpty) {
            ref.read(surveyProvider.notifier).updatePainArea(selectedParts.first);
          }

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SurveyStep3PainLevelScreen(
                readOnly: widget.readOnly,
                isChangePart: widget.isChangePart,
              ),
            ),
          );
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimens.space16),
          Flexible(
            child: GridView.builder(
              itemCount: _parts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppDimens.itemSpacing,
                crossAxisSpacing: AppDimens.itemSpacing,
                childAspectRatio: 1.6,
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
