
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common_libs.dart';

class CustomSearchBar extends StatelessWidget {
  final double height;
  final String hintText;

  const CustomSearchBar({super.key, this.height = 56, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 12.w, right: 8.w),
            child: SvgPicture.asset(
              AppIcons.search,
              width: 20.w,
              height: 20.h,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryGrey,
                BlendMode.srcIn,
              ),
            ),
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 40.w,
            minHeight: 40.h,
          ),
          hintText: hintText,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.textSubtitle),
          filled: true,
          fillColor: AppColors.primaryWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
