/// 주간 운동 요약 모델
class WeeklyWorkoutSummary {
  final int thisWeekWorkoutCount;
  final int thisWeekTotalMinutes;
  final int lastWeekWorkoutCount;
  final int lastWeekTotalMinutes;
  final int workoutCountDiff;
  final int totalMinutesDiff;

  WeeklyWorkoutSummary({
    required this.thisWeekWorkoutCount,
    required this.thisWeekTotalMinutes,
    required this.lastWeekWorkoutCount,
    required this.lastWeekTotalMinutes,
    required this.workoutCountDiff,
    required this.totalMinutesDiff,
  });

  factory WeeklyWorkoutSummary.fromJson(Map<String, dynamic> json) {
    return WeeklyWorkoutSummary(
      thisWeekWorkoutCount: json['thisWeekWorkoutCount'] as int? ?? 0,
      thisWeekTotalMinutes: json['thisWeekTotalMinutes'] as int? ?? 0,
      lastWeekWorkoutCount: json['lastWeekWorkoutCount'] as int? ?? 0,
      lastWeekTotalMinutes: json['lastWeekTotalMinutes'] as int? ?? 0,
      workoutCountDiff: json['workoutCountDiff'] as int? ?? 0,
      totalMinutesDiff: json['totalMinutesDiff'] as int? ?? 0,
    );
  }

  /// 운동 횟수 변화가 긍정적인지 확인
  bool get isWorkoutCountPositive => workoutCountDiff >= 0;

  /// 총 시간 변화가 긍정적인지 확인
  bool get isTotalMinutesPositive => totalMinutesDiff >= 0;
}
