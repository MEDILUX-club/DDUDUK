import 'package:flutter/material.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';

class PainLocationCard extends StatelessWidget {
  const PainLocationCard({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
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
    final Color textColor = isSelected
        ? AppColors.primary
        : AppColors.textNormal;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1.0),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.space12,
          vertical: AppDimens.space16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: textColor),
            const SizedBox(height: AppDimens.space10),
            Text(
              label,
              style: AppTextStyles.body14Medium.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
