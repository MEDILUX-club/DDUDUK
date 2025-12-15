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

// Exercise screens
import 'package:dduduk_app/screens/exercise/exercise_play_screen.dart';

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
    // =========================================================================
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
          videoUrl: extra?['videoUrl'] ?? '',
          exerciseName: extra?['exerciseName'] ?? '운동',
          currentIndex: extra?['currentIndex'] ?? 0,
          totalCount: extra?['totalCount'] ?? 1,
          onPreviousExercise: extra?['onPreviousExercise'],
          onNextExercise: extra?['onNextExercise'],
        );
      },
    ),
  ],
);
