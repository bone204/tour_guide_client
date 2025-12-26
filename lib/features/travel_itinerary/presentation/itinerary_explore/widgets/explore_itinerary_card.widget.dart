import 'package:tour_guide_app/common/widgets/button/like_button.dart';
import 'package:tour_guide_app/common_libs.dart';

class ExploreItineraryCard extends StatelessWidget {
  final String title;
  final String dateRange;
  final String destinationCount;
  final String imageUrl;
  final VoidCallback? onTap;
  final bool isLiked;
  final LikeButtonTapCallback? onLike;
  final VoidCallback? onComment;
  final int likeCount;
  final int commentCount;

  const ExploreItineraryCard({
    super.key,
    required this.title,
    required this.dateRange,
    required this.destinationCount,
    this.imageUrl =
        'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=2073&auto=format&fit=crop', // Default placeholder
    this.onTap,
    this.isLiked = false,
    this.onLike,
    this.onComment,
    this.likeCount = 0,
    this.commentCount = 0,
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
            color: AppColors.primaryGrey.withOpacity(0.25),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image Section
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              child: Image.network(
                imageUrl,
                height: 180.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180.h,
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
                  SizedBox(height: 8.h),
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
                  SizedBox(height: 16.h),
                  const Divider(),
                  SizedBox(height: 8.h),
                  // Social Interaction Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Like Button
                      Row(
                        children: [
                          CustomLikeButton(
                            size: 24.r,
                            isLiked: isLiked,
                            likedColor: AppColors.primaryRed,
                            unlikedColor: AppColors.textSubtitle,
                            onTap:
                                onLike ??
                                (bool liked) async {
                                  return !liked;
                                },
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            likeCount.toString(),
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color:
                                  isLiked
                                      ? AppColors.primaryRed
                                      : AppColors.textSubtitle,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 24.w),
                      // Comment Button
                      InkWell(
                        onTap: onComment,
                        borderRadius: BorderRadius.circular(8.r),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 4.h,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 22.r,
                                color: AppColors.textSubtitle,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                commentCount.toString(),
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSubtitle,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
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
