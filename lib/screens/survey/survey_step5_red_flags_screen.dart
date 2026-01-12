import 'package:flutter/material.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/screens/survey/survey_step6_result_screen.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/widgets/survey/alert_modal.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/widgets/common/selectable_option_card.dart';

class SurveyStep5WorkoutExpScreen extends StatefulWidget {
  const SurveyStep5WorkoutExpScreen({
    super.key,
    this.readOnly = false,
    this.initialRisk,
    this.isChangePart = false,
  });

  final bool readOnly;
  final String? initialRisk;
  final bool isChangePart;

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

  @override
  void initState() {
    super.initState();
    _selectedRisk = widget.initialRisk;
  }

  Future<void> _showRiskAlert(String value) async {
    if (widget.readOnly) return;
    setState(() => _selectedRisk = value);
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertModal(onConfirm: () => Navigator.of(context).pop()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool shouldPopToMypage = widget.readOnly || widget.isChangePart;
    final String nextButtonText = shouldPopToMypage ? '닫기' : '다음으로';
    
    return SurveyLayout(
      readOnly: widget.readOnly,
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
        nextText: nextButtonText,
        onNext: () {
          if (shouldPopToMypage) {
            // Pop all survey screens back to mypage
            int count = 0;
            Navigator.of(context).popUntil((_) => count++ >= (widget.isChangePart ? 4 : 5));
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SurveyStep6ResultScreen()),
            );
          }
        },
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimens.space2),
            ..._riskOptions.asMap().entries.map((entry) {
              final index = entry.key;
              final text = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == _riskOptions.length - 1
                      ? AppDimens.space4
                      : AppDimens.space8,
                ),
                child: SelectableOptionCard(
                  text: text,
                  selected: _selectedRisk == text,
                  onTap: () => _showRiskAlert(text),
                  selectedTextColor: AppColors.primary,
                  unselectedBorderColor: AppColors.linePrimary,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
