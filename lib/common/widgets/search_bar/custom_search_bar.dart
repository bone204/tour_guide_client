import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/typewritter_text.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;

  const CustomSearchBar({
    super.key,
    required this.hintText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44.h,
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 8.w),
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
            Expanded(
              child: TypewriterText(
                text: hintText,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSubtitle,
                ),
                typingDuration: const Duration(milliseconds: 70),
                holdDuration: const Duration(seconds: 2),
                fadeDuration: const Duration(milliseconds: 800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
