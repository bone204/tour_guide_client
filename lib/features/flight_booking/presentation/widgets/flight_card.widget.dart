import 'package:tour_guide_app/common_libs.dart';

class FlightCard extends StatelessWidget {
  final String flightNumber;
  final String airline;
  final String airlineLogo;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final int stops;
  final Map<String, int> availableSeats; // seat class -> available count
  final Map<String, double> prices; // seat class -> price
  final double rating;
  final VoidCallback onTap;
  final bool isSelected;

  const FlightCard({
    Key? key,
    required this.flightNumber,
    required this.airline,
    required this.airlineLogo,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.stops,
    required this.availableSeats,
    required this.prices,
    required this.rating,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the cheapest price
    final minPrice = prices.values.reduce((a, b) => a < b ? a : b);

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
            // Header: Airline Logo, Flight Number & Rating
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.flight_rounded,
                    size: 24.r,
                    color: AppColors.primaryBlue,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        airline,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        flightNumber,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSubtitle,
                            ),
                      ),
                    ],
                  ),
                ),
                // Rating
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 16.r,
                        color: AppColors.primaryGreen,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        rating.toString(),
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.w600,
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
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Khởi hành',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSubtitle,
                            ),
                      ),
                    ],
                  ),
                ),

                // Duration & Stops
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
                    Row(
                      children: [
                        if (stops == 0)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'Bay thẳng',
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    color: AppColors.primaryGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          )
                        else
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppColors.primaryOrange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              '$stops điểm dừng',
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    color: AppColors.primaryOrange,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                      ],
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
                              fontWeight: FontWeight.w700,
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

            // Seat Classes & Price
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: availableSeats.entries.map((entry) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: entry.value > 0 
                              ? AppColors.primaryGreen.withOpacity(0.1)
                              : AppColors.textSubtitle.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: entry.value > 0 
                                ? AppColors.primaryGreen.withOpacity(0.3)
                                : AppColors.textSubtitle.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          '${entry.key}: ${entry.value}',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: entry.value > 0 
                                    ? AppColors.primaryGreen
                                    : AppColors.textSubtitle,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Từ ${minPrice.toStringAsFixed(0)}đ',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
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

