import 'package:flutter/material.dart';
import 'package:dduduk_app/screens/auth/terms_agreement_screen.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  void _toTerms(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const TermsAgreementScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(flex: 2, child: Container(color: AppColors.primary)),
              Expanded(flex: 1, child: Container(color: AppColors.fillDefault)),
            ],
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset(
                            'assets/images/onboarding/onboarding.png',
                            height: 320,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 320,
                                width: double.infinity,
                                color: AppColors.primary,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: AppDimens.space24),
                        Text(
                          'DDUDUK에\n오신 것을 환영합니다!',
                          style: AppTextStyles.titleHeader.copyWith(
                            color: AppColors.textWhite,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BaseButton(
                        text: 'Kakao로 시작하기',
                        backgroundColor: const Color(0xFFFEE500),
                        textColor: const Color(0xFF191919),
                        icon: Icons.chat_bubble,
                        onPressed: () => _toTerms(context),
                      ),
                      const SizedBox(height: AppDimens.space16),
                      BaseButton(
                        text: 'Naver로 시작하기',
                        backgroundColor: const Color(0xFF03C75A),
                        textColor: Colors.white,
                        icon: Icons.search,
                        onPressed: () => _toTerms(context),
                      ),
                      const SizedBox(height: AppDimens.space16),
                      BaseButton(
                        text: 'Apple로 시작하기',
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        icon: Icons.apple,
                        onPressed: () => _toTerms(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
