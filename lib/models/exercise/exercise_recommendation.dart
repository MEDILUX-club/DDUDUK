class ExerciseRecommendationResponse {
  final int id;
  final String routineDate;
  final List<RecommendedExercise> exercises;

  ExerciseRecommendationResponse({
    required this.id,
    required this.routineDate,
    required this.exercises,
  });

  factory ExerciseRecommendationResponse.fromJson(Map<String, dynamic> json) {
    return ExerciseRecommendationResponse(
      id: json['id'] as int? ?? 0,
      routineDate: json['routineDate'] as String? ?? '',
      exercises: (json['exercises'] as List<dynamic>?)
              ?.map((e) => RecommendedExercise.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class RecommendedExercise {
  final String exerciseId;
  final String nameKo;
  final int exerciseOrder;
  final String difficulty;
  final int recommendedReps;
  final int recommendedSets;
  final String videoUrl;
  final String? description;

  RecommendedExercise({
    required this.exerciseId,
    required this.nameKo,
    required this.exerciseOrder,
    required this.difficulty,
    required this.recommendedReps,
    required this.recommendedSets,
    required this.videoUrl,
    this.description,
  });

  factory RecommendedExercise.fromJson(Map<String, dynamic> json) {
    return RecommendedExercise(
      exerciseId: json['exerciseId'] as String? ?? '',
      nameKo: json['nameKo'] as String? ?? '운동',
      exerciseOrder: json['exerciseOrder'] as int? ?? 0,
      difficulty: json['difficulty'] as String? ?? '초급',
      recommendedReps: json['recommendedReps'] as int? ?? 10,
      recommendedSets: json['recommendedSets'] as int? ?? 3,
      videoUrl: json['videoUrl'] as String? ?? '',
      // API 응답에 description이 없을 수 있으므로 처리
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'nameKo': nameKo,
      'exerciseOrder': exerciseOrder,
      'difficulty': difficulty,
      'recommendedReps': recommendedReps,
      'recommendedSets': recommendedSets,
      'videoUrl': videoUrl,
    };
  }
}
