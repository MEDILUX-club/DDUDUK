import 'package:flutter/material.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';

class ButtonGroup extends StatelessWidget {
  const ButtonGroup({
    super.key,
    required this.onMainPressed,
    required this.onSubPressed,
    required this.mainText,
    required this.subText,
    this.isMainEnabled = true,
    this.isSubEnabled = true,
  });

  final VoidCallback onMainPressed;
  final VoidCallback onSubPressed;
  final String mainText;
  final String subText;
  final bool isMainEnabled;
  final bool isSubEnabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 56,
            child: OutlinedButton(
              onPressed: isSubEnabled ? onSubPressed : null,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.linePrimary),
                backgroundColor: AppColors.fillBoxDefault,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                foregroundColor: AppColors.textNormal,
              ),
              child: Text(subText, style: AppTextStyles.body14Medium),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: BaseButton(
            text: mainText,
            onPressed: onMainPressed,
            isEnabled: isMainEnabled,
          ),
        ),
      ],
    );
  }
}
