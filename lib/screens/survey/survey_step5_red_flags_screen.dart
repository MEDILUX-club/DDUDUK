import 'package:flutter/material.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/screens/survey/survey_step6_result_screen.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/widgets/survey/alert_modal.dart';
import 'package:dduduk_app/widgets/survey/pain_since_options.dart';

class SurveyStep5WorkoutExpScreen extends StatefulWidget {
  const SurveyStep5WorkoutExpScreen({super.key});

  @override
  State<SurveyStep5WorkoutExpScreen> createState() =>
      _SurveyStep5WorkoutExpScreenState();
}

class _SurveyStep5WorkoutExpScreenState
    extends State<SurveyStep5WorkoutExpScreen> {
  String? _selectedRisk;

  static const List<String> _riskOptions = [
    '해당 사항 없음',
    '최근 사고나 낙상 이후 통증이 있어요',
    '수술 후 통증이나 증상이 악화됐어요',
    '수술 이후, 통증이 심해졌어요',
    '걷기나 일상생활이 어려울 정도로 약해요',
    '통증이 심해지거나 다른 부위로 번져요.',
    '마비·저림 같은 신경 증상이 자주 있어요',
    '다른 전신 질환을 알고 있거나\n복용 중인 약물이 있어요',
  ];

  Future<void> _showRiskAlert(String value) async {
    setState(() => _selectedRisk = value);
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertModal(onConfirm: () => Navigator.of(context).pop()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SurveyLayout(
      title:
          '위험 신호에 해당하는 항목이 있나요?\n'
          '다음 중 해당하는 항목을 선택해 주세요.',
      description: '',
      stepLabel: '5. 위험 신호',
      currentStep: 5,
      totalSteps: 6,
      bottomButtons: SurveyButtonsConfig(
        prevText: '이전으로',
        onPrev: () => Navigator.of(context).pop(),
        nextText: '다음으로',
        onNext: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SurveyStep6ResultScreen()),
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
                  const SizedBox(height: AppDimens.space10),
                  PainSinceOptions(
                    selected: _selectedRisk,
                    onSelect: _showRiskAlert,
                    options: _riskOptions,
                    trailingSpacing: AppDimens.space4,
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
