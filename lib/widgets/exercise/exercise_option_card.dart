import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';

/// 운동 설문에서 사용하는 선택 카드 위젯
class ExerciseOptionCard extends StatelessWidget {
  const ExerciseOptionCard({
    super.key,
    required this.label,
    required this.imagePath,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String imagePath;
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
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: selected ? 2 : 1),
        ),
        padding: const EdgeInsets.symmetric(vertical: AppDimens.space16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildImage(),
            const SizedBox(height: AppDimens.space12),
            Text(
              label,
              style: AppTextStyles.body14Medium.copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// 이미지 경로에 따라 SVG 또는 PNG 이미지 렌더링
  Widget _buildImage() {
    if (imagePath.endsWith('.svg')) {
      return SvgPicture.asset(
        imagePath,
        width: 64,
        height: 64,
        fit: BoxFit.contain,
      );
    } else {
      return Image.asset(imagePath, width: 64, height: 64, fit: BoxFit.contain);
    }
  }
}

/// 운동 옵션 데이터 클래스
class ExerciseOption {
  const ExerciseOption({
    required this.label,
    required this.imagePath,
    required this.value,
  });

  final String label;
  final String imagePath;
  final int value;
}
