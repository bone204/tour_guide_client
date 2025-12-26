import 'package:tour_guide_app/common/widgets/button/like_button.dart';
import 'package:tour_guide_app/common_libs.dart';

class ExploreItineraryCard extends StatelessWidget {
  final String title;
  final String? authorName;
  final String? authorAvatar;
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
    this.authorName,
    this.authorAvatar,
    required this.destinationCount,
    this.imageUrl =
        'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=2073&auto=format&fit=crop',
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
        borderRadius: BorderRadius.circular(24.r),
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
            // Hero Image Section with Author Overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 200.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200.h,
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
                // Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24.r),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.4],
                      ),
                    ),
                  ),
                ),
                // Author Info Overlay
                Positioned(
                  top: 16.h,
                  left: 16.w,
                  right: 16.w,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.r),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 16.r,
                          backgroundColor: AppColors.primaryGrey.withOpacity(
                            0.2,
                          ),
                          backgroundImage:
                              authorAvatar != null && authorAvatar!.isNotEmpty
                                  ? NetworkImage(authorAvatar!)
                                  : null,
                          child:
                              authorAvatar == null || authorAvatar!.isEmpty
                                  ? Icon(
                                    Icons.person,
                                    size: 16.r,
                                    color: AppColors.primaryGrey,
                                  )
                                  : null,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          authorName ??
                              AppLocalizations.of(context)!.unknownUser,
                          style: Theme.of(
                            context,
                          ).textTheme.displayLarge?.copyWith(
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: const Offset(0, 1),
                                blurRadius: 4,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  _buildInfoChip(
                    context,
                    AppIcons.location,
                    AppLocalizations.of(
                      context,
                    )!.destinationsCount(destinationCount),
                  ),
                  SizedBox(height: 16.h),
                  const Divider(height: 1),
                  SizedBox(height: 12.h),
                  // Social Interaction Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                                ).textTheme.displayLarge?.copyWith(
                                  color:
                                      isLiked
                                          ? AppColors.primaryRed
                                          : AppColors.textSubtitle,
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
                                    ).textTheme.displayLarge?.copyWith(
                                      color: AppColors.textSubtitle,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            width: 14.w,
            height: 14.h,
            colorFilter: const ColorFilter.mode(
              AppColors.primaryBlue,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
