import 'package:flutter/material.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/common/bottom_nav_bar.dart';

/// 홈 화면용 레이아웃 (AppBar + BottomNavBar 포함)
///
/// 운동하기, 홈 등 하단 네비게이션이 있는 메인 화면에서 사용합니다.
/// DefaultLayout과 동일한 패딩(AppDimens.screenPadding)을 사용합니다.
class HomeLayout extends StatelessWidget {
  const HomeLayout({
    super.key,
    required this.title,
    required this.child,
    required this.currentNavIndex,
    required this.onNavTap,
    this.backgroundColor = AppColors.fillDefault,
    this.actions,
    this.scrollable = true,
  });

  /// AppBar 제목
  final String title;

  /// 화면 콘텐츠
  final Widget child;

  /// 현재 선택된 네비게이션 인덱스
  final int currentNavIndex;

  /// 네비게이션 탭 콜백
  final ValueChanged<int> onNavTap;

  /// 배경색 (기본: fillDefault)
  final Color backgroundColor;

  /// AppBar 오른쪽 액션 버튼들
  final List<Widget>? actions;

  /// 스크롤 가능 여부 (기본: true)
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: backgroundColor,
        foregroundColor: AppColors.textStrong,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        titleTextStyle: AppTextStyles.titleHeader.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        actions: actions,
      ),
      // DefaultLayout과 동일한 패딩 적용
      body: SafeArea(
        child: scrollable
            ? SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.screenPadding,
                ),
                child: child,
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.screenPadding,
                ),
                child: child,
              ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentNavIndex,
        onTap: onNavTap,
      ),
    );
  }
}
