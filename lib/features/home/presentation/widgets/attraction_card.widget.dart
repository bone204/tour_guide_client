// ignore_for_file: deprecated_member_use

import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common_libs.dart';

class AttractionCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final double rating;
  final int reviews;

  const AttractionCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.rating,
    required this.reviews,
  }) : super(key: key);

  // Check if imageUrl is network or asset
  bool get _isNetworkImage => imageUrl.startsWith('http');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlack.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image with rounded corners
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12.r),
                  ),
                  child:
                      _isNetworkImage
                          ? Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: 120.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                AppImage.defaultDestination,
                                width: double.infinity,
                                height: 120.h,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                          : Image.asset(
                            imageUrl,
                            width: double.infinity,
                            height: 120.h,
                            fit: BoxFit.cover,
                          ),
                ),

                /// Rating badge
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
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
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Info
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                SizedBox(height: 8.h),

                /// Location
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

                /// Reviews
                Text(
                  AppLocalizations.of(context)!.reviewsCount(reviews),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSubtitle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
