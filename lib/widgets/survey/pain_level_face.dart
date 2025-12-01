import 'package:flutter/material.dart';
import 'package:dduduk_app/theme/app_colors.dart';

class PainLevelFace extends StatelessWidget {
  const PainLevelFace({super.key, required this.painLevel, this.size = 120});

  final double painLevel;
  final double size;

  String _getFaceImage() {
    if (painLevel <= 0) return 'assets/images/img_face_0.png';
    if (painLevel <= 2) return 'assets/images/img_face_2.png';
    if (painLevel <= 4) return 'assets/images/img_face_4.png';
    if (painLevel <= 6) return 'assets/images/img_face_6.png';
    if (painLevel <= 8) return 'assets/images/img_face_8.png';
    return 'assets/images/img_face_10.png';
  }

  String getDescription() {
    if (painLevel <= 0) return '전혀 아프지 않아요';
    if (painLevel <= 2) return '살짝 불편해요';
    if (painLevel <= 4) return '통증이 느껴지고 신경 쓰여요';
    if (painLevel <= 6) return '일상 생활에 지장이 있을 정도로 아파요';
    if (painLevel <= 8) return '많이 아프고 힘들어요';
    return '잠을 못 잘 정도로 아프고 고통스러워요';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryLight,
        border: Border.all(color: AppColors.primary, width: 3),
      ),
      padding: EdgeInsets.all(size * 0.2),
      child: Image.asset(_getFaceImage(), fit: BoxFit.contain),
    );
  }
}

class PainLevelSlider extends StatelessWidget {
  const PainLevelSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final double value;
  final Function(dynamic) onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double trackWidth = constraints.maxWidth;
        final double thumbSize = 32;
        final double dotSize = 8;
        final double trackHeight = 14;
        final int dotCount = 6; // 0, 2, 4, 6, 8, 10
        final double activeWidth = (value / 10) * trackWidth;

        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            final double localX = details.localPosition.dx;
            final double percent = (localX / trackWidth).clamp(0.0, 1.0);
            final double newValue = (percent * 10).roundToDouble();
            final double snappedValue = (newValue / 2).round() * 2.0;
            onChanged(snappedValue.clamp(0.0, 10.0));
          },
          onTapDown: (details) {
            final double localX = details.localPosition.dx;
            final double percent = (localX / trackWidth).clamp(0.0, 1.0);
            final double newValue = (percent * 10).roundToDouble();
            final double snappedValue = (newValue / 2).round() * 2.0;
            onChanged(snappedValue.clamp(0.0, 10.0));
          },
          child: SizedBox(
            height: thumbSize + 8,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // 비활성 트랙 (회색 실선, 불투명)
                Positioned(
                  left: 0,
                  right: 0,
                  child: Container(
                    height: trackHeight,
                    decoration: BoxDecoration(
                      color: AppColors.fillDefault,
                      borderRadius: BorderRadius.circular(trackHeight / 2),
                    ),
                  ),
                ),
                // 도트 (비활성 영역만 표시)
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(dotCount, (index) {
                      final double dotPosition = index / (dotCount - 1);
                      final bool isInActiveArea = dotPosition <= (value / 10);
                      // 활성 영역의 도트는 숨김
                      if (isInActiveArea) {
                        return SizedBox(width: dotSize, height: dotSize);
                      }
                      return Container(
                        width: dotSize,
                        height: dotSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primarySecondary.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                // 활성 트랙 (투명도 있음)
                Positioned(
                  left: 0,
                  child: Container(
                    width: activeWidth.clamp(0, trackWidth),
                    height: trackHeight,
                    decoration: BoxDecoration(
                      color: AppColors.primarySecondary.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(trackHeight / 2),
                    ),
                  ),
                ),
                // 썸 (Thumb)
                Positioned(
                  left: (activeWidth - thumbSize / 2).clamp(
                    0,
                    trackWidth - thumbSize,
                  ),
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryLight,
                      border: Border.all(color: AppColors.primary, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
