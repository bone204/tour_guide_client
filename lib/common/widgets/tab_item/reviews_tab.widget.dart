import 'package:flutter_svg/svg.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/destination/presentation/widgets/comment/destination_comment.widget.dart';
import 'package:tour_guide_app/features/hotel/presentation/widgets/comment/hotel_comment.widget.dart';
import 'package:tour_guide_app/features/restaurant/presentation/widgets/comment/restaurant_comment.widget.dart';

class ReviewsTab extends StatelessWidget {
  final int? destinationId;
  final int? hotelId;
  final int? restaurantId;

  const ReviewsTab({
    super.key,
    this.destinationId,
    this.hotelId,
    this.restaurantId,
  });

  @override
  Widget build(BuildContext context) {
    if (destinationId != null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: DestinationCommentWidget(destinationId: destinationId!),
      );
    }
    if (hotelId != null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: HotelCommentWidget(hotelId: hotelId!),
      );
    }
    if (restaurantId != null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: RestaurantCommentWidget(restaurantId: restaurantId!),
      );
    }
    // Fallback Mock Data
    return Column(
      children: [
        ...List.generate(4, (index) {
          return Column(
            children: [
              _buildReviewItem(context, index),
              if (index < 3) SizedBox(height: 16.h),
            ],
          );
        }),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildReviewItem(BuildContext context, int index) {
    final names = ['John Doe', 'Sarah Smith', 'Mike Johnson', 'Emma Wilson'];
    final dates = ['2 days ago', '1 week ago', '2 weeks ago', '3 weeks ago'];
    final ratings = ['5.0', '4.8', '4.5', '5.0'];
    final reviews = [
      'Amazing place! The views were spectacular and the experience was unforgettable. Highly recommend visiting this destination.',
      'Great experience overall. The location is stunning and there are plenty of activities to do. Would definitely visit again!',
      'Beautiful destination with friendly locals. The food was delicious and the scenery breathtaking. A must-visit place!',
      'Perfect getaway! Everything exceeded my expectations. The staff was helpful and the facilities were top-notch.',
    ];
    final avatarColors = [
      AppColors.primaryBlue,
      AppColors.primaryOrange,
      AppColors.primaryPurple,
      AppColors.primaryRed,
    ];

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.textSubtitle.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Name, Rating
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      avatarColors[index].withOpacity(0.8),
                      avatarColors[index],
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    names[index][0],
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primaryWhite,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      names[index],
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      dates[index],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSubtitle,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryYellow.withOpacity(0.2),
                      AppColors.primaryYellow.withOpacity(0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: AppColors.primaryYellow.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppIcons.star,
                      width: 16.r,
                      height: 16.r,
                      color: AppColors.primaryYellow,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      ratings[index],
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Review Text
          Text(
            reviews[index],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: AppColors.textSubtitle,
            ),
          ),
        ],
      ),
    );
  }
}
