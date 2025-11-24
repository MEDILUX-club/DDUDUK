import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dduduk_app/layouts/default_layout.dart';
import 'package:dduduk_app/screens/survey/survey_step5_workout_exp_screen.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';
import 'package:dduduk_app/widgets/common/custom_text_field.dart';
import 'package:dduduk_app/widgets/survey/lifestyle_option_card.dart';

class SurveyStep4LifestyleScreen extends StatefulWidget {
  const SurveyStep4LifestyleScreen({super.key});

  @override
  State<SurveyStep4LifestyleScreen> createState() =>
      _SurveyStep4LifestyleScreenState();
}

class _SurveyStep4LifestyleScreenState
    extends State<SurveyStep4LifestyleScreen> {
  final TextEditingController _sleepController = TextEditingController(
    text: '22:00',
  );
  final TextEditingController _wakeController = TextEditingController(
    text: '07:00',
  );

  DateTime? _sleepTime;
  DateTime? _wakeTime;
  String _selectedLifestyle = 'sedentary';

  final List<Map<String, dynamic>> _options = [
    {
      'key': 'sedentary',
      'title': '주로 앉아서 일해요',
      'subtitle': '사무직, 학생 등',
      'icon': Icons.chair,
    },
    {
      'key': 'light',
      'title': '가볍게 움직여요',
      'subtitle': '서서 일하거나 가볍게 움직여요',
      'icon': Icons.directions_walk,
    },
    {
      'key': 'active',
      'title': '매우 활동적이에요',
      'subtitle': '체육, 건설직 등',
      'icon': Icons.fitness_center,
    },
  ];

  @override
  void dispose() {
    _sleepController.dispose();
    _wakeController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  Future<void> _pickTime({required bool isSleep}) async {
    final DateTime now = DateTime.now();
    final DateTime initial = isSleep
        ? (_sleepTime ?? DateTime(now.year, now.month, now.day, 22, 0))
        : (_wakeTime ?? DateTime(now.year, now.month, now.day, 7, 0));

    DateTime temp = initial;

    final DateTime? picked = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: AppColors.fillBoxDefault,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.space16,
                  vertical: AppDimens.space12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(sheetContext).pop(temp),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                      child: const Text('완료'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: initial,
                  use24hFormat: true,
                  onDateTimeChanged: (value) => temp = value,
                ),
              ),
            ],
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isSleep) {
          _sleepTime = picked;
          _sleepController.text = _formatTime(picked);
        } else {
          _wakeTime = picked;
          _wakeController.text = _formatTime(picked);
        }
      });
    }
  }

  void _selectLifestyle(String key) {
    setState(() {
      _selectedLifestyle = key;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'Step 4 - 생활 패턴',
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimens.space24),
                  Text('평소 몇 시에 주무시나요?', style: AppTextStyles.titleText1),
                  const SizedBox(height: AppDimens.space8),
                  Text(
                    '수면 패턴에 맞춘 운동을 안내드릴게요',
                    style: AppTextStyles.body14Regular.copyWith(
                      color: AppColors.textNeutral,
                    ),
                  ),
                  const SizedBox(height: AppDimens.space20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('취침시간', style: AppTextStyles.body14Medium),
                            const SizedBox(height: AppDimens.space8),
                            CustomTextField(
                              controller: _sleepController,
                              hintText: '22:00',
                              icon: Icons.access_time,
                              readOnly: true,
                              onTap: () => _pickTime(isSleep: true),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppDimens.itemSpacing),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('기상시간', style: AppTextStyles.body14Medium),
                            const SizedBox(height: AppDimens.space8),
                            CustomTextField(
                              controller: _wakeController,
                              hintText: '07:00',
                              icon: Icons.access_time,
                              readOnly: true,
                              onTap: () => _pickTime(isSleep: false),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.space32),
                  Text('생활패턴은 어떠신가요?', style: AppTextStyles.titleText1),
                  const SizedBox(height: AppDimens.space8),
                  Text(
                    '평소 생활 패턴에 맞춘 운동을 안내드릴게요',
                    style: AppTextStyles.body14Regular.copyWith(
                      color: AppColors.textNeutral,
                    ),
                  ),
                  const SizedBox(height: AppDimens.space20),
                  Column(
                    children: _options.map((option) {
                      final key = option['key'] as String;
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimens.space12,
                        ),
                        child: LifestyleOptionCard(
                          icon: option['icon'] as IconData,
                          title: option['title'] as String,
                          subtitle: option['subtitle'] as String,
                          selected: _selectedLifestyle == key,
                          onTap: () => _selectLifestyle(key),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.space12),
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
                        builder: (_) => const SurveyStep5WorkoutExpScreen(),
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
