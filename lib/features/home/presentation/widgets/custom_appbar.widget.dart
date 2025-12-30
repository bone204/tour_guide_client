import 'package:badges/badges.dart' as badges;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/search_bar/custom_search_bar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/typewritter_text.dart';
import 'package:tour_guide_app/features/notifications/presentation/bloc/notification_cubit.dart';

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
  double get minExtent => statusBarHeight.h + 60.h;
  @override
  double get maxExtent => statusBarHeight.h + expandedHeight.h + 40.h;

  void _openSearchPage(BuildContext context) {
    Navigator.of(context).pushNamed(AppRouteConstant.homeSearch);
  }

  void _openNotificationPage(BuildContext context) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(AppRouteConstant.notification);
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double fadeDistance = maxExtent - minExtent;
    final double fade = (1 - (shrinkOffset / fadeDistance)).clamp(0.0, 1.0);
    final double offsetY = -shrinkOffset * 0.5;

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(decoration: BoxDecoration(color: AppColors.primaryBlue)),
        Positioned(
          top: statusBarHeight.h + 4.h + offsetY.h,
          left: 12.w,
          right: 12.w,
          height: 60.h, // Add specific height constraint
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                      SizedBox(height: 4.h),
                      TypewriterText(
                        text: subtitle,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(color: AppColors.textSecondary),
                        typingDuration: const Duration(milliseconds: 70),
                        holdDuration: const Duration(seconds: 2),
                        fadeDuration: const Duration(milliseconds: 800),
                      ),
                    ],
                  ),
                ),
                // Notification button removed from here
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0.h,
          left: 2.w,
          right: 8.w,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CustomSearchBar(
                  hintText: hintText,
                  onTap: () => _openSearchPage(context),
                ),
              ),
              _buildNotificationButton(context),
              SizedBox(width: 4.w), // Slight padding on right
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _openNotificationPage(context),
      child: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          int unreadCount = 0;
          if (state is NotificationLoaded) {
            unreadCount = state.unreadCount;
          }

          return badges.Badge(
            position: badges.BadgePosition.topEnd(top: 0, end: 0),
            showBadge: unreadCount > 0,
            badgeContent: Text(
              unreadCount > 99 ? '99+' : '$unreadCount',
              style: TextStyle(color: Colors.white, fontSize: 10.sp),
            ),
            badgeStyle: const badges.BadgeStyle(
              badgeColor: Colors.red,
              padding: EdgeInsets.all(4),
            ),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
          );
        },
      ),
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
