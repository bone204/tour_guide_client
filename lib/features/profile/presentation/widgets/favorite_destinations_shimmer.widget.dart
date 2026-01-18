import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_guide_app/common_libs.dart';

class FavoriteDestinationsShimmer extends StatelessWidget {
  const FavoriteDestinationsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title shimmer
          Shimmer.fromColors(
            baseColor: AppColors.secondaryGrey.withOpacity(0.3),
            highlightColor: AppColors.secondaryGrey.withOpacity(0.1),
            child: Container(
              width: 150.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: AppColors.secondaryGrey,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Grid shimmer
          MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 16.w,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6, // Show 6 shimmer items
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryWhite,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppColors.secondaryGrey.withOpacity(0.1),
                  ),
                ),
                margin: EdgeInsets.only(bottom: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Shimmer
                    Shimmer.fromColors(
                      baseColor: AppColors.secondaryGrey.withOpacity(0.3),
                      highlightColor: AppColors.secondaryGrey.withOpacity(0.1),
                      child: Container(
                        height: 120.h,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryGrey,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16.r),
                            bottom: Radius.circular(12.r),
                          ),
                        ),
                      ),
                    ),

                    // Content Shimmer
                    Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title line
                          Shimmer.fromColors(
                            baseColor: AppColors.secondaryGrey.withOpacity(0.3),
                            highlightColor: AppColors.secondaryGrey.withOpacity(
                              0.1,
                            ),
                            child: Container(
                              width: 100.w,
                              height: 16.h,
                              decoration: BoxDecoration(
                                color: AppColors.secondaryGrey,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),

                          // Location line
                          Row(
                            children: [
                              Shimmer.fromColors(
                                baseColor: AppColors.secondaryGrey.withOpacity(
                                  0.3,
                                ),
                                highlightColor: AppColors.secondaryGrey
                                    .withOpacity(0.1),
                                child: Container(
                                  width: 14.w,
                                  height: 14.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryGrey,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Shimmer.fromColors(
                                baseColor: AppColors.secondaryGrey.withOpacity(
                                  0.3,
                                ),
                                highlightColor: AppColors.secondaryGrey
                                    .withOpacity(0.1),
                                child: Container(
                                  width: 80.w,
                                  height: 12.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryGrey,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),

                          // Reviews line
                          Shimmer.fromColors(
                            baseColor: AppColors.secondaryGrey.withOpacity(0.3),
                            highlightColor: AppColors.secondaryGrey.withOpacity(
                              0.1,
                            ),
                            child: Container(
                              width: 60.w,
                              height: 12.h,
                              decoration: BoxDecoration(
                                color: AppColors.secondaryGrey,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
