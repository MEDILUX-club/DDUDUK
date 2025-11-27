import 'package:flutter/material.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/screens/survey/survey_step2_pain_location_screen.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/common/custom_text_field.dart';

class SurveyStep1BasicInfoScreen extends StatefulWidget {
  const SurveyStep1BasicInfoScreen({super.key});

  @override
  State<SurveyStep1BasicInfoScreen> createState() =>
      _SurveyStep1BasicInfoScreenState();
}

class _SurveyStep1BasicInfoScreenState
    extends State<SurveyStep1BasicInfoScreen> {
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  String _selectedGender = '남성';

  @override
  void dispose() {
    _birthController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      final String formatted =
          '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      _birthController.text = formatted;
      setState(() {});
    }
  }

  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SurveyLayout(
      title: '기본 정보를 입력해주세요',
      description: '정확한 운동 프로그램을 위해 필요해요',
      stepLabel: '1. 기본정보',
      currentStep: 1,
      totalSteps: 6,
      bottomButtons: SurveyButtonsConfig(
        nextText: '다음으로',
        onNext: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const SurveyStep2PainLocationScreen(),
            ),
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
                  const SizedBox(height: AppDimens.space16),
                  Text('생년월일', style: AppTextStyles.body14Medium),
                  const SizedBox(height: AppDimens.space8),
                  CustomTextField(
                    controller: _birthController,
                    hintText: '2000-10-10',
                    icon: Icons.calendar_today_outlined,
                    readOnly: true,
                    onTap: _pickBirthDate,
                  ),
                  const SizedBox(height: AppDimens.space24),
                  Text('키/몸무게', style: AppTextStyles.body14Medium),
                  const SizedBox(height: AppDimens.space8),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _heightController,
                          hintText: '160',
                          suffixText: 'cm',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: AppDimens.itemSpacing),
                      Expanded(
                        child: CustomTextField(
                          controller: _weightController,
                          hintText: '60',
                          suffixText: 'kg',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.space24),
                  Text('성별', style: AppTextStyles.body14Medium),
                  const SizedBox(height: AppDimens.space12),
                  Row(
                    children: [
                      _GenderOption(
                        label: '남성',
                        selected: _selectedGender == '남성',
                        onTap: () => _selectGender('남성'),
                      ),
                      const SizedBox(width: AppDimens.itemSpacing),
                      _GenderOption(
                        label: '여성',
                        selected: _selectedGender == '여성',
                        onTap: () => _selectGender('여성'),
                      ),
                      const SizedBox(width: AppDimens.itemSpacing),
                      _GenderOption(
                        label: '비공개',
                        selected: _selectedGender == '비공개',
                        onTap: () => _selectGender('비공개'),
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
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({
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
        : AppColors.lineNeutral;
    final Color backgroundColor = selected
        ? AppColors.primaryLight
        : AppColors.fillBoxDefault;
    final Color textColor = selected ? AppColors.primary : AppColors.textNormal;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppDimens.space12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.body14Medium.copyWith(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
