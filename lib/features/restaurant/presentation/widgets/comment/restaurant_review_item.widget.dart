import 'package:flutter_svg/svg.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback.dart'
    as feedback_model;
import 'package:timeago/timeago.dart' as timeago;

class RestaurantReviewItem extends StatefulWidget {
  final feedback_model.Feedback feedback;
  const RestaurantReviewItem({super.key, required this.feedback});

  @override
  State<RestaurantReviewItem> createState() => _RestaurantReviewItemState();
}

class _RestaurantReviewItemState extends State<RestaurantReviewItem> {
  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('vi', timeago.ViMessages());
  }

  @override
  Widget build(BuildContext context) {
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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.feedback.user?.username ??
                          AppLocalizations.of(context)!.unknownUser,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      timeago.format(
                        widget.feedback.createdAt,
                        locale: Localizations.localeOf(context).languageCode,
                      ),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSubtitle,
                      ),
                    ),
                  ],
                ),
              ),
              _buildRatingBadge(context),
            ],
          ),

          SizedBox(height: 12.h),

          if (widget.feedback.comment != null &&
              widget.feedback.comment!.isNotEmpty)
            Text(
              widget.feedback.comment!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.6,
                color: AppColors.textSubtitle,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final avatarUrl = widget.feedback.user?.avatarUrl;
    return Container(
      width: 44.r,
      height: 44.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryGrey.withOpacity(0.2),
        image:
            avatarUrl != null && avatarUrl.isNotEmpty
                ? DecorationImage(
                  image: NetworkImage(avatarUrl),
                  fit: BoxFit.cover,
                )
                : null,
      ),
      child:
          avatarUrl == null || avatarUrl.isEmpty
              ? Icon(Icons.person, color: AppColors.primaryGrey, size: 24.r)
              : null,
    );
  }

  Widget _buildRatingBadge(BuildContext context) {
    return Container(
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
            colorFilter: const ColorFilter.mode(
              AppColors.primaryYellow,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            widget.feedback.star.toStringAsFixed(1),
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
