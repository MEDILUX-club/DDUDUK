import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';

/// 홈 화면의 회복상태 카드 위젯
class RecoveryStatusCard extends StatelessWidget {
  const RecoveryStatusCard({
    super.key,
    required this.userName,
    required this.recoveryPercent,
  });

  /// 사용자 이름
  final String userName;

  /// 회복 퍼센트 (0~100)
  final int recoveryPercent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.space20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // 왼쪽: 텍스트 영역
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 회복상태 라벨
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.textWhite.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/ic_heartbeat.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            AppColors.textWhite,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimens.space8),
                    Text(
                      '회복상태',
                      style: AppTextStyles.body14Medium.copyWith(
                        color: AppColors.textWhite,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.space16),
                // 회복 메시지
                Text(
                  '$userName님의 무릎 회복정도는',
                  style: AppTextStyles.body14Regular.copyWith(
                    color: AppColors.textWhite.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: AppDimens.space4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$recoveryPercent%',
                      style: AppTextStyles.body20Bold.copyWith(
                        color: AppColors.textWhite,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: AppDimens.space8),
                    Text(
                      '입니다',
                      style: AppTextStyles.body16Medium.copyWith(
                        color: AppColors.textWhite,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 오른쪽: 원형 프로그레스
          _CircularProgress(percent: recoveryPercent),
        ],
      ),
    );
  }
}

/// 원형 프로그레스 위젯
class _CircularProgress extends StatelessWidget {
  const _CircularProgress({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 배경 원
          SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 10,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.textWhite.withValues(alpha: 0.2),
              ),
            ),
          ),
          // 진행 원
          SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              value: percent / 100,
              strokeWidth: 10,
              strokeCap: StrokeCap.round,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.textWhite,
              ),
            ),
          ),
          // 퍼센트 텍스트
          Text(
            '$percent%',
            style: AppTextStyles.body18SemiBold.copyWith(
              color: AppColors.textWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
