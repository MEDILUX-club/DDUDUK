import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:dduduk_app/screens/auth/terms_agreement_screen.dart';
import 'package:dduduk_app/services/social_auth_service.dart';
import 'package:dduduk_app/repositories/auth_repository.dart';
import 'package:dduduk_app/repositories/pain_survey_repository.dart';
import 'package:dduduk_app/api/api_exception.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isLoading = false;
  final AuthRepository _authRepository = AuthRepository();
  final PainSurveyRepository _painSurveyRepository = PainSurveyRepository();

  /// 로딩 상태 표시
  void _setLoading(bool loading) {
    if (mounted) {
      setState(() => _isLoading = loading);
    }
  }

  /// 통합 로그인 처리: 소셜 로그인 → 서버 로그인 → 화면 이동
  Future<void> _handleSocialLogin(
    Future<SocialLoginResult?> Function() socialLoginFn,
    String providerName,
  ) async {
    _setLoading(true);
    try {
      // 1. 소셜 로그인
      final socialResult = await socialLoginFn();
      if (socialResult == null) {
        _showError('$providerName 로그인에 실패했습니다.');
        return;
      }
      debugPrint('$providerName 소셜 로그인 성공: $socialResult');

      // 2. 서버 로그인 (JWT 토큰 발급)
      final loginResponse = await _authRepository.login(
        socialResult.toLoginRequest(),
      );
      debugPrint('서버 로그인 성공: userId=${loginResponse.userId}');

      if (!mounted) return;

      // 3. Pain Survey 존재 여부로 사용자 상태 판단
      final painSurvey = await _painSurveyRepository.getPainSurvey();
      
      if (!mounted) return;

      if (painSurvey == null) {
        // 설문 미완료: 약관 동의 → 초기 설문
        _navigateToTerms();
      } else {
        // 설문 완료: 메인 화면
        context.go('/exercise-main');
      }
    } on ApiException catch (e) {
      debugPrint('API 에러: $e');
      _showError(e.userMessage);
    } catch (e) {
      debugPrint('$providerName 로그인 중 오류: $e');
      _showError('$providerName 로그인 중 오류가 발생했습니다.');
    } finally {
      _setLoading(false);
    }
  }

  /// 카카오 로그인
  Future<void> _signInWithKakao() async {
    await _handleSocialLogin(
      SocialAuthService.signInWithKakao,
      '카카오',
    );
  }

  /// 네이버 로그인
  Future<void> _signInWithNaver() async {
    await _handleSocialLogin(
      SocialAuthService.signInWithNaver,
      '네이버',
    );
  }

  /// 애플 로그인
  Future<void> _signInWithApple() async {
    await _handleSocialLogin(
      SocialAuthService.signInWithApple,
      '애플',
    );
  }

  /// 약관 동의 화면으로 이동
  void _navigateToTerms() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const TermsAgreementScreen()));
  }

  /// 에러 메시지 표시
  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.fillDefault,
      body: Stack(
        children: [
          // 상단 초록색 배경 (화면 반절)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.5,
            child: Container(color: AppColors.primary),
          ),
          // 배경 이미지 - 화면 상단 70% 차지
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.7,
            child: Image.asset(
              'assets/images/img_signin.png',
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
          // 콘텐츠 - SingleChildScrollView로 스크롤 가능
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      screenHeight -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                  minWidth: screenWidth,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // 상단 로고 및 텍스트
                      Padding(
                        padding: const EdgeInsets.only(top: 120),
                        child: Column(
                          children: [
                            Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                color: AppColors.fillBoxDefault,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  'DDU\nDUK',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.body16Regular.copyWith(
                                    color: AppColors.primaryDark,
                                    height: 1.2,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppDimens.space16),
                            Text(
                              'DDUDUK에',
                              style: AppTextStyles.titleHeader.copyWith(
                                color: AppColors.textWhite,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppDimens.space6),
                            Text(
                              '오신 것을 환영합니다!',
                              style: AppTextStyles.titleHeader.copyWith(
                                color: AppColors.textWhite,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // 하단 버튼 영역
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppDimens.screenPadding,
                          AppDimens.space24,
                          AppDimens.screenPadding,
                          AppDimens.space24,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 카카오 로그인
                            BaseButton(
                              text: 'Kakao로 시작하기',
                              backgroundColor: const Color(0xFFFEE500),
                              textColor: const Color(0xFF191919),
                              fontWeight: FontWeight.w700,
                              leading: SvgPicture.asset(
                                'assets/icons/ic_kakao.svg',
                                width: 20,
                                height: 20,
                              ),
                              onPressed: _isLoading ? null : _signInWithKakao,
                            ),
                            const SizedBox(height: AppDimens.space12),
                            // 네이버 로그인
                            BaseButton(
                              text: 'Naver로 시작하기',
                              backgroundColor: const Color(0xFF03C75A),
                              textColor: Colors.white,
                              fontWeight: FontWeight.w700,
                              leading: SvgPicture.asset(
                                'assets/icons/ic_naver.svg',
                                width: 20,
                                height: 20,
                              ),
                              onPressed: _isLoading ? null : _signInWithNaver,
                            ),
                            const SizedBox(height: AppDimens.space12),
                            // 애플 로그인 (iOS에서만 표시, 웹 제외)
                            if (!kIsWeb &&
                                defaultTargetPlatform == TargetPlatform.iOS)
                              BaseButton(
                                text: 'Apple로 시작하기',
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontWeight: FontWeight.w700,
                                leading: SvgPicture.asset(
                                  'assets/icons/ic_apple.svg',
                                  width: 20,
                                  height: 20,
                                ),
                                onPressed: _isLoading ? null : _signInWithApple,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // 로딩 인디케이터
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}
