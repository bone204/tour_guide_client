import 'package:tour_guide_app/common/widgets/button/like_button.dart';
import 'package:tour_guide_app/common_libs.dart';

class ExploreItineraryCard extends StatelessWidget {
  final String title;
  final String? authorName;
  final String? authorAvatar;
  final String destinationCount;
  final String imageUrl;
  final String? province;
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
    required this.imageUrl,
    this.province,
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
      margin: EdgeInsets.only(bottom: 24.h),
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 220.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 220.h,
                        color: AppColors.primaryGrey.withOpacity(0.2),
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: AppColors.primaryGrey,
                            size: 40.sp,
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
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.4, 0.7, 1.0],
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                // Province Tag (Top Right)
                if (province != null && province!.isNotEmpty)
                  Positioned(
                    top: 16.h,
                    right: 16.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppColors.primaryYellow,
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            province!,
                            style: Theme.of(
                              context,
                            ).textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Author Info (Bottom Left)
                Positioned(
                  bottom: 16.h,
                  left: 16.w,
                  right: 16.w,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                            ),
                          ],
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
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authorName ?? AppLocalizations.of(context)!.unknownUser,
                              style: Theme.of(
                                context,
                              ).textTheme.titleSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(0, 1),
                                    blurRadius: 2,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Content Section
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      fontSize: 18.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 16.h),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Locations Count
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.map_outlined,
                              size: 16.sp,
                              color: AppColors.primaryBlue,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              AppLocalizations.of(
                      context,
                    )!.destinationsCount(destinationCount),
                              style: Theme.of(
                                context,
                              ).textTheme.labelMedium?.copyWith(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Social Actions
                      Row(
                        children: [
                          // Like
                          Row(
                            children: [
                              CustomLikeButton(
                                size: 22.r,
                                isLiked: isLiked,
                                likedColor: AppColors.primaryRed,
                                unlikedColor: AppColors.textSubtitle,
                                onTap:
                                    onLike ??
                                    (bool liked) async {
                                      return !liked;
                                    },
                              ),
                              SizedBox(width: 4.w),
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
                          SizedBox(width: 16.w),
                          // Comment
                          InkWell(
                            onTap: onComment,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  size: 20.r,
                                  color: AppColors.textSubtitle,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  commentCount.toString(),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSubtitle,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
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
