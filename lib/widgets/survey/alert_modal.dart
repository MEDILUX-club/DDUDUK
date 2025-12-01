import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';

class AlertModal extends StatelessWidget {
  const AlertModal({super.key, this.onConfirm});

  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppDimens.space16,
        vertical: AppDimens.space20,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.space24,
          vertical: AppDimens.space32,
        ),
        decoration: BoxDecoration(
          color: AppColors.fillDefault,
          borderRadius: BorderRadius.circular(AppDimens.space24),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1),
              blurRadius: 28,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/ic_alert.svg',
              width: 72,
              height: 72,
            ),
            const SizedBox(height: AppDimens.space20),
            Text(
              '체크하신 항목은 즉시 전문적인 진단이\n필요한 위험 신호일 수 있습니다.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body18SemiBold.copyWith(
                color: AppColors.statusDestructive,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimens.space20),
            Text(
              '무리한 운동은 오히려 상태를 악화시킬 수 있으니,\n지금 바로 정형외과나 병원에 방문하여 정확한\n진료를 받아보시기를 강력하게 권유합니다.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body16Regular.copyWith(
                color: AppColors.textNeutral,
              ),
            ),
            const SizedBox(height: AppDimens.space24),
            Text(
              '저희의 운동 추천은 진료 후\n전문의와 상담을 거친 뒤에 시작해주세요!',
              textAlign: TextAlign.center,
              style: AppTextStyles.body16Regular.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimens.space28),
            BaseButton(
              text: '확인',
              onPressed: onConfirm ?? () => Navigator.of(context).pop(),
              backgroundColor: AppColors.statusDestructive,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }
}
