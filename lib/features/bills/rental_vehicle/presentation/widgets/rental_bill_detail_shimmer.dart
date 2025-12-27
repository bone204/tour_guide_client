import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_guide_app/common_libs.dart';

class RentalBillDetailShimmer extends StatelessWidget {
  const RentalBillDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status section
            _buildPlaceholder(width: 80.w, height: 16.h),
            SizedBox(height: 4.h),
            _buildPlaceholder(width: 120.w, height: 24.h),
            SizedBox(height: 12.h),
            const Divider(),

            // Info rows
            _buildInfoRowPlaceholder(),
            _buildInfoRowPlaceholder(),
            _buildInfoRowPlaceholder(),
            _buildInfoRowPlaceholder(),

            const Divider(),

            // Vehicle list header
            SizedBox(height: 16.h),
            _buildPlaceholder(width: 150.w, height: 20.h),
            SizedBox(height: 8.h),

            // Vehicle items
            _buildVehicleItemPlaceholder(),
            _buildVehicleItemPlaceholder(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }

  Widget _buildInfoRowPlaceholder() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPlaceholder(width: 100.w, height: 16.h),
          _buildPlaceholder(width: 120.w, height: 16.h),
        ],
      ),
    );
  }

  Widget _buildVehicleItemPlaceholder() {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      height: 72.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
    );
  }
}
