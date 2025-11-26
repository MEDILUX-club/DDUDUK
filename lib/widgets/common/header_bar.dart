import 'package:flutter/material.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';

class HeaderBar extends StatelessWidget implements PreferredSizeWidget {
  const HeaderBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBack,
  });

  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.fillDefault,
      elevation: 0,
      toolbarHeight: 56,
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              color: AppColors.textNormal,
              onPressed: () {
                if (onBack != null) {
                  onBack!();
                } else {
                  Navigator.of(context).maybePop();
                }
              },
            )
          : const SizedBox.shrink(),
      title: Text(title, style: AppTextStyles.body18SemiBold),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
