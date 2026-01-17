import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_guide_app/common_libs.dart';

class HotelBillDetailShimmer extends StatelessWidget {
  const HotelBillDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Hotel Info Card
            Container(
              height: 120.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            SizedBox(height: 16.h),

            // Booking Details Card
            Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            SizedBox(height: 16.h),

            // Payment Details Card
            Container(
              height: 150.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
