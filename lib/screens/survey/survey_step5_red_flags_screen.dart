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
    '지금 걷기 어려울 정도로 심한 통증이 있어요',
    '무릎이 갑자기 많이 붓고 만지면 뜨거워요',
    '무릎이 붓고, 만지면 뜨거워요',
    '무릎을 움직일 때 평소보다 잘 안 움직여요',
    '무릎 힘이 빠지거나 다리 감각이 둔해져요',
    '다리가 전체적으로 저리거나\n허리에서 다리로 뻗치는 느낌이 있어요',
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
          '다음은 중요한 위험신호예요\n'
          '해당사항이 있나요?',
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
