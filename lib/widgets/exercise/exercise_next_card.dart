import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';

/// 다음 운동 정보를 표시하는 카드 위젯
///
/// [exerciseName] - 운동 이름
/// [sets] - 세트 수
/// [reps] - 횟수
/// [imagePath] - 운동 이미지 경로 (optional)
class ExerciseNextCard extends StatelessWidget {
  const ExerciseNextCard({
    super.key,
    required this.exerciseName,
    required this.sets,
    required this.reps,
    this.imagePath,
  });

  /// 운동 이름
  final String exerciseName;

  /// 세트 수
  final int sets;

  /// 횟수
  final int reps;

  /// 운동 이미지 경로 (optional)
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lineNeutral),
      ),
      child: Row(
        children: [
          // 운동 이미지
          _buildImage(),
          const SizedBox(width: 16),
          // 운동 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 운동 이름
                Text(
                  exerciseName,
                  style: AppTextStyles.body16Regular.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textStrong,
                  ),
                ),
                const SizedBox(height: 4),
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
                      '$sets세트',
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
                      '$reps회',
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

  /// 운동 이미지 빌드
  Widget _buildImage() {
    if (imagePath == null || imagePath!.isEmpty) {
      // 기본 플레이스홀더
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.fillDefault,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(
            Icons.fitness_center,
            size: 32,
            color: AppColors.textAssistive,
          ),
        ),
      );
    }

    // SVG 또는 일반 이미지
    if (imagePath!.endsWith('.svg')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SvgPicture.asset(
          imagePath!,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          imagePath!,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.fillDefault,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.image_not_supported,
              size: 32,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }
  }
}
