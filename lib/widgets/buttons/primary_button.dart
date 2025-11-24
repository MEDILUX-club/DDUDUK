import 'package:flutter/material.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';

class BaseButton extends StatelessWidget {
  const BaseButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final Color resolvedBackground = isEnabled
        ? (backgroundColor ?? AppColors.primary)
        : AppColors.interactionInactive;
    final Color resolvedText = textColor ?? AppColors.textWhite;

    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: resolvedBackground,
          foregroundColor: resolvedText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: icon == null
            ? Text(
                text,
                style: AppTextStyles.body14Medium.copyWith(color: resolvedText),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: resolvedText),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: AppTextStyles.body14Medium.copyWith(
                      color: resolvedText,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
