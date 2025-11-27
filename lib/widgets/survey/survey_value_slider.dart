import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

typedef SliderLabelBuilder = String Function(double value);

class SurveyValueSlider extends StatelessWidget {
  const SurveyValueSlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.labels,
    this.min,
    this.max,
    this.interval,
    this.stepSize,
    this.bubbleTextBuilder,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final Map<double, String> labels;
  final double? min;
  final double? max;
  final double? interval;
  final double? stepSize;
  final SliderLabelBuilder? bubbleTextBuilder;

  @override
  Widget build(BuildContext context) {
    final List<double> sortedKeys = labels.keys.toList()..sort();
    final double resolvedMin =
        min ?? (sortedKeys.isNotEmpty ? sortedKeys.first : 0);
    final double resolvedMax =
        max ?? (sortedKeys.isNotEmpty ? sortedKeys.last : 1);
    final double span = (resolvedMax - resolvedMin).abs();
    final double normalized = span == 0
        ? 0
        : ((value - resolvedMin) / span).clamp(0, 1);
    final double resolvedInterval =
        interval ??
        (sortedKeys.length > 1 ? span / (sortedKeys.length - 1) : span);
    final double resolvedStep = stepSize ?? resolvedInterval;
    final String bubbleText =
        bubbleTextBuilder?.call(value) ??
        labels[value] ??
        value.toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 32,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment(-1 + normalized * 2, 1),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.space12,
                    vertical: AppDimens.space6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    bubbleText,
                    style: AppTextStyles.body12Medium.copyWith(
                      color: AppColors.textWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SfSliderTheme(
          data: SfSliderThemeData(
            activeTrackHeight: 12,
            inactiveTrackHeight: 12,
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.fillBoxDefault,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primaryLight.withValues(alpha: 0.6),
            activeTickColor: AppColors.primary,
            inactiveTickColor: AppColors.primaryLight,
            tickSize: const Size(4, 4),
          ),
          child: SfSlider(
            min: resolvedMin,
            max: resolvedMax,
            interval: resolvedInterval,
            stepSize: resolvedStep,
            value: value,
            showTicks: true,
            showDividers: false,
            enableTooltip: false,
            onChanged: (dynamic newValue) {
              onChanged(newValue as double);
            },
          ),
        ),
        const SizedBox(height: AppDimens.space8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: sortedKeys
              .map(
                (k) => Text(
                  labels[k] ?? '',
                  style: AppTextStyles.body12Regular.copyWith(
                    color: AppColors.textNeutral,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
