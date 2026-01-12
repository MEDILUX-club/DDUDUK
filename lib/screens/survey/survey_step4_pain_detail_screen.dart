import 'package:flutter/material.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/screens/survey/survey_step5_red_flags_screen.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/survey/pain_level_face.dart';
import 'package:dduduk_app/widgets/common/selectable_option_card.dart';

class SurveyStep4LifestyleScreen extends StatefulWidget {
  const SurveyStep4LifestyleScreen({
    super.key,
    this.readOnly = false,
    this.initialPainLevel,
    this.initialPainPattern,
    this.initialPainTriggers,
    this.initialPainDuration,
    this.isChangePart = false,
  });

  final bool readOnly;
  final double? initialPainLevel;
  final String? initialPainPattern;
  final Set<String>? initialPainTriggers;
  final String? initialPainDuration;
  final bool isChangePart;

  @override
  State<SurveyStep4LifestyleScreen> createState() =>
      _SurveyStep4LifestyleScreenState();
}

class _SurveyStep4LifestyleScreenState
    extends State<SurveyStep4LifestyleScreen> {
  double _painLevel = 0;
  String? _selectedPainPattern;
  late Set<String> _selectedPainTriggers;
  String? _selectedPainDuration;

  static const List<String> _painPatternOptions = [
    '걸리거나, 걸리적거리는 느낌이 있어요',
    '움직일수록 뻐근하고 뭉직한 느낌이 있어요',
    '무릎이 붓고, 만지면 뜨거워요',
    '놀랐을 때 콕 찌르는 듯이 아파요',
    '아침에 일어나면 뻣뻣해요',
  ];

  static const List<String> _painTriggerOptions = [
    '오래 걷거나 서있을 때',
    '계단 올라갈 때',
    '계단 내려갈 때',
    '쭈그려 앉을 때',
    '운동 후',
    '무릎을 비틀거나 회전할 때',
    '아침에 일어났을 때',
  ];

  static const List<String> _painDurationOptions = ['30분 미만', '30분 이상'];

  @override
  void initState() {
    super.initState();
    _painLevel = widget.initialPainLevel ?? 0;
    _selectedPainPattern = widget.initialPainPattern;
    _selectedPainTriggers = widget.initialPainTriggers ?? {};
    _selectedPainDuration = widget.initialPainDuration;
  }

  void _selectPainPattern(String value) {
    if (widget.readOnly) return;
    setState(() {
      _selectedPainPattern = value;
    });
  }

  void _togglePainTrigger(String value) {
    if (widget.readOnly) return;
    setState(() {
      if (_selectedPainTriggers.contains(value)) {
        _selectedPainTriggers.remove(value);
      } else {
        _selectedPainTriggers.add(value);
      }
    });
  }

  void _selectPainDuration(String value) {
    if (widget.readOnly) return;
    setState(() {
      _selectedPainDuration = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SurveyLayout(
      readOnly: widget.readOnly,
      title: '통증에 대한 세부 정보가 필요해요',
      description: '정확한 운동 프로그램을 위해 필요한 정보예요',
      stepLabel: '4. 통증 세부 정보',
      currentStep: 4,
      totalSteps: 6,
      bottomButtons: SurveyButtonsConfig(
        prevText: '이전으로',
        onPrev: () => Navigator.of(context).pop(),
        nextText: '다음으로',
        onNext: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SurveyStep5WorkoutExpScreen(
                readOnly: widget.readOnly,
                isChangePart: widget.isChangePart,
              ),
            ),
          );
        },
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 현재 무릎 통증의 정도 (항상 표시)
            const SizedBox(height: AppDimens.space16),
            Text(
              '1. 현재 무릎 통증의 정도를 알고 싶어요.',
              style: AppTextStyles.body18SemiBold,
            ),
            PainLevelSelector(
              value: _painLevel,
              onChanged: (value) =>
                  setState(() => _painLevel = value as double),
            ),
            // 2. 언제 통증이 더 심해지나요? (항상 표시)
            const SizedBox(height: AppDimens.space24),
            Text('2. 언제 통증이 더 심해지나요?', style: AppTextStyles.body18SemiBold),
            const SizedBox(height: AppDimens.space4),
            Text(
              '(중복선택 가능)',
              style: AppTextStyles.body12Regular.copyWith(
                color: AppColors.textDisabled,
              ),
            ),
            const SizedBox(height: AppDimens.space12),
            Wrap(
              spacing: AppDimens.space8,
              runSpacing: AppDimens.space8,
              children: _painTriggerOptions
                  .map(
                    (option) => _SelectableChip(
                      label: option,
                      selected: _selectedPainTriggers.contains(option),
                      onTap: () => _togglePainTrigger(option),
                    ),
                  )
                  .toList(),
            ),
            // 3. 통증 느낌이 어떤가요? (2번 선택 시 표시)
            if (_selectedPainTriggers.isNotEmpty) ...[
              const SizedBox(height: AppDimens.space24),
              Text('3. 통증 느낌이 어떤가요?', style: AppTextStyles.body18SemiBold),
              const SizedBox(height: AppDimens.space8),
              Text(
                '최근 자주 느끼는 통증 양상을 선택해주세요',
                style: AppTextStyles.body14Regular.copyWith(
                  color: AppColors.textNeutral,
                ),
              ),
              const SizedBox(height: AppDimens.space12),
              ..._painPatternOptions.asMap().entries.map((entry) {
                final index = entry.key;
                final text = entry.value;
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == _painPatternOptions.length - 1
                        ? 0
                        : AppDimens.space8,
                  ),
                  child: SelectableOptionCard(
                    text: text,
                    selected: _selectedPainPattern == text,
                    onTap: () => _selectPainPattern(text),
                    selectedTextColor: AppColors.primary,
                    unselectedBorderColor: AppColors.linePrimary,
                  ),
                );
              }),
            ],
            // 4. 통증이 얼마나 지속되나요? ("아침에 일어나면 뻣뻣해요" 선택 시 표시)
            if (_selectedPainPattern == '아침에 일어나면 뻣뻣해요') ...[
              const SizedBox(height: AppDimens.space24),
              Text('4. 통증이 얼마나 지속되나요?', style: AppTextStyles.body18SemiBold),
              const SizedBox(height: AppDimens.space12),
              Row(
                children: _painDurationOptions.map((option) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: option == _painDurationOptions.last
                            ? 0
                            : AppDimens.itemSpacing,
                      ),
                      child: SelectableOptionCard(
                        selected: _selectedPainDuration == option,
                        onTap: () => _selectPainDuration(option),
                        unselectedBorderColor: AppColors.linePrimary,
                        child: Center(
                          child: Text(
                            option,
                            style: AppTextStyles.body16Regular.copyWith(
                              color: _selectedPainDuration == option
                                  ? AppColors.primary
                                  : AppColors.textNormal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: AppDimens.space16),
          ],
        ),
      ),
    );
  }
}

class _SelectableChip extends StatelessWidget {
  const _SelectableChip({
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
        : AppColors.linePrimary;
    final Color backgroundColor = selected
        ? AppColors.primaryLight
        : AppColors.fillBoxDefault;
    final Color textColor = selected ? AppColors.primary : AppColors.textNormal;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.space12,
          vertical: AppDimens.space8,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          label,
          style: AppTextStyles.body14Regular.copyWith(color: textColor),
        ),
      ),
    );
  }
}
