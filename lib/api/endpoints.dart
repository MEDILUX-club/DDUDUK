import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API 엔드포인트 상수 정의
class Endpoints {
  // Base URL
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'http://localhost:8080';

  // Auth (인증)
  static const String login = '/api/auth/login';
  static const String refresh = '/api/auth/refresh';

  // User (사용자)
  static String user(int userId) => '/api/users/$userId';
  static const String checkNickname = '/api/users/check-nickname';
  static String fcmToken(int userId) => '/api/users/$userId/fcm-token';
  static String resetSurveys(int userId) => '/api/users/$userId/reset-surveys';

  // Pain Survey (통증 설문 - 초기 설문)
  static String painSurvey(int userId) => '/api/users/$userId/pain-survey';

  // Exercise Ability Survey (운동 능력 평가)
  static String exerciseAbility(int userId) =>
      '/api/users/$userId/exercise-ability';

  // Daily Pain Record (일일 통증 기록)
  static String dailyPain(int userId) => '/api/users/$userId/daily-pain';

  // Next Workout Schedule (다음 운동 일정)
  static String nextWorkoutSchedule(int userId) =>
      '/api/users/$userId/next-workout-schedule';

  // Workout Feedback (운동 후 피드백)
  static String workoutFeedback(int userId) =>
      '/api/users/$userId/workout-feedback';

  // Workout Records (운동 기록)
  static const String workoutRecords = '/api/workout-records';
  static const String workoutRecordsWeeklySummary =
      '/api/workout-records/weekly-summary';
  static const String workoutRecordsDate = '/api/workout-records/date';
  static const String workoutRecordsDates = '/api/workout-records/dates';

  // Workout Routine (운동 루틴)
  static const String routines = '/api/routines';
  static const String routinesDate = '/api/routines/date';

  // Exercise Recommendation (운동 추천)
  static const String exerciseRecommendationInitial =
      '/api/exercise-recommendation/initial';
  static const String exerciseRecommendationRepeat =
      '/api/exercise-recommendation/repeat';
}
