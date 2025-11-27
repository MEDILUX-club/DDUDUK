import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class TermListTile extends StatelessWidget {
  const TermListTile({
    super.key,
    required this.title,
    required this.isChecked,
    required this.onChanged,
    this.onDetailTap,
    this.backgroundColor,
    this.contentPadding,
    this.borderRadius = 12,
  });

  final String title;
  final bool isChecked;
  final VoidCallback onChanged;
  final VoidCallback? onDetailTap;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry resolvedPadding =
        contentPadding ??
        const EdgeInsets.symmetric(
          horizontal: AppDimens.space12,
          vertical: AppDimens.space14,
        );

    return GestureDetector(
      onTap: onChanged,
      child: Container(
        width: double.infinity,
        padding: resolvedPadding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          children: [
            _CheckBox(isChecked: isChecked),
            const SizedBox(width: AppDimens.space12),
            Expanded(child: Text(title, style: AppTextStyles.body16Regular)),
            if (onDetailTap != null)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onDetailTap,
                child: const Padding(
                  padding: EdgeInsets.all(AppDimens.space4),
                  child: Icon(
                    Icons.chevron_right,
                    color: AppColors.textAssistive,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CheckBox extends StatelessWidget {
  const _CheckBox({required this.isChecked});

  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: isChecked ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isChecked ? Colors.transparent : AppColors.lineNeutral,
          width: 2,
        ),
      ),
      child: isChecked
          ? const Icon(Icons.check, size: 16, color: AppColors.textWhite)
          : null,
    );
  }
}
