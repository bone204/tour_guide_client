import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback.dart'
    as feedback_model;
import 'package:timeago/timeago.dart' as timeago;

class CommentItem extends StatelessWidget {
  final feedback_model.Feedback feedback;

  const CommentItem({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundImage:
              feedback.user?.avatarUrl != null &&
                      feedback.user!.avatarUrl.isNotEmpty
                  ? NetworkImage(feedback.user!.avatarUrl)
                  : null,
          backgroundColor: AppColors.primaryGrey.withOpacity(0.2),
          child:
              feedback.user?.avatarUrl == null ||
                      feedback.user!.avatarUrl.isEmpty
                  ? const Icon(Icons.person, color: AppColors.primaryGrey)
                  : null,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFF0F2F5,
                  ), // Standard social comment bubble color
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feedback.user?.username ??
                          AppLocalizations.of(context)!.unknownUser,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      feedback.comment ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12.w, top: 4.h),
                child: Row(
                  children: [
                    Text(
                      timeago.format(feedback.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSubtitle,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    InkWell(
                      onTap: () {
                        // TODO: Implement like functionality
                      },
                      child: Text(
                        AppLocalizations.of(context)!.like,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSubtitle,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    InkWell(
                      onTap: () {
                        // TODO: Implement reply functionality
                      },
                      child: Text(
                        AppLocalizations.of(context)!.reply,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSubtitle,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
