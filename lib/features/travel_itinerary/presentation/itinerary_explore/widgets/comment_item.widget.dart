import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback.dart'
    as feedback_model;
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/reply/reply_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/reply/reply_state.dart';

class CommentItem extends StatefulWidget {
  final feedback_model.Feedback feedback;
  final Function(feedback_model.Feedback) onReply;

  const CommentItem({super.key, required this.feedback, required this.onReply});

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool _showReplies = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ReplyCubit>().loadReplies(widget.feedback.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundImage:
              widget.feedback.user?.avatarUrl != null &&
                      widget.feedback.user!.avatarUrl.isNotEmpty
                  ? NetworkImage(widget.feedback.user!.avatarUrl)
                  : null,
          backgroundColor: AppColors.primaryGrey.withOpacity(0.2),
          child:
              widget.feedback.user?.avatarUrl == null ||
                      widget.feedback.user!.avatarUrl.isEmpty
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
                      widget.feedback.user?.username ??
                          AppLocalizations.of(context)!.unknownUser,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      widget.feedback.comment ?? '',
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
                      DateFormat(
                        'HH:mm dd/MM/yyyy',
                      ).format(widget.feedback.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSubtitle,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    ),

                    SizedBox(width: 16.w),
                    InkWell(
                      onTap: () => widget.onReply(widget.feedback),
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
              BlocBuilder<ReplyCubit, ReplyState>(
                builder: (context, state) {
                  final replies =
                      state.repliesMap[widget.feedback.id] ??
                      widget.feedback.replies ??
                      [];

                  if (state.status == ReplyStatus.loading &&
                      state.repliesMap[widget.feedback.id] == null) {
                    return Padding(
                      padding: EdgeInsets.only(left: 12.w, top: 8.h),
                      child: Column(
                        children: List.generate(
                          2,
                          (index) => Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: CircleAvatar(
                                    radius: 12.r,
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  if (replies.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!_showReplies)
                          Padding(
                            padding: EdgeInsets.only(left: 12.w, top: 8.h),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _showReplies = true;
                                });
                              },
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!.viewReplies(replies.length),
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSubtitle,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ),
                        if (_showReplies)
                          Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: replies.length,
                              separatorBuilder:
                                  (context, index) => SizedBox(height: 8.h),
                              itemBuilder: (context, index) {
                                final reply = replies[index];
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 12.r,
                                      backgroundImage:
                                          reply.user?.avatarUrl != null &&
                                                  reply
                                                      .user!
                                                      .avatarUrl
                                                      .isNotEmpty
                                              ? NetworkImage(
                                                reply.user!.avatarUrl,
                                              )
                                              : null,
                                      backgroundColor: AppColors.primaryGrey
                                          .withOpacity(0.2),
                                      child:
                                          reply.user?.avatarUrl == null ||
                                                  reply.user!.avatarUrl.isEmpty
                                              ? Icon(
                                                Icons.person,
                                                size: 16.r,
                                                color: AppColors.primaryGrey,
                                              )
                                              : null,
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.w,
                                              vertical: 8.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF0F2F5),
                                              borderRadius:
                                                  BorderRadius.circular(16.r),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  reply.user?.username ??
                                                      AppLocalizations.of(
                                                        context,
                                                      )!.unknownUser,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 12.sp,
                                                      ),
                                                ),
                                                SizedBox(height: 2.h),
                                                Text(
                                                  reply.content,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        fontSize: 13.sp,
                                                        height: 1.3,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 12.w,
                                              top: 2.h,
                                            ),
                                            child: Text(
                                              DateFormat(
                                                'HH:mm dd/MM/yyyy',
                                              ).format(
                                                reply.createdAt,
                                              ),
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall?.copyWith(
                                                color: AppColors.textSubtitle,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 11.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
