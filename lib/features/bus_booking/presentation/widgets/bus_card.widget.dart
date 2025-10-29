import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common_libs.dart';

class BusCard extends StatelessWidget {
  final String busCompany;
  final String busType;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final int availableSeats;
  final double price;
  final double rating;
  final List<String> amenities;
  final VoidCallback onTap;
  final bool isSelected;

  const BusCard({
    Key? key,
    required this.busCompany,
    required this.busType,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.availableSeats,
    required this.price,
    required this.rating,
    required this.amenities,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected 
                ? AppColors.primaryGreen 
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? AppColors.primaryGreen.withOpacity(0.25)
                  : Colors.black.withOpacity(0.2),
              blurRadius: isSelected ? 12 : 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Company & Type
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: SvgPicture.asset(
                    AppIcons.bus,
                    width: 24.w,
                    height: 24.h,
                    color: AppColors.primaryBlue,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        busCompany,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        busType,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSubtitle,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Time Section
            Row(
              children: [
                // Departure
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        departureTime,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppColors.primaryBlue,
                            ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Xuất phát',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSubtitle,
                            ),
                      ),
                    ],
                  ),
                ),

                // Duration & Arrow
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.textSubtitle.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        duration,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: AppColors.textSubtitle,
                            ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Icon(
                      Icons.arrow_forward_sharp,
                      color: AppColors.textSubtitle,
                      size: 20.r,
                    ),
                  ],
                ),

                // Arrival
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        arrivalTime,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppColors.primaryRed,
                            ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Đến nơi',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSubtitle,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),


            SizedBox(height: 16.h),

            Divider(height: 1, color: AppColors.primaryGrey.withOpacity(0.3), thickness: 2),

            SizedBox(height: 12.h),

            // Footer: Seats & Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: availableSeats < 10 
                            ? AppColors.primaryOrange 
                            : AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.event_seat_rounded,
                        size: 18.r,
                        color: AppColors.primaryWhite,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '$availableSeats chỗ trống',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '${price.toStringAsFixed(0)}đ',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

