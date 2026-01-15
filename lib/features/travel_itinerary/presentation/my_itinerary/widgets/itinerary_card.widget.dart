import 'package:tour_guide_app/common_libs.dart';

class ItineraryCard extends StatelessWidget {
  final String title;
  final String dateRange;
  final String destinationCount;
  final String status;
  final String imageUrl;
  final VoidCallback? onTap;

  const ItineraryCard({
    super.key,
    required this.title,
    required this.dateRange,
    required this.destinationCount,
    required this.status,
    this.imageUrl =
        'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=2073&auto=format&fit=crop',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGrey.withOpacity(0.25),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
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
                    top: 16.h,
                    right: 16.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                        _getTranslatedStatus(context, status),
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color:
                              status == 'Upcoming'
                                  ? AppColors.primaryBlue
                                  : AppColors.primaryGreen,
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
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 20.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        _buildInfoChip(context, AppIcons.calendar, dateRange),
                        SizedBox(height: 16.h),
                        _buildInfoChip(
                          context,
                          AppIcons.location,
                          AppLocalizations.of(
                            context,
                          )!.destinationsCount(destinationCount),
                          AppColors.primaryBlue,
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

  Widget _buildInfoChip(
    BuildContext context,
    String icon,
    String label, [
    Color? color,
  ]) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          icon,
          width: 18.w,
          height: 18.h,
          colorFilter: ColorFilter.mode(
            color ?? AppColors.textSubtitle,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  String _getTranslatedStatus(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return AppLocalizations.of(context)!.statusUpcoming;
      case 'in_progress':
        return AppLocalizations.of(context)!.routeStatusInProgress;
      case 'completed':
        return AppLocalizations.of(context)!.statusCompleted;
      case 'ongoing':
        return AppLocalizations.of(context)!.statusOngoing;
      case 'cancelled':
        return AppLocalizations.of(context)!.statusCancelled;
      case 'draft':
        return AppLocalizations.of(context)!.statusDraft;
      case 'missed':
        return AppLocalizations.of(context)!.statusMissed;
      case 'public':
      default:
        return status;
    }
  }
}
