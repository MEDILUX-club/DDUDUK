import 'package:flutter/material.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';

class SimpleSelectionCard extends StatelessWidget {
  const SimpleSelectionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isSelected
        ? AppColors.primary
        : AppColors.lineNeutral;
    final Color backgroundColor = isSelected
        ? AppColors.primaryLight
        : AppColors.fillBoxDefault;
    final Color iconColor = isSelected
        ? AppColors.primary
        : AppColors.textNeutral;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimens.space14,
          horizontal: AppDimens.space16,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body14Medium.copyWith(
                      color: AppColors.textNormal,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppDimens.space4),
                    Text(
                      subtitle!,
                      style: AppTextStyles.body14Regular.copyWith(
                        color: AppColors.textNeutral,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: iconColor,
            ),
          ],
        ),
      ),
    );
  }
}
