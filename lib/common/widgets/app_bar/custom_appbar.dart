

import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common_libs.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool showBackButton;
  final Color? backgroundColor;
  final Color? titleColor;
  final double elevation;
  final bool centerTitle;
  final Widget? leading;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onBackPressed,
    this.actions,
    this.showBackButton = true,
    this.backgroundColor,
    this.titleColor,
    this.elevation = 0,
    this.centerTitle = true,
    this.leading,
    this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.primaryWhite,
      scrolledUnderElevation: 0,
      elevation: elevation,
      leading: leading ?? (showBackButton ? _buildBackButton(titleColor) : null),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: titleColor ?? AppColors.primaryBlack,
        ),
      ),
      centerTitle: centerTitle,
      actions: actions,
      bottom: bottom ?? _buildDefaultBottom(),
    );
  }

  Widget _buildBackButton(Color? titleColor) {
    return IconButton(
      icon: SvgPicture.asset(
        AppIcons.arrowLeft,
        width: 16.w,
        height: 16.h,
        colorFilter: ColorFilter.mode(
          titleColor ?? AppColors.primaryBlack,
          BlendMode.srcIn,
        ),
      ),
      onPressed: onBackPressed,
      splashRadius: 24,
    );
  }

  PreferredSizeWidget _buildDefaultBottom() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(height: 0.4, color: AppColors.secondaryGrey),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
