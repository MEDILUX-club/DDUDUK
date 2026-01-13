import 'package:dduduk_app/layouts/default_layout.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/widgets/common/step_badge.dart';
import 'package:dduduk_app/widgets/common/step_progress_bar.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';

class SurveyLayout extends StatelessWidget {
  const SurveyLayout({
    super.key,
    this.appBarTitle,
    this.title,
    this.titleWidget,
    this.description,
    this.stepLabel,
    this.currentStep = 0,
    this.totalSteps = 0,
    required this.child,
    this.bottomButtons,
    this.showProgressBar = true,
    this.readOnly = false,
  });

  final String? appBarTitle;
  final String? title;
  final Widget? titleWidget;
  final String? description;
  final String? stepLabel;
  final int currentStep;
  final int totalSteps;
  final Widget child;
  final SurveyButtonsConfig? bottomButtons;
  final bool showProgressBar;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final String displayAppBarTitle = readOnly
        ? '설문 응답 확인'
        : (appBarTitle ?? '');
    return DefaultLayout(
      title: displayAppBarTitle,
      bottomNavigationBar: bottomButtons == null
          ? null
          : _BottomButtons(config: bottomButtons!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showProgressBar) ...[
            StepProgressBar(
              currentStep: currentStep,
              totalSteps: totalSteps,
              horizontalBleed: AppDimens.screenPadding,
            ),
          ],
          const SizedBox(height: AppDimens.space24),
          if (stepLabel != null) ...[
            StepBadge(label: stepLabel!),
            const SizedBox(height: AppDimens.space12),
          ],
          _SurveyTitle(title: title, titleWidget: titleWidget, description: description),
          const SizedBox(height: AppDimens.space12),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class SurveyButtonsConfig {
  const SurveyButtonsConfig({
    required this.nextText,
    this.onNext,
    this.prevText,
    this.onPrev,
    this.isNextEnabled = true,
  });

  final String nextText;
  final VoidCallback? onNext;
  final String? prevText;
  final VoidCallback? onPrev;
  final bool isNextEnabled;
}

class _BottomButtons extends StatelessWidget {
  const _BottomButtons({required this.config});

  final SurveyButtonsConfig config;

  @override
  Widget build(BuildContext context) {
    final bool hasPrev = config.prevText != null && config.onPrev != null;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.screenPadding,
          AppDimens.space12,
          AppDimens.screenPadding,
          AppDimens.space16,
        ),
        child: hasPrev
            ? Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: AppDimens.buttonHeight,
                      child: OutlinedButton(
                        onPressed: config.onPrev,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.linePrimary),
                          backgroundColor: AppColors.fillBoxDefault,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          foregroundColor: AppColors.textNormal,
                        ),
                        child: Text(
                          config.prevText!,
                          style: AppTextStyles.body16Medium,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimens.itemSpacing),
                  Expanded(
                    child: SizedBox(
                      height: AppDimens.buttonHeight,
                      child: BaseButton(
                        text: config.nextText,
                        onPressed: config.onNext,
                        isEnabled: config.isNextEnabled,
                      ),
                    ),
                  ),
                ],
              )
            : SizedBox(
                height: AppDimens.buttonHeight,
                child: BaseButton(
                  text: config.nextText,
                  onPressed: config.onNext,
                  isEnabled: config.isNextEnabled,
                ),
              ),
      ),
    );
  }
}

class _SurveyTitle extends StatelessWidget {
  const _SurveyTitle({this.title, this.titleWidget, this.description});

  final String? title;
  final Widget? titleWidget;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (titleWidget != null)
          titleWidget!
        else if (title != null)
          Text(title!, style: AppTextStyles.body20Bold),
        if (description != null) ...[
          const SizedBox(height: AppDimens.space8),
          Text(
            description!,
            style: AppTextStyles.body16Regular.copyWith(
              color: AppColors.textNeutral,
            ),
          ),
        ],
      ],
    );
  }
}
