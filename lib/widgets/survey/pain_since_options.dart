import 'package:flutter/material.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';

class PainSinceOptions extends StatelessWidget {
  const PainSinceOptions({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.options,
    this.spacing = AppDimens.space8,
    this.trailingSpacing = AppDimens.space8,
  });

  final String? selected;
  final ValueChanged<String> onSelect;
  final List<String> options;
  final double spacing;
  final double trailingSpacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < options.length; i++)
          Padding(
            padding: EdgeInsets.only(
              bottom: i == options.length - 1 ? trailingSpacing : spacing,
            ),
            child: _PainSinceOptionTile(
              label: options[i],
              selected: selected == options[i],
              onTap: () => onSelect(options[i]),
            ),
          ),
      ],
    );
  }
}

class _PainSinceOptionTile extends StatelessWidget {
  const _PainSinceOptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color borderColor = selected
        ? AppColors.primary
        : AppColors.linePrimary;
    final Color backgroundColor = selected
        ? AppColors.primaryLight
        : AppColors.fillBoxDefault;
    final Color textColor = selected ? AppColors.primary : AppColors.textNormal;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.space12,
          vertical: AppDimens.space14,
        ),
        child: Text(
          label,
          style: AppTextStyles.body16Regular.copyWith(color: textColor),
        ),
      ),
    );
  }
}
