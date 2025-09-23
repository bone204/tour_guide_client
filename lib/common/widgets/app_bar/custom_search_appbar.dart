import 'package:flutter_svg/svg.dart';
import 'package:tour_guide_app/common_libs.dart';

typedef OnSearchChanged = void Function(String value);

class CustomSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final VoidCallback onBack;
  final OnSearchChanged? onSearchChanged;
  final String? hintText;

  const CustomSearchAppBar({
    super.key,
    required this.controller,
    required this.onBack,
    this.onSearchChanged,
    this.hintText,
  });

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryBlue,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          AppIcons.arrowLeft,
          width: 20.w,
          height: 20.h,
          color: AppColors.primaryWhite,
        ),
        onPressed: onBack,
      ),
      title: Padding(
        padding: EdgeInsets.only(right: 16.w),
        child: Container(
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                AppIcons.search,
                width: 20.w,
                height: 20.h,
                color: AppColors.primaryGrey,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: TextField(
                  controller: controller,
                  autofocus: true,
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: hintText ?? 'Tìm kiếm...',
                    border: InputBorder.none,
                    isDense: true,
                    hintStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSubtitle,
                    ),
                  ),
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
