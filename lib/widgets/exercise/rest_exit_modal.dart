import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/buttons/primary_button.dart';

/// 운동을 중단하고 나갈지 확인하는 다이얼로그
///
/// [Navigator.pop]을 통해 결과 반환:
/// - true: 나가기
/// - false: 계속하기 (또는 null)
class RestExitModal extends StatelessWidget {
  const RestExitModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20), // 가로 길이를 늘림 (기본값보다 여백 줄임)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0), // 세로 패딩 더 축소
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 경고 아이콘
            SvgPicture.asset(
              'assets/icons/ic_warning.svg',
              width: 60, // 아이콘 크기 약간 축소 (선택사항, 세로 길이 줄이는데 도움됨)
              height: 60,
            ),
            const SizedBox(height: 12), // 간격 축소
            // 제목
            Text(
              '운동을 중단하고 나가시겠어요?',
              style: AppTextStyles.body18SemiBold.copyWith(
                color: AppColors.textStrong,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            // 내용
            Text(
              '언제든 다시 이어서 진행할 수 있어요',
              style: AppTextStyles.body14Medium.copyWith(
                color: AppColors.textNeutral,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20), // 간격 축소
            // 버튼 영역
            Row(
              children: [
                // 계속하기 버튼 (취소)
                Expanded(
                  child: SizedBox(
                    height: 48, // 버튼 세로 길이 줄임 
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.linePrimary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        '계속하기',
                        style: AppTextStyles.body16Medium.copyWith(
                          color: AppColors.textNormal,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // 나가기 버튼 (확인)
                Expanded(
                  child: BaseButton(
                    text: '나가기',
                    onPressed: () => Navigator.of(context).pop(true),
                    fontWeight: FontWeight.w500,
                    height: 48,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
