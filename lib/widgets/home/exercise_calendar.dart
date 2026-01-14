import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';

/// 홈 화면의 운동 캘린더 위젯
class ExerciseCalendar extends StatefulWidget {
  const ExerciseCalendar({
    super.key,
    this.exerciseDays = const [],
    this.onDateSelected,
    this.onMonthChanged,
  });

  /// 운동한 날짜 목록 (해당 월의 일자)
  final List<int> exerciseDays;

  /// 날짜 선택 콜백
  final ValueChanged<DateTime>? onDateSelected;

  /// 월 변경 콜백 (년도, 월 전달)
  final ValueChanged<DateTime>? onMonthChanged;

  @override
  State<ExerciseCalendar> createState() => _ExerciseCalendarState();
}

class _ExerciseCalendarState extends State<ExerciseCalendar> {
  late DateTime _currentMonth;
  late DateTime _today;

  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    _currentMonth = DateTime(_today.year, _today.month, 1);
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
    widget.onMonthChanged?.call(_currentMonth);
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
    widget.onMonthChanged?.call(_currentMonth);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.space16),
      decoration: BoxDecoration(
        color: AppColors.fillBoxDefault,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더: 운동 캘린더 + 범례
          _buildHeader(),
          const SizedBox(height: AppDimens.space16),
          // 월 네비게이션
          _buildMonthNavigation(),
          const SizedBox(height: AppDimens.space16),
          // 요일 헤더
          _buildWeekdayHeader(),
          const SizedBox(height: AppDimens.space8),
          // 날짜 그리드
          _buildDaysGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icons/ic_calendar.svg',
          width: 24,
          height: 24,
          colorFilter: const ColorFilter.mode(
            AppColors.textStrong,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: AppDimens.space8),
        Text(
          '운동 캘린더',
          style: AppTextStyles.body16Medium.copyWith(
            color: AppColors.textStrong,
          ),
        ),
        const Spacer(),
        // 범례
        _buildLegend('오늘', AppColors.primary, filled: true),
        const SizedBox(width: AppDimens.space12),
        _buildLegend('운동한 날', AppColors.primaryLight, filled: true),
      ],
    );
  }

  Widget _buildLegend(String label, Color color, {bool filled = false}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: filled ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: filled ? null : Border.all(color: color, width: 2),
          ),
        ),
        const SizedBox(width: AppDimens.space4),
        Text(
          label,
          style: AppTextStyles.body12Regular.copyWith(
            color: AppColors.textNeutral,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthNavigation() {
    return Row(
      children: [
        Text(
          '${_currentMonth.year}년  ${_currentMonth.month}월',
          style: AppTextStyles.body18SemiBold.copyWith(
            color: AppColors.primary,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: _previousMonth,
          child: Container(
            padding: const EdgeInsets.all(AppDimens.space4),
            child: const Icon(
              Icons.chevron_left,
              color: AppColors.textNeutral,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: AppDimens.space8),
        GestureDetector(
          onTap: _nextMonth,
          child: Container(
            padding: const EdgeInsets.all(AppDimens.space4),
            child: const Icon(
              Icons.chevron_right,
              color: AppColors.textNeutral,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekdayHeader() {
    const weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: AppTextStyles.body14Medium.copyWith(
                color: AppColors.textNeutral,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDaysGrid() {
    final daysInMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    ).day;
    final firstWeekday =
        DateTime(_currentMonth.year, _currentMonth.month, 1).weekday % 7;

    final List<Widget> dayWidgets = [];

    // 빈 칸 (첫 주 시작 전)
    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(const Expanded(child: SizedBox()));
    }

    // 날짜 칸
    for (int day = 1; day <= daysInMonth; day++) {
      final isToday =
          _today.year == _currentMonth.year &&
          _today.month == _currentMonth.month &&
          _today.day == day;
      final isExerciseDay = widget.exerciseDays.contains(day);

      dayWidgets.add(
        Expanded(
          child: GestureDetector(
            onTap: () {
              widget.onDateSelected?.call(
                DateTime(_currentMonth.year, _currentMonth.month, day),
              );
            },
            child: _DayCell(
              day: day,
              isToday: isToday,
              isExerciseDay: isExerciseDay,
            ),
          ),
        ),
      );
    }

    // 7개씩 Row로 나누기
    final List<Widget> rows = [];
    for (int i = 0; i < dayWidgets.length; i += 7) {
      final rowItems = dayWidgets.sublist(
        i,
        i + 7 > dayWidgets.length ? dayWidgets.length : i + 7,
      );
      // 남은 칸 채우기
      while (rowItems.length < 7) {
        rowItems.add(const Expanded(child: SizedBox()));
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimens.space4),
          child: Row(children: rowItems),
        ),
      );
    }

    return Column(children: rows);
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isToday,
    required this.isExerciseDay,
  });

  final int day;
  final bool isToday;
  final bool isExerciseDay;

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    Color textColor = AppColors.textNormal;

    if (isToday) {
      backgroundColor = AppColors.primary;
      textColor = AppColors.textWhite;
    } else if (isExerciseDay) {
      backgroundColor = AppColors.primaryLight;
      textColor = AppColors.textNormal;
    }

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '$day',
            style: AppTextStyles.body14Medium.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
