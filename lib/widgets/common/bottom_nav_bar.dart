import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';

/// 하단 네비게이션 바 아이템
class BottomNavItem {
  const BottomNavItem({required this.iconPath, required this.label});

  final String iconPath;
  final String label;
}

/// 하단 네비게이션 바 위젯
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItem>? items;

  static const List<BottomNavItem> defaultItems = [
    BottomNavItem(iconPath: 'assets/icons/ic_home.svg', label: '홈'),
    BottomNavItem(iconPath: 'assets/icons/ic_exercise.svg', label: '운동'),
    BottomNavItem(iconPath: 'assets/icons/ic_mypage.svg', label: '마이페이지'),
  ];

  @override
  Widget build(BuildContext context) {
    final navItems = items ?? defaultItems;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: List.generate(navItems.length, (index) {
              final item = navItems[index];
              final isSelected = index == currentIndex;
              return Expanded(
                child: index == 1
                    ? Padding(
                        // 운동 탭을 오른쪽으로 8px 이동
                        padding: const EdgeInsets.only(left: 8),
                        child: _NavItem(
                          iconPath: item.iconPath,
                          label: item.label,
                          isSelected: isSelected,
                          onTap: () => onTap(index),
                        ),
                      )
                    : _NavItem(
                        iconPath: item.iconPath,
                        label: item.label,
                        isSelected: isSelected,
                        onTap: () => onTap(index),
                      ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.iconPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String iconPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.textAssistive;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.body12Regular.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
