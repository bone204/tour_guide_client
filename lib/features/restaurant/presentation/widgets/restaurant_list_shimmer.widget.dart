import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_guide_app/common_libs.dart';

class RestaurantListShimmer extends StatelessWidget {
  const RestaurantListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlack.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section Placeholder (mimics Stack)
                Stack(
                  children: [
                    Container(
                      height: 180.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.r),
                        ),
                      ),
                    ),
                    // Rating Badge Placeholder (Top Left)
                    Positioned(
                      top: 12.h,
                      left: 12.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        height: 24.h, // Approx height of badge
                        width: 50.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                    // Favorite Button Placeholder (Top Right)
                    Positioned(
                      top: 12.h,
                      right: 12.w,
                      child: Container(
                        height:
                            36.r, // Approx size of favorite button container
                        width: 36.r,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),

                // Content Section Placeholder
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + Cuisine Row
                      Row(
                        children: [
                          // Name Placeholder
                          Expanded(
                            child: Container(
                              height: 20.sp, // Mimic titleSmall fontSize
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          // Cuisine Placeholder
                          Container(
                            height: 24.h,
                            width: 80.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),

                      // Location Row
                      Row(
                        children: [
                          Container(
                            height: 14.w,
                            width: 14.w,
                            color: Colors.white, // Location Icon
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Container(
                              height: 14.sp, // Mimic bodySmall fontSize
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      // Price Placeholder
                      SizedBox(height: 12.h),
                      Container(
                        height: 20.sp, // Mimic displayLarge 16.sp
                        width: 150.w,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
