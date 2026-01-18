import 'package:shimmer/shimmer.dart';
import 'package:tour_guide_app/common_libs.dart';

class DestinationDetailShimmer extends StatelessWidget {
  const DestinationDetailShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Header Image Shimmer (Carousel style)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: double.infinity,
                height: 400.h,
                color: Colors.white,
              ),
            ),
          ),

          // Top App Bar Space (Back and Favorite buttons)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8.h,
            left: 16.w,
            right: 16.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Draggable Bottom Sheet Shimmer
          Positioned(
            top: 300.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Shimmer.fromColors(
                        baseColor: AppColors.secondaryGrey.withOpacity(0.3),
                        highlightColor: AppColors.secondaryGrey.withOpacity(
                          0.1,
                        ),
                        child: Container(
                          width: 40.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryGrey,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Header Info Shimmer
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Shimmer.fromColors(
                          baseColor: AppColors.secondaryGrey.withOpacity(0.3),
                          highlightColor: AppColors.secondaryGrey.withOpacity(
                            0.1,
                          ),
                          child: Container(
                            width: 280.w,
                            height: 28.h,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryGrey,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),

                        // Location
                        Shimmer.fromColors(
                          baseColor: AppColors.secondaryGrey.withOpacity(0.3),
                          highlightColor: AppColors.secondaryGrey.withOpacity(
                            0.1,
                          ),
                          child: Container(
                            width: 200.w,
                            height: 18.h,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryGrey,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Stats Row (Rating, Visitors, etc.)
                        Row(
                          children: List.generate(
                            3,
                            (index) => Padding(
                              padding: EdgeInsets.only(right: 16.w),
                              child: Shimmer.fromColors(
                                baseColor: AppColors.secondaryGrey.withOpacity(
                                  0.3,
                                ),
                                highlightColor: AppColors.secondaryGrey
                                    .withOpacity(0.1),
                                child: Container(
                                  width: 60.w,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryGrey,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Tab Bar Shimmer
                        Row(
                          children: List.generate(
                            3,
                            (index) => Padding(
                              padding: EdgeInsets.only(right: 24.w),
                              child: Shimmer.fromColors(
                                baseColor: AppColors.secondaryGrey.withOpacity(
                                  0.3,
                                ),
                                highlightColor: AppColors.secondaryGrey
                                    .withOpacity(0.1),
                                child: Container(
                                  width: 80.w,
                                  height: 16.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryGrey,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),

                  // Content Shimmer
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: ListView.builder(
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Shimmer.fromColors(
                              baseColor: AppColors.secondaryGrey.withOpacity(
                                0.3,
                              ),
                              highlightColor: AppColors.secondaryGrey
                                  .withOpacity(0.1),
                              child: Container(
                                width: double.infinity,
                                height: 16.h,
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryGrey,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
