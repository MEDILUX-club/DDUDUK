import 'package:dduduk_app/layouts/default_layout.dart';
import 'package:dduduk_app/screens/survey/survey_intro_screen.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/auth/term_list_tile.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';

class TermsAgreementScreen extends StatefulWidget {
  const TermsAgreementScreen({super.key});

  @override
  State<TermsAgreementScreen> createState() => _TermsAgreementScreenState();
}

class _TermsAgreementScreenState extends State<TermsAgreementScreen> {
  final List<bool> _agreements = [false, false, false];

  bool get _allAgreed => _agreements.every((agreed) => agreed);

  void _toggleAll() {
    final bool next = !_allAgreed;
    setState(() {
      for (var i = 0; i < _agreements.length; i++) {
        _agreements[i] = next;
      }
    });
  }

  void _toggleItem(int index) {
    setState(() {
      _agreements[index] = !_agreements[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '',
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppDimens.space16),
        child: BaseButton(
          text: '다음으로',
          isEnabled: _allAgreed,
          onPressed: () {
            if (!_allAgreed) return;
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SurveyIntroScreen()),
            );
          },
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimens.space24),
            Text(
              'DDUDUK 서비스 이용을 위해\n약관에 동의해주세요',
              style: AppTextStyles.titleHeader,
            ),
            const SizedBox(height: AppDimens.space8),
            Text(
              'DDUDUK은 개인정보 수집 및\n민감 데이터 보안을 위해 안전한 환경을 제공합니다',
              style: AppTextStyles.body14Regular.copyWith(
                color: AppColors.textAssistive,
              ),
            ),
            const SizedBox(height: AppDimens.space24),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.fillBoxDefault,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TermListTile(
                title: '전체 동의',
                isChecked: _allAgreed,
                onChanged: _toggleAll,
                onDetailTap: null,
                backgroundColor: AppColors.fillBoxDefault,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.space12,
                  vertical: AppDimens.space14,
                ),
              ),
            ),
            const SizedBox(height: AppDimens.space20),
            TermListTile(
              title: '서비스 이용 약관 (필수)',
              isChecked: _agreements[0],
              onChanged: () => _toggleItem(0),
              onDetailTap: () {},
            ),
            const SizedBox(height: AppDimens.space12),
            TermListTile(
              title: '개인정보 처리방침 (필수)',
              isChecked: _agreements[1],
              onChanged: () => _toggleItem(1),
              onDetailTap: () {},
            ),
            const SizedBox(height: AppDimens.space12),
            TermListTile(
              title: '마케팅 알림 수신 동의 (필수)',
              isChecked: _agreements[2],
              onChanged: () => _toggleItem(2),
              onDetailTap: () {},
            ),
            const SizedBox(height: AppDimens.space48),
          ],
        ),
      ),
    );
  }
}
