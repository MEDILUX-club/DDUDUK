import 'package:flutter/material.dart';
import 'package:dduduk_app/layouts/default_layout.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';
import 'package:dduduk_app/widgets/common/step_badge.dart';
import 'package:dduduk_app/widgets/common/step_progress_bar.dart';
import 'package:dduduk_app/widgets/survey/pain_level_face.dart';

/// 운동 전 통증 정도 설문 화면 (고정 설문)
class ExerciseSurveyFixedScreen extends StatefulWidget {
  const ExerciseSurveyFixedScreen({
    super.key,
    this.onComplete,
  });

  /// 설문 완료 시 콜백 (통증 레벨 전달)
  final void Function(double painLevel)? onComplete;

  @override
  State<ExerciseSurveyFixedScreen> createState() =>
      _ExerciseSurveyFixedScreenState();
}

class _ExerciseSurveyFixedScreenState extends State<ExerciseSurveyFixedScreen> {
  double _painLevel = 10;

  String _getPainDescription() {
    if (_painLevel <= 0) return '전혀 아프지 않아요';
    if (_painLevel <= 2) return '살짝 불편해요';
    if (_painLevel <= 4) return '통증이 느껴지고 신경 쓰여요';
    if (_painLevel <= 6) return '일상 생활에 지장이 있을 정도로 아파요';
    if (_painLevel <= 8) return '많이 아프고 힘들어요';
    return '잠을 못 잘 정도로 아프고 고통스러워요';
  }

  void _onNextPressed() {
    widget.onComplete?.call(_painLevel);
    Navigator.of(context).pop(_painLevel);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '사전 설문',
      bottomNavigationBar: _buildBottomButton(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로그레스 바
          StepProgressBar(
            currentStep: 1,
            totalSteps: 1,
            horizontalBleed: AppDimens.screenPadding,
          ),
          const SizedBox(height: AppDimens.space24),

          // 스텝 배지
          const StepBadge(label: '통증 세부 정보'),
          const SizedBox(height: AppDimens.space12),

          // 타이틀 & 설명
          Text(
            '운동 전 현재 통증의 정도를 알려주세요',
            style: AppTextStyles.titleHeader,
          ),
          const SizedBox(height: AppDimens.space8),
          Text(
            '정확한 운동 프로그램을 위해 필요한 정보예요',
            style: AppTextStyles.body14Regular.copyWith(
              color: AppColors.textNeutral,
            ),
          ),

          // 콘텐츠 영역
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: AppDimens.space48),

                  // 얼굴 이미지
                  Center(
                    child: PainLevelFace(painLevel: _painLevel, size: 120),
                  ),
                  const SizedBox(height: AppDimens.space16),

                  // 점수 표시
                  Center(
                    child: Text(
                      '${_painLevel.toStringAsFixed(0)}/10',
                      style: AppTextStyles.body20Bold.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.space8),

                  // 통증 설명
                  Center(
                    child: Text(
                      _getPainDescription(),
                      style: AppTextStyles.body14Regular,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppDimens.space24),

                  // 슬라이더
                  PainLevelSlider(
                    value: _painLevel,
                    onChanged: (value) =>
                        setState(() => _painLevel = value as double),
                  ),
                  const SizedBox(height: AppDimens.space8),

                  // 슬라이더 라벨
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '통증없음 (0)',
                        style: AppTextStyles.body12Regular.copyWith(
                          color: AppColors.textDisabled,
                        ),
                      ),
                      Text(
                        '매우 심한 통증 (10)',
                        style: AppTextStyles.body12Regular.copyWith(
                          color: AppColors.textDisabled,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimens.space32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.screenPadding,
          AppDimens.space12,
          AppDimens.screenPadding,
          AppDimens.space16,
        ),
        child: SizedBox(
          height: AppDimens.buttonHeight,
          child: BaseButton(
            text: '다음으로',
            onPressed: _onNextPressed,
          ),
        ),
      ),
    );
  }
}
