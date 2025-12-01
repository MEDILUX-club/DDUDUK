import 'package:flutter/material.dart';
import 'package:dduduk_app/layouts/default_layout.dart';
import 'package:dduduk_app/screens/survey/survey_completion_screen.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum SurveyResultType { inflammation, degeneration, trauma, overuse }

class _SurveyResultData {
  const _SurveyResultData({
    required this.code,
    required this.title,
    required this.description,
    required this.tags,
  });

  final String code;
  final String title;
  final String description;
  final List<String> tags;
}

const Map<SurveyResultType, _SurveyResultData> _resultData = {
  SurveyResultType.inflammation: _SurveyResultData(
    code: 'INF',
    title: '염증형',
    description:
        '염증 반응으로 관절이 붓고 아픈 유형이에요.\n아침에 관절이 굳는 느낌이 강할 수 있고,\n양쪽에 통증이 나타날 수 있어요.\n급성기엔 무리한 운동을 피하고, 염증이 가라앉은 뒤\n가벼운 강화 운동부터 시작하면 좋아요.',
    tags: ['염증 반응', '아침 강직', '가벼운 강화 운동'],
  ),
  SurveyResultType.degeneration: _SurveyResultData(
    code: 'OA',
    title: '퇴행성형',
    description:
        '나이가 들거나 무릎을 오래 써서 연골이\n약해지는 유형이에요.계단 오르거나\n오래 걷기에서 통증과 뻣뻣함이 잘 나타나고,\n가벼운 근력 운동과 관절 가동성 운동이 도움이 돼요',
    tags: ['연골 약화', '계단·보행 시 통증', '근력·가동성 운동'],
  ),
  SurveyResultType.trauma: _SurveyResultData(
    code: 'TRM',
    title: '외상형',
    description:
        '넘어짐이나 비틀림,충격 같은 순간적인\n부상으로 생기는 유형이에요.\n인대나 연골 손상으로 붓기와 급성 통증이 나타나고,\n초반엔 통증·부종 관리가,\n이후엔 가동성 회복과 근력 강화가 필요해요.',
    tags: ['연골 약화', '붓기·급성통증', '근력 강화'],
  ),
  SurveyResultType.overuse: _SurveyResultData(
    code: 'OVR',
    title: '과사용형',
    description:
        '같은 동작을 반복하거나 운동량이\n갑자기 늘면서 통증이 생기는 유형이에요\n앞무릎 통증과 근육 불균형이 흔하고,\n엉덩이·허벅지 근육 균형을 잡아주는 운동이 중요해요',
    tags: ['운동량 증가', '앞무릎 통증', '근육 불균형 교정'],
  ),
};

class SurveyStep6ResultScreen extends StatelessWidget {
  const SurveyStep6ResultScreen({
    super.key,
    this.resultType = SurveyResultType.degeneration,
  });

  final SurveyResultType resultType;

  @override
  Widget build(BuildContext context) {
    final _SurveyResultData data = _resultData[resultType]!;
    const int probability = 72;

    return DefaultLayout(
      title: '설문 결과',
      backgroundColor: AppColors.fillDefault,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.space16),
          child: SizedBox(
            height: AppDimens.buttonHeight,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SurveyCompletionScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                '다음으로',
                style: AppTextStyles.body14Medium.copyWith(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimens.space24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ResultCard(data: data, probability: probability),
              const SizedBox(height: AppDimens.space20),
              const _CautionSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.data, required this.probability});

  final _SurveyResultData data;
  final int probability;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fillBoxDefault,
        borderRadius: BorderRadius.circular(AppDimens.space24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.space20,
        vertical: AppDimens.space24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _Badge(code: data.code),
          const SizedBox(height: AppDimens.space20),
          _ResultHeadline(data: data, probability: probability),
          const SizedBox(height: AppDimens.space16),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.body14Regular.copyWith(
              color: AppColors.textNeutral,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppDimens.space20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppDimens.space10,
            runSpacing: AppDimens.space10,
            children: data.tags
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.space14,
                      vertical: AppDimens.space8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      tag,
                      style: AppTextStyles.body12Medium.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryLight,
        border: Border.all(color: AppColors.primary, width: 5),
      ),
      alignment: Alignment.center,
      child: Text(
        code,
        style: AppTextStyles.titleText1.copyWith(
          fontSize: 60,
          fontWeight: FontWeight.w800,
          color: AppColors.textStrong,
        ),
      ),
    );
  }
}

class _ResultHeadline extends StatelessWidget {
  const _ResultHeadline({required this.data, required this.probability});

  final _SurveyResultData data;
  final int probability;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTextStyles.titleText1.copyWith(color: AppColors.textStrong),
        children: [
          TextSpan(text: '당신은 $probability% 확률로\n'),
          TextSpan(
            text: data.title,
            style: AppTextStyles.titleText1.copyWith(color: AppColors.primary),
          ),
          const TextSpan(text: ' 유형에 속해요!'),
        ],
      ),
    );
  }
}

class _CautionSection extends StatelessWidget {
  const _CautionSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/ic_alert.svg',
              width: AppDimens.space20,
              height: AppDimens.space20,
            ),
            const SizedBox(width: AppDimens.space6),
            Text(
              '주의사항',
              style: AppTextStyles.body16Regular.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.statusDestructive,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.space8),
        Text(
          '본 결과는 AI 기반 예측으로 참고용이며, 실제 의료 진단을 대체할 수 없습니다. 통증이 심하거나 일상생활에 지장이 있는 경우 반드시 의료기관을 방문하여 정확한 진단과 치료를 받으시기 바랍니다.',
          style: AppTextStyles.body14Regular.copyWith(
            color: AppColors.textNeutral,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
