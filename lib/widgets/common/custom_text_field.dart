import 'package:flutter/material.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.suffixText,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? suffixText;
  final IconData? icon;
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final suffix = icon != null
        ? Icon(icon, size: AppDimens.iconSize, color: AppColors.textNormal)
        : (suffixText != null
              ? Padding(
                  padding: const EdgeInsets.only(right: AppDimens.space4),
                  child: Text(
                    suffixText!,
                    style: AppTextStyles.body14Regular.copyWith(
                      color: AppColors.textNeutral,
                    ),
                  ),
                )
              : null);

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      style: AppTextStyles.body14Regular,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.body14Regular.copyWith(
          color: AppColors.textNeutral,
        ),
        filled: true,
        fillColor: AppColors.fillBoxDefault,
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppDimens.space14,
          horizontal: AppDimens.space16,
        ),
        suffixIcon: suffix,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lineNeutral),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 1.2),
        ),
      ),
    );
  }
}
