import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';

class RestaurantCard extends StatelessWidget {
  final String name;
  final String cuisine;
  final String location;
  final int priceRange;
  final double rating;
  final String imageUrl;
  final VoidCallback? onTap;

  const RestaurantCard({
    super.key,
    required this.name,
    required this.cuisine,
    required this.location,
    required this.priceRange,
    required this.rating,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlack.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with rating badge
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Stack(
                children: [
                  Image.asset(
                    imageUrl,
                    width: double.infinity,
                    height: 120.h,
                    fit: BoxFit.cover,
                  ),
                  // Rating badge
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlack.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppIcons.star,
                            width: 16.w,
                            height: 16.h,
                            color: AppColors.primaryYellow,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            rating.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  // Cuisine
                  Text(
                    cuisine,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSubtitle,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Location
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.location,
                        width: 14.w,
                        height: 14.h,
                        color: AppColors.primaryBlue,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          location,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSubtitle,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // Price
                  Text(
                    "${Formatter.currency(priceRange)} / người",
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

