import 'package:flutter/material.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';

/// 선택 가능한 옵션 카드 (공통 위젯)
///
/// 피드백 화면, 통증 세부 정보 설문 등에서 사용됩니다.
class SelectableOptionCard extends StatelessWidget {
  const SelectableOptionCard({
    super.key,
    required this.selected,
    required this.onTap,
    this.text,
    this.leading,
    this.child,
    this.selectedTextColor,
    this.unselectedBorderColor,
  }) : assert(text != null || child != null, 'text 또는 child 중 하나는 필수입니다.');

  /// 선택 여부
  final bool selected;

  /// 탭 콜백
  final VoidCallback onTap;

  /// 텍스트 라벨 (child가 없을 때 사용)
  final String? text;

  /// 앞쪽 위젯 (아이콘, 이미지, 번호 등)
  final Widget? leading;

  /// 커스텀 자식 위젯 (텍스트 대신 복잡한 레이아웃이 필요할 때 사용)
  final Widget? child;

  /// 선택되었을 때 텍스트 색상 (기본값: textNormal)
  final Color? selectedTextColor;

  /// 선택되지 않았을 때 테두리 색상 (기본값: lineNeutral)
  final Color? unselectedBorderColor;

  @override
  Widget build(BuildContext context) {
    final Color borderColor = selected
        ? AppColors.primary
        : (unselectedBorderColor ?? AppColors.lineNeutral);
    
    final Color backgroundColor = selected
        ? AppColors.primaryLight
        : AppColors.fillBoxDefault;
    
    final Color textColor = selected
        ? (selectedTextColor ?? AppColors.textNormal)
        : AppColors.textNormal;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimens.space14,
          horizontal: AppDimens.space16,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: child ??
            Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: AppDimens.space12),
                ],
                Expanded(
                  child: Text(
                    text!,
                    style: AppTextStyles.body16Medium.copyWith(
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
