import 'package:flutter/material.dart';
import 'app_colors.dart'; // 아까 만든 컬러 파일 import

class AppTextStyles {
  static const String fontFamily = 'Pretendard';

  // ===========================================================================
  // 24px (Title)
  // ===========================================================================

  // title/header (SemiBold)
  static const TextStyle titleHeader = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.6, // 160%
    letterSpacing: 0,
    color: AppColors.textNormal, // 기본 검정색
  );

  // title/text1 (Bold)
  static const TextStyle titleText1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700, // Bold
    height: 1.6,
    letterSpacing: 0,
    color: AppColors.textNormal,
  );

  // ===========================================================================
  // 20px (Body)
  // ===========================================================================

  static const TextStyle body20SemiBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.6,
    color: AppColors.textNormal,
  );

  static const TextStyle body20Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.6,
    color: AppColors.textNormal,
  );

  // ===========================================================================
  // 18px (Body)
  // ===========================================================================

  static const TextStyle body18SemiBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.6,
    color: AppColors.textNormal,
  );

  static const TextStyle body18Medium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500, // Medium
    height: 1.6,
    color: AppColors.textNormal,
  );

  // ===========================================================================
  // 16px (Body)
  // ===========================================================================

  static const TextStyle body16Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    height: 1.6,
    color: AppColors.textNormal,
  );

  // ===========================================================================
  // 14px (Body)
  // ===========================================================================

  static const TextStyle body14Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    height: 1.6,
    color: AppColors.textNormal,
  );

  static const TextStyle body14Medium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.6,
    color: AppColors.textNormal,
  );

  // ===========================================================================
  // 12px (Body - 자간 -3% 적용됨)
  // ===========================================================================

  // 계산: 12 * -0.03 = -0.36
  static const TextStyle body12Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: -0.36, // Figma -3% 반영
    color: AppColors.textNormal,
  );

  static const TextStyle body12Medium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.6,
    letterSpacing: -0.36, // Figma -3% 반영
    color: AppColors.textNormal,
  );
}
