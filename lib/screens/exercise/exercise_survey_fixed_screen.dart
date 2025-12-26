import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/widgets/survey/pain_level_face.dart';

/// 운동 전 통증 정도 설문 화면 (고정 설문)
class ExerciseSurveyFixedScreen extends StatefulWidget {
  const ExerciseSurveyFixedScreen({super.key, this.onComplete});

  /// 설문 완료 시 콜백 (통증 레벨 전달)
  final void Function(double painLevel)? onComplete;

  @override
  State<ExerciseSurveyFixedScreen> createState() =>
      _ExerciseSurveyFixedScreenState();
}

class _ExerciseSurveyFixedScreenState extends State<ExerciseSurveyFixedScreen> {
  double _painLevel = 10;

  void _onNextPressed() {
    widget.onComplete?.call(_painLevel);
    context.push('/exercise/fixed1');
  }

  @override
  Widget build(BuildContext context) {
    return SurveyLayout(
      appBarTitle: '컨디션 체크',
      showProgressBar: false,
      title: '운동 전 현재 통증의 정도를 알려주세요',
      description: '정확한 운동 프로그램을 위해 필요한 정보예요',
      stepLabel: '통증 세부 정보',
      currentStep: 1,
      totalSteps: 1,
      bottomButtons: SurveyButtonsConfig(
        nextText: '다음으로',
        onNext: _onNextPressed,
      ),
      child: SingleChildScrollView(
        child: PainLevelSelector(
          value: _painLevel,
          onChanged: (value) => setState(() => _painLevel = value as double),
        ),
      ),
    );
  }
}
