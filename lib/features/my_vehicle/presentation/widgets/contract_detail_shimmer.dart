import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_guide_app/common_libs.dart';

class ContractDetailShimmer extends StatelessWidget {
  const ContractDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            // Status Card Shimmer
            Container(
              height: 100.h,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100.w,
                        height: 24.h,
                        color: Colors.white,
                      ),
                      Container(
                        width: 80.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Sections Shimmer
            _buildSectionShimmer(),
            SizedBox(height: 16.h),
            _buildSectionShimmer(),
            SizedBox(height: 16.h),
            _buildSectionShimmer(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionShimmer() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 150.w, height: 20.h, color: Colors.white),
          SizedBox(height: 24.h),
          _buildRowShimmer(),
          SizedBox(height: 12.h),
          _buildRowShimmer(),
          SizedBox(height: 12.h),
          _buildRowShimmer(),
        ],
      ),
    );
  }

  Widget _buildRowShimmer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(width: 100.w, height: 14.h, color: Colors.white),
        Container(width: 150.w, height: 14.h, color: Colors.white),
      ],
    );
  }
}
