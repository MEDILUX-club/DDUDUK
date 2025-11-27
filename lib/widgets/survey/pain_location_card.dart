import 'package:flutter/material.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PainLocationCard extends StatelessWidget {
  const PainLocationCard({
    super.key,
    required this.label,
    required this.iconPath,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final double scale = (MediaQuery.of(context).size.width / 375).clamp(
      0.9,
      1.2,
    );
    final double iconSize = AppDimens.space48 * scale;
    final double iconHeight = iconSize * 0.9;
    final Color backgroundColor = isSelected
        ? const Color(0xFFE6F8F2)
        : AppColors.fillBoxDefault;
    final Color textColor = isSelected
        ? AppColors.primary
        : AppColors.textNormal;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppDimens.space12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.linePrimary,
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.space12,
          vertical: AppDimens.space8,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(iconPath, width: iconSize, height: iconHeight),
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
