import 'package:flutter/material.dart';

abstract class AppColors {
  // 인스턴스화 방지 (굳이 AppColors()로 객체를 만들 필요가 없으므로)
  AppColors._();

  // ===========================================================================
  // Fill (배경색)
  // ===========================================================================
  /// 기본 배경색 (메인 화면 배경) - #F5F5F5
  static const Color fillDefault = Color(0xFFF5F5F5);

  /// 박스 내부 배경색 (카드, 컨테이너 등) - #FCFCFC
  static const Color fillBoxDefault = Color(0xFFFCFCFC);

  /// 옵션/선택지 배경색 - #FCFCFC
  static const Color fillOption = Color(0xFFFCFCFC);

  // ===========================================================================
  // Text (글자색)
  // ===========================================================================
  /// 일반 텍스트 (본문 등) - #1F1F1F
  static const Color textNormal = Color(0xFF1F1F1F);

  /// 강조 텍스트 (제목 등) - #141414
  static const Color textStrong = Color(0xFF141414);

  /// 중립 텍스트 (설명글 등) - #454545
  static const Color textNeutral = Color(0xFF454545);

  /// 보조 텍스트 (힌트, 비활성 텍스트 전 단계) - #8C8C8C
  static const Color textAssistive = Color(0xFF8C8C8C);

  /// 비활성 텍스트 (입력 불가 등) - #BFBFBF
  static const Color textDisabled = Color(0xFFBFBFBF);

  /// 흰색 텍스트 (어두운 배경 위) - #FCFCFC
  static const Color textWhite = Color(0xFFFCFCFC);

  // ===========================================================================
  // Primary (브랜드 메인 컬러 - 초록 계열)
  // ===========================================================================
  /// 메인 컬러 (버튼, 활성 상태 등) - #17CA88
  static const Color primary = Color(0xFF17CA88);

  /// 메인 어두운 버전 (클릭 시 효과 등) - #108F61
  static const Color primaryDark = Color(0xFF108F61);

  /// 메인 보조 (그라데이션 등) - #6DDEB4
  static const Color primarySecondary = Color(0xFF6DDEB4);

  /// 메인 밝은 버전 (배경 포인트 등) - #C7F2E2
  static const Color primaryLight = Color(0xFFC7F2E2);

  // ===========================================================================
  // Line (테두리, 구분선)
  // ===========================================================================
  /// 주요 테두리 (입력창, 버튼 테두리) - #D9D9D9
  static const Color linePrimary = Color(0xFFD9D9D9);

  /// 보조 테두리 (리스트 구분선 등) - #F0F0F0
  static const Color lineNeutral = Color(0xFFF0F0F0);

  // ===========================================================================
  // Status (상태 표시)
  // ===========================================================================
  /// 긍정/성공 (파랑) - #335CFF
  static const Color statusPositive = Color(0xFF335CFF);

  /// 부정/오류/삭제 (빨강) - #FF5E5E
  static const Color statusDestructive = Color(0xFFFF5E5E);

  /// 주의/경고 (주황) - #FF932E
  static const Color statusCautionary = Color(0xFFFF932E);

  // ===========================================================================
  // Interaction (버튼 상태 등)
  // ===========================================================================
  /// 비활성 상태 아이콘/버튼 - #8C8C8C
  static const Color interactionInactive = Color(0xFF8C8C8C);

  /// 활성 상태 아이콘/버튼 - #D9D9D9
  static const Color interactionActive = Color(0xFFD9D9D9);

  /// 사용 불가 상태 - #F0F0F0
  static const Color interactionDisabled = Color(0xFFF0F0F0);
}
