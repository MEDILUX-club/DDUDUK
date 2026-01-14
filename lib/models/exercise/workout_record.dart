/// 운동 기록 저장 요청 모델
class WorkoutRecordRequest {
  final String date;
  final List<WorkoutRecord> records;

  WorkoutRecordRequest({
    required this.date,
    required this.records,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'records': records.map((r) => r.toJson()).toList(),
    };
  }
}

/// 개별 운동 기록 모델
class WorkoutRecord {
  final String exerciseId;
  final String exerciseName;
  final int actualSets;
  final int actualReps;
  final int durationSeconds;

  WorkoutRecord({
    required this.exerciseId,
    required this.exerciseName,
    required this.actualSets,
    required this.actualReps,
    required this.durationSeconds,
  });

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'actualSets': actualSets,
      'actualReps': actualReps,
      'durationSeconds': durationSeconds,
    };
  }

  factory WorkoutRecord.fromJson(Map<String, dynamic> json) {
    return WorkoutRecord(
      exerciseId: json['exerciseId'] as String? ?? '',
      exerciseName: json['exerciseName'] as String? ?? '',
      actualSets: json['actualSets'] as int? ?? 0,
      actualReps: json['actualReps'] as int? ?? 0,
      durationSeconds: json['durationSeconds'] as int? ?? 0,
    );
  }
}
