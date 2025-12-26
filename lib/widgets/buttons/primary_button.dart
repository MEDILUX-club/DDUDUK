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
    this.leading,
    this.fontWeight,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final Widget? leading;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    final bool enabled = isEnabled && onPressed != null;
    final Color resolvedBackground = enabled
        ? (backgroundColor ?? AppColors.primary)
        : AppColors.interactionDisabled;
    final Color resolvedText = textColor ?? AppColors.textWhite;
    final Widget? leadingWidget =
        leading ?? (icon != null ? Icon(icon, color: resolvedText) : null);

    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: resolvedBackground,
          foregroundColor: resolvedText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: leadingWidget == null
            ? Text(
                text,
                style: AppTextStyles.body16Regular.copyWith(
                  color: resolvedText,
                  fontWeight: fontWeight,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  leadingWidget,
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: AppTextStyles.body16Regular.copyWith(
                      color: resolvedText,
                      fontWeight: fontWeight,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
