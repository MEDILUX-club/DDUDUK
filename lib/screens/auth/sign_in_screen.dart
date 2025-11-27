import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      body: Container(
        color: AppColors.primary,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          style: AppTextStyles.body14Medium.copyWith(
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
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.fillBoxDefault,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(48),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.screenPadding,
                  AppDimens.space32,
                  AppDimens.screenPadding,
                  AppDimens.space24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                      onPressed: () => _toTerms(context),
                    ),
                    const SizedBox(height: AppDimens.space16),
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
                      onPressed: () => _toTerms(context),
                    ),
                    const SizedBox(height: AppDimens.space16),
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
                      onPressed: () => _toTerms(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
