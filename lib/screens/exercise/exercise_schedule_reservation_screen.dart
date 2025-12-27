import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:dduduk_app/layouts/survey_layout.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/common/custom_text_field.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';
import 'package:dduduk_app/services/notification_service.dart';

class ExerciseScheduleReservationScreen extends StatefulWidget {
  const ExerciseScheduleReservationScreen({super.key});

  @override
  State<ExerciseScheduleReservationScreen> createState() =>
      _ExerciseScheduleReservationScreenState();
}

class _ExerciseScheduleReservationScreenState
    extends State<ExerciseScheduleReservationScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  bool _isNotificationEnabled = false;

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _pickDate() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return _DateSelectionModal(
          onDateSelected: (DateTime selectedDate) {
            final String formatted =
                '${selectedDate.year.toString().padLeft(4, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
            _dateController.text = formatted;
            setState(() {});
          },
        );
      },
    );
  }

  void _pickTime() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return _TimeSelectionModal(
          onTimeSelected: (TimeOfDay selectedTime) {
            // Format time as HH:mm
            final String formatted =
                '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
            _timeController.text = formatted;
            setState(() {});
          },
        );
      },
    );
  }

  Future<void> _handleReservation() async {
    if (_dateController.text.isEmpty || _timeController.text.isEmpty) {
      return;
    }

    try {
      final dateParts = _dateController.text.split('-');
      final timeParts = _timeController.text.split(':');
      
      final scheduledDate = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );

      if (_isNotificationEnabled) {
        final bool? granted = await NotificationService().requestPermissions();
        if (granted == true) {
          final notificationTime = scheduledDate.subtract(const Duration(minutes: 30));
          
          if (notificationTime.isAfter(DateTime.now())) {
             await NotificationService().scheduleNotification(
              id: 1, 
              title: '운동 시간 알림',
              body: '운동 시작 30분 전입니다! 준비운동을 시작해보세요.',
              scheduledDate: notificationTime,
            );
          }
        }
      } else {
        await NotificationService().cancelNotification(1);
      }
      
      if (mounted) {
        context.go('/exercise/main');
      }

    } catch (e) {
      debugPrint('Error scheduling: \$e');
      if (mounted) {
        context.go('/exercise/main');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SurveyLayout(
      appBarTitle: '운동 일정 예약',
      title: '다음 운동은 언제 할까요?',
      description: '계속해서 좋은 습관을 만들어보세요',
      showProgressBar: false,
      bottomButtons: SurveyButtonsConfig(
        nextText: '예약하기',
        onNext: _handleReservation,
        isNextEnabled: true,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimens.space24),
            Text('운동 날짜', style: AppTextStyles.body14Medium),
            const SizedBox(height: AppDimens.space8),
            CustomTextField(
              controller: _dateController,
              hintText: '2025-12-26',
              icon: Icons.calendar_month_outlined,
              readOnly: true,
              onTap: _pickDate,
            ),
            const SizedBox(height: AppDimens.space24),
            Text('운동 시간', style: AppTextStyles.body14Medium),
            const SizedBox(height: AppDimens.space8),
            CustomTextField(
              controller: _timeController,
              hintText: '00:00',
              icon: Icons.access_time_outlined,
              readOnly: true,
              onTap: _pickTime,
            ),
            const SizedBox(height: AppDimens.space24),
            Text('알림 설정', style: AppTextStyles.body14Medium),
            const SizedBox(height: AppDimens.space8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.space16,
                vertical: AppDimens.space8,
              ),
              decoration: BoxDecoration(
                color: AppColors.fillBoxDefault,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.lineNeutral),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('운동 시작 30분 전 알림', style: AppTextStyles.body16Medium),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: _isNotificationEnabled,
                      onChanged: (value) {
                        setState(() {
                          _isNotificationEnabled = value;
                        });
                      },
                      activeThumbColor: AppColors.primary,
                      activeTrackColor: AppColors.primaryLight,
                      inactiveThumbColor: AppColors.fillBoxDefault,
                      inactiveTrackColor: AppColors.linePrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.space24),
            Container(
              padding: const EdgeInsets.all(AppDimens.space16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.statusDestructive,
                        size: 20,
                      ),
                      const SizedBox(width: AppDimens.space8),
                      Text(
                        '운동 예약',
                        style: AppTextStyles.body14Medium.copyWith(
                          color: AppColors.statusDestructive,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.space8),
                  Text(
                    '운동 일정은 하나만 예약할 수 있어요.\n새로운 일정을 예약하면, 이전의 예약은 취소 돼요.',
                    style: AppTextStyles.body14Regular.copyWith(
                      color: AppColors.textNeutral,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
             const SizedBox(height: AppDimens.space32),
          ],
        ),
      ),
    );
  }
}

class _DateSelectionModal extends StatefulWidget {
  const _DateSelectionModal({required this.onDateSelected});

  final ValueChanged<DateTime> onDateSelected;

  @override
  State<_DateSelectionModal> createState() => _DateSelectionModalState();
}

class _DateSelectionModalState extends State<_DateSelectionModal> {
  DateTime? _selectedDate;
  final List<DateTime> _availableDates = [];

  @override
  void initState() {
    super.initState();
    // Generate dates for the next 14 days
    final now = DateTime.now();
    for (int i = 0; i < 14; i++) {
      _availableDates.add(now.add(Duration(days: i)));
    }
  }

  void _handleConfirm() {
    if (_selectedDate != null) {
      widget.onDateSelected(_selectedDate!);
      Navigator.of(context).pop();
    }
  }

  String _getWeekdayString(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return '월요일';
      case DateTime.tuesday:
        return '화요일';
      case DateTime.wednesday:
        return '수요일';
      case DateTime.thursday:
        return '목요일';
      case DateTime.friday:
        return '금요일';
      case DateTime.saturday:
        return '토요일';
      case DateTime.sunday:
        return '일요일';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '운동 날짜를 선택해주세요.',
              style: AppTextStyles.body16Medium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 100, // Adjust height as needed
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _availableDates.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final date = _availableDates[index];
                  final isSelected = _selectedDate != null &&
                      date.year == _selectedDate!.year &&
                      date.month == _selectedDate!.month &&
                      date.day == _selectedDate!.day;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                    child: Container(
                      width: 80, // Adjust width
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryLight
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.lineNeutral,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getWeekdayString(date.weekday),
                            style: AppTextStyles.body14Medium.copyWith(
                              color: isSelected
                                  ? AppColors.primaryDark
                                  : AppColors.textNeutral,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            date.day.toString(),
                            style: AppTextStyles.body20Bold.copyWith(
                              color: isSelected
                                  ? AppColors.primaryDark
                                  : AppColors.textStrong,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            BaseButton(
              text: '다음으로',
              onPressed: _selectedDate != null ? _handleConfirm : null,
              isEnabled: _selectedDate != null,
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeSelectionModal extends StatefulWidget {
  const _TimeSelectionModal({required this.onTimeSelected});

  final ValueChanged<TimeOfDay> onTimeSelected;

  @override
  State<_TimeSelectionModal> createState() => _TimeSelectionModalState();
}

class _TimeSelectionModalState extends State<_TimeSelectionModal> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    final now = TimeOfDay.now();
    // Round minutes to nearest 10
    final int roundedMinute = (now.minute / 10).round() * 10;
    _selectedTime = TimeOfDay(hour: now.hour, minute: roundedMinute % 60);
  }

  void _handleConfirm() {
    widget.onTimeSelected(_selectedTime);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '운동할 시간을 선택해주세요.',
              style: AppTextStyles.body16Medium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                minuteInterval: 10,
                initialDateTime: DateTime(
                  2024,
                  1,
                  1,
                  _selectedTime.hour,
                  _selectedTime.minute,
                ),
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() {
                    _selectedTime = TimeOfDay.fromDateTime(newDateTime);
                  });
                },
              ),
            ),
            const SizedBox(height: 32),
            BaseButton(
              text: '다음으로',
              onPressed: _handleConfirm,
              isEnabled: true,
            ),
          ],
        ),
      ),
    );
  }
}
