
import 'package:flutter_svg/svg.dart';
import 'package:tour_guide_app/common/widgets/search_bar/custom_search_bar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/typewritter_text.dart';

class AnimatedSliverAppBar extends SliverPersistentHeaderDelegate {
  final double statusBarHeight;
  final double expandedHeight;
  final String title;
  final String subtitle;
  final String hintText;

  AnimatedSliverAppBar({
    required this.statusBarHeight,
    this.expandedHeight = 80, 
    required this.title,
    required this.subtitle,
    required this.hintText,
  });

  @override
  double get minExtent => statusBarHeight.h + 56.h;
  @override
  double get maxExtent => statusBarHeight.h + expandedHeight.h + 40.h;

@override
Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
  final double fadeDistance = maxExtent - minExtent;
  final double fade = (1 - (shrinkOffset / fadeDistance)).clamp(0.0, 1.0);
  final double offsetY = -shrinkOffset * 0.5;

  final double searchBarHeight = 56.h;

  return Stack(
    fit: StackFit.expand,
    children: [
      // Background gradient
      Container(
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
        ),
      ),
      // Title + subtitle, fade theo scroll
      Positioned(
        top: statusBarHeight.h + 12.h + offsetY.h,
        left: 12.w,
        right: 12.w,
        child: Opacity(
          opacity: fade,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(onTap: () {}, child: buildEButton()),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 4.h),
                    TypewriterText(
                      text: subtitle,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      typingDuration: const Duration(milliseconds: 70),
                      holdDuration: const Duration(seconds: 2),
                      fadeDuration: const Duration(milliseconds: 800),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 2.w,
        right: 2.w,
        child: CustomSearchBar(
          height: searchBarHeight,
          hintText: hintText,
        ),
      ),
    ],
  );
}



  @override
  bool shouldRebuild(covariant AnimatedSliverAppBar oldDelegate) => true;
}


Widget buildEButton() {
  return Container(
    width: 48.w,
    height: 48.h,
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12.r),
      shape: BoxShape.rectangle,
    ),
    alignment: Alignment.center,
    child: SvgPicture.asset(
      AppIcons.travel, 
      width: 40.w,
      height: 40.h,
      // ignore: deprecated_member_use
      color: Colors.white, 
    ),
  );
}


