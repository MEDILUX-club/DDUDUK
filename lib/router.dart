import 'package:go_router/go_router.dart';

// Auth screens
import 'package:dduduk_app/screens/auth/splash_screen.dart';
import 'package:dduduk_app/screens/auth/onboarding_screen.dart';
import 'package:dduduk_app/screens/auth/sign_in_screen.dart';
import 'package:dduduk_app/screens/auth/terms_agreement_screen.dart';

// Survey screens
import 'package:dduduk_app/screens/survey/survey_intro_screen.dart';
import 'package:dduduk_app/screens/survey/survey_step1_basic_info_screen.dart';
import 'package:dduduk_app/screens/survey/survey_step2_pain_location_screen.dart';
import 'package:dduduk_app/screens/survey/survey_step3_pain_basic_screen.dart';
import 'package:dduduk_app/screens/survey/survey_step4_pain_detail_screen.dart';
import 'package:dduduk_app/screens/survey/survey_step5_red_flags_screen.dart';
import 'package:dduduk_app/screens/survey/survey_step6_result_screen.dart';
import 'package:dduduk_app/screens/survey/survey_completion_screen.dart';

// Home screens
import 'package:dduduk_app/screens/home/home_screen.dart';

// Exercise screens
import 'package:dduduk_app/screens/exercise/exercise_play_screen.dart';
import 'package:dduduk_app/screens/exercise/exercise_survey_fixed_screen.dart';
import 'package:dduduk_app/screens/exercise/exercise_survey1_screen.dart';
import 'package:dduduk_app/screens/exercise/exercise_survey2_screen.dart';
import 'package:dduduk_app/screens/exercise/exercise_survey3_screen.dart';
import 'package:dduduk_app/screens/exercise/exercise_survey4_screen.dart';
import 'package:dduduk_app/screens/exercise/exercise_feedback_screen1.dart';
import 'package:dduduk_app/screens/exercise/exercise_feedback_screen2.dart';
import 'package:dduduk_app/screens/exercise/exercise_feedback_screen3.dart';
import 'package:dduduk_app/screens/exercise/exercise_main_empty_screen.dart';
import 'package:dduduk_app/screens/exercise/exercise_main_screen.dart';
import 'package:dduduk_app/screens/exercise/exercise_rest_screen.dart';
import 'package:dduduk_app/screens/exercise/exercise_survey_fixed1_screen.dart';
import 'package:dduduk_app/widgets/exercise/exercise_routine_card.dart';
import 'package:dduduk_app/screens/exercise/exercise_schedule_reservation_screen.dart';

/// 앱 라우터 설정
///
/// 사용법:
/// - context.go('/path') : 해당 경로로 이동 (히스토리 대체)
/// - context.push('/path') : 해당 경로로 이동 (히스토리 추가)
/// - context.pop() : 뒤로 가기
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true, // 개발 중 라우팅 로그 출력
  routes: [
    // =========================================================================
    // Auth Routes
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/sign-in',
      name: 'signIn',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/terms',
      name: 'terms',
      builder: (context, state) => const TermsAgreementScreen(),
    ),

    // =========================================================================
    // Home Routes
    // =========================================================================
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),

    // =========================================================================
    // Survey Routes
    // =========================================================================
    GoRoute(
      path: '/survey/intro',
      name: 'surveyIntro',
      builder: (context, state) => const SurveyIntroScreen(),
    ),
    GoRoute(
      path: '/survey/step1',
      name: 'surveyStep1',
      builder: (context, state) => const SurveyStep1BasicInfoScreen(),
    ),
    GoRoute(
      path: '/survey/step2',
      name: 'surveyStep2',
      builder: (context, state) => const SurveyStep2PainLocationScreen(),
    ),
    GoRoute(
      path: '/survey/step3',
      name: 'surveyStep3',
      builder: (context, state) => const SurveyStep3PainLevelScreen(),
    ),
    GoRoute(
      path: '/survey/step4',
      name: 'surveyStep4',
      builder: (context, state) => const SurveyStep4LifestyleScreen(),
    ),
    GoRoute(
      path: '/survey/step5',
      name: 'surveyStep5',
      builder: (context, state) => const SurveyStep5WorkoutExpScreen(),
    ),
    GoRoute(
      path: '/survey/step6',
      name: 'surveyStep6',
      builder: (context, state) => const SurveyStep6ResultScreen(),
    ),
    GoRoute(
      path: '/survey/completion',
      name: 'surveyCompletion',
      builder: (context, state) => const SurveyCompletionScreen(),
    ),

    // =========================================================================
    // Exercise Routes
    // =========================================================================
    GoRoute(
      path: '/exercise/play',
      name: 'exercisePlay',
      builder: (context, state) {
        // 쿼리 파라미터 또는 extra에서 데이터 받기
        final extra = state.extra as Map<String, dynamic>?;
        return ExercisePlayScreen(
          videoUrl:
              extra?['videoUrl'] ??
              'https://www.youtube.com/watch?v=akLRbdTtD7Y',
          exerciseName: extra?['exerciseName'] ?? '푸쉬업',
          exerciseDescription:
              extra?['exerciseDescription'] ??
              '가슴과 삼두근을 강화하는 기본 운동이에요\n팔꿈치를 90도로 구부리며 천천히 내렸다가 올려요',
          sets: extra?['sets'] ?? 3,
          reps: extra?['reps'] ?? 10,
          currentIndex: extra?['currentIndex'] ?? 0,
          totalCount: extra?['totalCount'] ?? 1,
          onPreviousExercise: extra?['onPreviousExercise'],
          onNextExercise: extra?['onNextExercise'],
        );
      },
    ),
    GoRoute(
      path: '/exercise/fixed',
      name: 'exerciseSurveyFixed',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ExerciseSurveyFixedScreen(onComplete: extra?['onComplete']);
      },
    ),
    GoRoute(
      path: '/exercise/fixed1',
      name: 'exerciseFixed1',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ExerciseFixed1Screen(
          dayNumber: extra?['dayNumber'] ?? 1,
          exercises: extra?['exercises'] ?? [],
          onStartPressed: extra?['onStartPressed'],
        );
      },
    ),
    GoRoute(
      path: '/exercise/survey1',
      name: 'exerciseSurvey1',
      builder: (context, state) => const ExerciseSurvey1Screen(),
    ),
    GoRoute(
      path: '/exercise/survey2',
      name: 'exerciseSurvey2',
      builder: (context, state) => const ExerciseSurvey2Screen(),
    ),
    GoRoute(
      path: '/exercise/survey3',
      name: 'exerciseSurvey3',
      builder: (context, state) => const ExerciseSurvey3Screen(),
    ),
    GoRoute(
      path: '/exercise/survey4',
      name: 'exerciseSurvey4',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ExerciseSurvey4Screen(onComplete: extra?['onComplete']);
      },
    ),
    GoRoute(
      path: '/exercise/feedback-1',
      name: 'exerciseFeedback1',
      builder: (context, state) => const ExerciseFeedbackScreen1(),
    ),
    GoRoute(
      path: '/exercise/feedback-2',
      name: 'exerciseFeedback2',
      builder: (context, state) => const ExerciseFeedbackScreen2(),
    ),
    GoRoute(
      path: '/exercise/feedback-3',
      name: 'exerciseFeedback3',
      builder: (context, state) => const ExerciseFeedbackScreen3(),
    ),
    GoRoute(
      path: '/exercise/main-empty',
      name: 'exerciseMainEmpty',
      builder: (context, state) => const ExerciseMainEmptyScreen(),
    ),
    GoRoute(
      path: '/exercise/main',
      name: 'exerciseMain',
      builder: (context, state) => const ExerciseMainScreen(),
    ),
    GoRoute(
      path: '/exercise/rest',
      name: 'exerciseRest',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        // 기본 테스트 데이터
        final defaultNextExercises = [
          const ExerciseRoutineData(name: '스쿼트', sets: 3, reps: 10),
          const ExerciseRoutineData(name: '스쿼트', sets: 3, reps: 10),
        ];

        return ExerciseRestScreen(
          initialRestSeconds: extra?['initialRestSeconds'] ?? 30,
          extensionSeconds: extra?['extensionSeconds'] ?? 20,
          maxExtensions: extra?['maxExtensions'] ?? 3,
          nextExercises: extra?['nextExercises'] ?? defaultNextExercises,
          onRestComplete: extra?['onRestComplete'],
          onNextExercise: extra?['onNextExercise'],
        );
      },
    ),
    GoRoute(
      path: '/exercise/reservation',
      name: 'exerciseReservation',
      builder: (context, state) => const ExerciseScheduleReservationScreen(),
    ),
  ],
);
