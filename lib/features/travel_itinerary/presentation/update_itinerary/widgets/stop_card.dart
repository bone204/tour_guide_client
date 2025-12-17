import 'package:flutter/material.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';

class StopCard extends StatelessWidget {
  final Stop stop;
  final VoidCallback? onTap;

  const StopCard({super.key, required this.stop, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              stop.dayOrder.toString(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primaryBlue,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stop.destination!.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 4.h),
                Text(
                  '${stop.startTime} - ${stop.endTime}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSubtitle,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: onTap,
              color: AppColors.primaryGrey,
            ),
        ],
      ),
    );
  }
}
