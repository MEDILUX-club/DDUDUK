import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dduduk_app/theme/app_colors.dart';

/// 운동 정보 배지 위젯 (세트, 횟수 등)
class ExerciseInfoBadge extends StatelessWidget {
  const ExerciseInfoBadge({
    super.key,
    required this.iconPath,
    required this.value,
    this.label,
  });

  /// 아이콘 SVG 경로
  final String iconPath;

  /// 표시할 값 (예: 3, 10)
  final int value;

  /// 선택적 라벨 (예: "회", "세트")
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.lineNeutral,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            iconPath,
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(
              AppColors.textNeutral,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$value${label ?? "회"}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textStrong,
            ),
          ),
        ],
      ),
    );
  }
}
