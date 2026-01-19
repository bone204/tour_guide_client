import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';

class TicketCard extends StatelessWidget {
  final String name;
  final String location;
  final double price;
  final double? rating;
  final String? openTime;
  final String? closeTime;
  final String imageUrl;
  final VoidCallback onTap;

  const TicketCard({
    super.key,
    required this.name,
    required this.location,
    required this.price,
    this.rating,
    this.openTime,
    this.closeTime,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlack.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Image.network(
                imageUrl,
                height: 120.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 120.h,
                      color: AppColors.primaryGrey.withOpacity(0.3),
                      child: const Icon(Icons.image_not_supported),
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.textTheme.titleSmall!.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.primaryBlack,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 12.sp,
                        color: AppColors.primaryGrey,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.textTheme.bodySmall!.copyWith(
                            fontSize: 10.sp,
                            color: AppColors.primaryGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (openTime != null && closeTime != null) ...[
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_filled,
                          size: 11.sp,
                          color: AppColors.primaryBlue,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "$openTime - $closeTime",
                          style: AppTypography.textTheme.bodySmall!.copyWith(
                            fontSize: 10.sp,
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Formatter.currency(price),
                        style: AppTypography.textTheme.titleSmall!.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                      if (rating != null)
                        Row(
                          children: [
                            Icon(Icons.star, size: 12.sp, color: Colors.orange),
                            SizedBox(width: 2.w),
                            Text(
                              rating!.toStringAsFixed(1),
                              style: AppTypography.textTheme.bodySmall!
                                  .copyWith(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                          ],
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
  }
}
