import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';

/// 아이콘과 텍스트를 함께 표시하는 라벨 위젯
class IconLabel extends StatelessWidget {
  const IconLabel({
    super.key,
    required this.icon,
    required this.text,
    this.iconSize = 20,
    this.iconColor,
    this.textStyle,
    this.spacing = 6,
  });

  /// 표시할 아이콘
  final IconData icon;

  /// 표시할 텍스트
  final String text;

  /// 아이콘 크기 (기본값: 20)
  final double iconSize;

  /// 아이콘 색상 (기본값: AppColors.primary)
  final Color? iconColor;

  /// 텍스트 스타일 (기본값: body14Medium + textNeutral)
  final TextStyle? textStyle;

  /// 아이콘과 텍스트 사이 간격 (기본값: 6)
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: iconSize,
          color: iconColor ?? AppColors.primary,
        ),
        SizedBox(width: spacing),
        Text(
          text,
          style: textStyle ??
              AppTextStyles.body14Medium.copyWith(
                color: AppColors.textNeutral,
              ),
        ),
      ],
    );
  }
}

/// 운동 루틴 데이터 클래스
class ExerciseRoutineData {
  const ExerciseRoutineData({
    required this.name,
    required this.sets,
    required this.reps,
    this.difficulty,
    this.imagePath,
  });

  /// 운동 이름
  final String name;

  /// 세트 수
  final int sets;

  /// 횟수
  final int reps;

  /// 난이도 (1~4)
  final int? difficulty;

  /// 운동 이미지 경로 (optional)
  final String? imagePath;
}

/// 운동 루틴 카드 위젯
class ExerciseRoutineCard extends StatelessWidget {
  const ExerciseRoutineCard({
    super.key,
    required this.exercise,
  });

  final ExerciseRoutineData exercise;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lineNeutral),
      ),
      child: Row(
        children: [
          // 운동 이미지 플레이스홀더
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.fillDefault,
              borderRadius: BorderRadius.circular(8),
            ),
            child: exercise.imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(exercise.imagePath!, fit: BoxFit.cover),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          // 운동 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 운동 이름 + 난이도
                Row(
                  children: [
                    Text(
                      exercise.name,
                      style: AppTextStyles.body16Regular.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textStrong,
                      ),
                    ),
                    if (exercise.difficulty != null) ...[
                      const SizedBox(width: 8),
                      // 난이도 라벨
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0x4DC7F2E2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '난이도',
                              style: AppTextStyles.body12Regular.copyWith(
                                color: AppColors.primary,
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(width: 4),
                            // 난이도 점
                            ...List.generate(4, (index) {
                              return Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.only(right: 2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index < exercise.difficulty!
                                      ? AppColors.primary
                                      : AppColors.linePrimary,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                // 세트/횟수 정보
                Row(
                  children: [
                    // 세트 아이콘 + 텍스트
                    SvgPicture.asset(
                      'assets/icons/ic_set.svg',
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        AppColors.textAssistive,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${exercise.sets}세트',
                      style: AppTextStyles.body14Regular.copyWith(
                        color: AppColors.textAssistive,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 횟수 아이콘 + 텍스트
                    SvgPicture.asset(
                      'assets/icons/ic_lap.svg',
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        AppColors.textAssistive,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${exercise.reps}회',
                      style: AppTextStyles.body14Regular.copyWith(
                        color: AppColors.textAssistive,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
