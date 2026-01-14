import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    this.suffixWidget,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
    this.maxLength,
    this.hasError = false,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? suffixText;
  final IconData? icon;
  final Widget? suffixWidget;
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final int? maxLength;
  final bool hasError;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    // suffixWidget이 있으면 우선 사용, 없으면 icon 사용
    Widget? suffixIconWidget;
    if (suffixWidget != null) {
      suffixIconWidget = Padding(
        padding: const EdgeInsets.only(right: AppDimens.space12),
        child: suffixWidget,
      );
    } else if (icon != null) {
      suffixIconWidget = Icon(icon, size: AppDimens.iconSize, color: AppColors.textNormal);
    }

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
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
        counterText: '', // maxLength 카운터 숨김
        suffixIcon: suffixIconWidget,
        suffixIconConstraints: suffixWidget != null 
            ? const BoxConstraints(minHeight: 24, minWidth: 24)
            : null,
        // 텍스트인 경우 suffix 사용 (세로 정렬 문제 해결)
        suffix: suffixText != null
            ? Text(
                suffixText!,
                style: AppTextStyles.body14Regular.copyWith(
                  color: AppColors.textNeutral,
                ),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: hasError ? AppColors.statusDestructive : AppColors.lineNeutral,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: hasError ? AppColors.statusDestructive : AppColors.primary,
            width: 1.2,
          ),
        ),
      ),
    );
  }
}
