import 'package:flutter/material.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';

class LifestyleOptionCard extends StatelessWidget {
  const LifestyleOptionCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color borderColor = selected
        ? AppColors.primary
        : AppColors.lineNeutral;
    final Color backgroundColor = selected
        ? AppColors.primaryLight
        : AppColors.fillDefault;
    final Color titleColor = AppColors.textNormal;
    final Color subtitleColor = AppColors.textNormal.withValues(alpha: 0.6);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.space16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 40, height: 40),
            const SizedBox(width: AppDimens.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body14Medium.copyWith(
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: AppDimens.space4),
                  Text(
                    subtitle,
                    style: AppTextStyles.body14Regular.copyWith(
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
