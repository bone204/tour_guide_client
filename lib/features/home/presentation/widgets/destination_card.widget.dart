// ignore_for_file: deprecated_member_use

import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common_libs.dart';

class DestinationCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String rating;
  final String location;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;

  const DestinationCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.location,
    this.onTap,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 360.w,
        margin: EdgeInsets.only(left: 12.w),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlack.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 120.h,
                fit: BoxFit.cover,
              ),
            ),

            // 🔹 Info Section
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 180.w,
                        child: Text(
                          name,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(AppIcons.star, width: 14.w, height: 14.h, color: AppColors.primaryYellow),
                          SizedBox(width: 2.w),
                          Text(
                            rating,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textSubtitle,
                            )
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      SvgPicture.asset(AppIcons.location, width: 14.w, height: 14.h, color: AppColors.primaryGrey),
                      SizedBox(width: 4.w),
                      Text(
                        location,
                        style: Theme.of(context).textTheme.titleSmall,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
