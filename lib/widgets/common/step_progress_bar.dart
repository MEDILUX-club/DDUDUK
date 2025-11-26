import 'package:dduduk_app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class StepProgressBar extends StatelessWidget {
  const StepProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.horizontalBleed = 0,
  });

  final int currentStep;
  final int totalSteps;
  final double horizontalBleed;

  @override
  Widget build(BuildContext context) {
    final double progress = totalSteps == 0
        ? 0
        : (currentStep.clamp(0, totalSteps) / totalSteps);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double bleed = horizontalBleed;
        final double barWidth = constraints.maxWidth + bleed * 2;

        return Transform.translate(
          offset: Offset(-bleed, 0),
          child: SizedBox(
            width: barWidth,
            height: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: progress,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
