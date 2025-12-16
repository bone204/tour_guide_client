import 'package:tour_guide_app/common_libs.dart';

class ItineraryCard extends StatelessWidget {
  final String title;
  final String dateRange;
  final String destinationCount;
  final String status; // e.g., "Upcoming", "Completed"
  final String imageUrl; // Added for visual appeal
  final VoidCallback? onTap;

  const ItineraryCard({
    super.key,
    required this.title,
    required this.dateRange,
    required this.destinationCount,
    required this.status,
    this.imageUrl =
        'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=2073&auto=format&fit=crop', // Default placeholder
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image Section
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.r),
                    ),
                    child: Image.network(
                      imageUrl,
                      height: 150.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 150.h,
                          color: AppColors.primaryGrey.withOpacity(0.2),
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: AppColors.primaryGrey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        status,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color:
                              status == 'Upcoming'
                                  ? AppColors.primaryBlue
                                  : AppColors.primaryGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Content Section
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        _buildInfoChip(context, AppIcons.calendar, dateRange),
                        SizedBox(width: 16.w),
                        _buildInfoChip(
                          context,
                          AppIcons.location,
                          '$destinationCount Destinations',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          icon,
          width: 16.w,
          height: 16.h,
          colorFilter: const ColorFilter.mode(
            AppColors.textSubtitle,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSubtitle),
        ),
      ],
    );
  }
}
