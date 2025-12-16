import 'package:shimmer/shimmer.dart';
import 'package:tour_guide_app/common_libs.dart';

class ShimmerItineraryList extends StatelessWidget {
  const ShimmerItineraryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      itemCount: 5, // Show 5 placeholder items
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image placeholder
                Container(
                  height: 150.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.r),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title placeholder
                      Container(
                        width: 200.w,
                        height: 20.h,
                        color: Colors.white,
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          // Date range placeholder
                          Container(
                            width: 100.w,
                            height: 16.h,
                            color: Colors.white,
                          ),
                          SizedBox(width: 16.w),
                          // Destination count placeholder
                          Container(
                            width: 80.w,
                            height: 16.h,
                            color: Colors.white,
                          ),
                        ],
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
