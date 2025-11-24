import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class PainLevelSlider extends StatelessWidget {
  const PainLevelSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final double value;
  final Function(dynamic) onChanged;

  String _tooltipText(double painValue) {
    if (painValue <= 0) {
      return '전혀 안 아픔';
    } else if (painValue <= 4) {
      return '약함';
    } else if (painValue <= 8) {
      return '아픔';
    } else {
      return '매우 아픔';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SfSliderTheme(
      data: SfSliderThemeData(
        activeTrackHeight: 12,
        inactiveTrackHeight: 12,
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.fillBoxDefault,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primaryLight.withValues(alpha: 0.6),
        tooltipBackgroundColor: AppColors.primary,
        tooltipTextStyle: AppTextStyles.body12Medium.copyWith(
          color: AppColors.textWhite,
        ),
        activeTickColor: AppColors.primary,
        inactiveTickColor: AppColors.primaryLight,
        tickSize: const Size(4, 4),
      ),
      child: SfSlider(
        min: 0.0,
        max: 10.0,
        interval: 2,
        stepSize: 2,
        value: value,
        showTicks: true,
        shouldAlwaysShowTooltip: true,
        onChanged: onChanged,
        tooltipTextFormatterCallback: (dynamic actualValue, String _) {
          return _tooltipText(actualValue.toDouble());
        },
      ),
    );
  }
}
