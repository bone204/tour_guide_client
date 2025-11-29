import 'package:shimmer/shimmer.dart';
import 'package:tour_guide_app/common_libs.dart';

// Shimmer cho Voucher Carousel
class SliverVoucherCarouselShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withOpacity(0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
              child: Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: AppColors.secondaryGrey.withOpacity(0.3),
                    highlightColor: AppColors.secondaryGrey.withOpacity(0.1),
                    child: Container(
                      width: 28.w,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryGrey,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Shimmer.fromColors(
                    baseColor: AppColors.secondaryGrey.withOpacity(0.3),
                    highlightColor: AppColors.secondaryGrey.withOpacity(0.1),
                    child: Container(
                      width: 150.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryGrey,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: 140.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: Shimmer.fromColors(
                      baseColor: AppColors.secondaryGrey.withOpacity(0.3),
                      highlightColor: AppColors.secondaryGrey.withOpacity(0.1),
                      child: Container(
                        width: 280.w,
                        height: 140.h,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryGrey,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Shimmer cho Popular Destination List
class SliverPopularDestinationListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          color: AppColors.primaryOrange.withOpacity(0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: AppColors.secondaryGrey.withOpacity(0.3),
                    highlightColor: AppColors.secondaryGrey.withOpacity(0.1),
                    child: Container(
                      width: 120.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryGrey,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Shimmer.fromColors(
                    baseColor: AppColors.secondaryGrey.withOpacity(0.3),
                    highlightColor: AppColors.secondaryGrey.withOpacity(0.1),
                    child: Container(
                      width: 200.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryGrey,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 300.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 16.w),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: Shimmer.fromColors(
                      baseColor: AppColors.secondaryGrey.withOpacity(0.3),
                      highlightColor: AppColors.secondaryGrey.withOpacity(0.1),
                      child: Container(
                        width: 280.w,
                        height: 300.h,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryGrey,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Shimmer cho Nearby Destination List
class SliverNearbyDestinationListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: AppColors.secondaryGrey.withOpacity(0.3),
              highlightColor: AppColors.secondaryGrey.withOpacity(0.1),
              child: Container(
                width: 180.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: AppColors.secondaryGrey,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 200.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: Shimmer.fromColors(
                      baseColor: AppColors.secondaryGrey.withOpacity(0.3),
                      highlightColor: AppColors.secondaryGrey.withOpacity(0.1),
                      child: Container(
                        width: 160.w,
                        height: 200.h,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryGrey,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Shimmer cho Hotel List
class SliverHotelNearbyDestinationListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            SizedBox(height: 12.h),
            SizedBox(
              height: 200.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: Shimmer.fromColors(
                      baseColor: AppColors.secondaryGrey.withOpacity(0.3),
                      highlightColor: AppColors.secondaryGrey.withOpacity(0.1),
                      child: Container(
                        width: 160.w,
                        height: 200.h,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryGrey,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Shimmer cho Restaurant List
class SliverRestaurantNearbyDestinationListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: AppColors.secondaryGrey.withOpacity(0.3),
              highlightColor: AppColors.secondaryGrey.withOpacity(0.1),
              child: Container(
                width: 160.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: AppColors.secondaryGrey,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 200.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: Shimmer.fromColors(
                      baseColor: AppColors.secondaryGrey.withOpacity(0.3),
                      highlightColor: AppColors.secondaryGrey.withOpacity(0.1),
                      child: Container(
                        width: 160.w,
                        height: 200.h,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryGrey,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Shimmer cho Attraction List
class SliverRestaurantNearbyAttractionListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: AppColors.secondaryGrey.withOpacity(0.3),
              highlightColor: AppColors.secondaryGrey.withOpacity(0.1),
              child: Container(
                width: 170.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: AppColors.secondaryGrey,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 200.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: Shimmer.fromColors(
                      baseColor: AppColors.secondaryGrey.withOpacity(0.3),
                      highlightColor: AppColors.secondaryGrey.withOpacity(0.1),
                      child: Container(
                        width: 160.w,
                        height: 200.h,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryGrey,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

