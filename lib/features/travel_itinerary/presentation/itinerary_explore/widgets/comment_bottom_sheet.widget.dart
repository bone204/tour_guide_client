import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/widgets/comment_item.widget.dart';
import 'package:tour_guide_app/core/services/feedback/data/models/feedback.dart'
    as feedback_model;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/comment/comment_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/comment/comment_state.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/widgets/comment_shimmer.widget.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_cubit.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_state.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/reply/reply_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/reply/reply_state.dart';

class CommentBottomSheet extends StatefulWidget {
  final int itineraryId;

  const CommentBottomSheet({super.key, required this.itineraryId});

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  late CommentCubit _cubit;
  late GetMyProfileCubit _profileCubit;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _commentController = TextEditingController();
  feedback_model.Feedback? _replyingToFeedback;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _cubit = sl<CommentCubit>()..loadComments(widget.itineraryId);
    _profileCubit = sl<GetMyProfileCubit>()..getMyProfile();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _cubit.close();
    _profileCubit.close();
    _scrollController.dispose();
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onReply(feedback_model.Feedback feedback) {
    setState(() {
      _replyingToFeedback = feedback;
    });
    _focusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _replyingToFeedback = null;
    });
    _focusNode.unfocus();
  }

  void _onScroll() {
    if (_isBottom) {
      _cubit.loadMoreComments();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cubit),
        BlocProvider(create: (_) => sl<ReplyCubit>()),
        BlocProvider.value(value: _profileCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<CommentCubit, CommentState>(
            listener: (context, state) {
              // Existing logic
              if (state is CommentLoaded) {
                // ... warnings/errors handling
                if (state.warningMessage != null) {
                  final warning = _getLocalizedMessage(
                    context,
                    state.warningMessage!,
                  );
                  CustomSnackbar.show(
                    context,
                    message: warning,
                    type: SnackbarType.warning,
                  );
                }
                if (state.errorMessage != null) {
                  final error = _getLocalizedMessage(
                    context,
                    state.errorMessage!,
                  );
                  CustomSnackbar.show(
                    context,
                    message: error,
                    type: SnackbarType.error,
                  );
                }
              } else if (state is CommentError) {
                final error = _getLocalizedMessage(context, state.message);
                CustomSnackbar.show(
                  context,
                  message: error,
                  type: SnackbarType.error,
                );
              }
            },
          ),
          BlocListener<ReplyCubit, ReplyState>(
            listener: (context, state) {
              if (state.status == ReplyStatus.failure &&
                  state.errorMessage != null) {
                final error = _getLocalizedMessage(
                  context,
                  state.errorMessage!,
                );
                CustomSnackbar.show(
                  context,
                  message: error,
                  type: SnackbarType.error,
                );
              }
              if (state.status == ReplyStatus.success) {
                // Maybe show success toast?
              }
            },
          ),
        ],
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Column(
              children: [
                // Drag Handle & Header
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 12.h),
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGrey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.primaryGrey.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.comments,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                // Comment List
                Expanded(
                  child: BlocBuilder<CommentCubit, CommentState>(
                    builder: (context, state) {
                      if (state is CommentLoading) {
                        return ListView.separated(
                          padding: EdgeInsets.all(16.w),
                          itemCount: 5,
                          separatorBuilder:
                              (context, index) => SizedBox(height: 16.h),
                          itemBuilder:
                              (context, index) => const CommentShimmer(),
                        );
                      } else if (state is CommentLoaded) {
                        if (state.comments.isEmpty) {
                          return Center(
                            child: Text(
                              AppLocalizations.of(context)!.noComments,
                            ),
                          );
                        }
                        return ListView.separated(
                          controller: _scrollController,
                          padding: EdgeInsets.all(16.w),
                          itemCount:
                              state.isLoadingMore
                                  ? state.comments.length + 1
                                  : state.comments.length,
                          separatorBuilder:
                              (context, index) => SizedBox(height: 16.h),
                          itemBuilder: (context, index) {
                            if (index >= state.comments.length) {
                              return const CommentShimmer();
                            }
                            return CommentItem(
                              feedback: state.comments[index],
                              onReply: _onReply,
                            );
                          },
                        );
                      } else if (state is CommentError) {
                        final errorMsg = _getLocalizedMessage(
                          context,
                          state.message,
                        );
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Text(errorMsg, textAlign: TextAlign.center),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                // ... Input Field and rest of the build method
                // Input Field
                Container(
                  padding: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    top: 12.h,
                    bottom: 12.h + MediaQuery.of(context).viewInsets.bottom,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryWhite,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, -2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_replyingToFeedback != null)
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Row(
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.replyingTo} ${_replyingToFeedback!.user?.username ?? ""}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.textSubtitle),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: _cancelReply,
                                child: Icon(
                                  Icons.close,
                                  size: 16.r,
                                  color: AppColors.textSubtitle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: BlocBuilder<
                              GetMyProfileCubit,
                              GetMyProfileState
                            >(
                              builder: (context, state) {
                                String? avatarUrl;
                                if (state is GetMyProfileSuccess) {
                                  avatarUrl = state.user.avatarUrl;
                                }

                                return CircleAvatar(
                                  radius: 16.r,
                                  backgroundColor: AppColors.primaryGrey
                                      .withOpacity(0.2),
                                  backgroundImage:
                                      avatarUrl != null && avatarUrl.isNotEmpty
                                          ? NetworkImage(avatarUrl)
                                          : null,
                                  child:
                                      avatarUrl == null || avatarUrl.isEmpty
                                          ? Icon(
                                            Icons.person,
                                            color: AppColors.primaryGrey,
                                          )
                                          : null,
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundColor,
                                borderRadius: BorderRadius.circular(24.r),
                                border: Border.all(
                                  color: AppColors.primaryGrey.withOpacity(0.2),
                                ),
                              ),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: 100.h),
                                child: TextField(
                                  controller: _commentController,
                                  focusNode: _focusNode,
                                  maxLines: null,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    hintText:
                                        _replyingToFeedback != null
                                            ? AppLocalizations.of(
                                              context,
                                            )!.reply
                                            : AppLocalizations.of(
                                              context,
                                            )!.addComment,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    hintStyle: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textSubtitle,
                                    ),
                                  ),
                                  onSubmitted: (value) {
                                    if (value.trim().isNotEmpty) {
                                      FocusScope.of(context).unfocus();
                                      if (_replyingToFeedback != null) {
                                        context
                                            .read<ReplyCubit>()
                                            .checkContentAndReply(
                                              _replyingToFeedback!.id,
                                              value.trim(),
                                            );
                                        // Clean up state
                                        _cancelReply();
                                      } else {
                                        _cubit.addComment(
                                          widget.itineraryId,
                                          value.trim(),
                                        );
                                      }
                                      _commentController.clear();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Padding(
                            padding: EdgeInsets.only(bottom: 4.h),
                            child: ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _commentController,
                              builder: (context, value, child) {
                                final isEnabled = value.text.trim().isNotEmpty;
                                return InkWell(
                                  onTap:
                                      isEnabled
                                          ? () {
                                            FocusScope.of(context).unfocus();
                                            if (_replyingToFeedback != null) {
                                              context
                                                  .read<ReplyCubit>()
                                                  .checkContentAndReply(
                                                    _replyingToFeedback!.id,
                                                    _commentController.text
                                                        .trim(),
                                                  );
                                              _cancelReply();
                                            } else {
                                              _cubit.addComment(
                                                widget.itineraryId,
                                                _commentController.text.trim(),
                                              );
                                            }
                                            _commentController.clear();
                                          }
                                          : null,
                                  borderRadius: BorderRadius.circular(20.r),
                                  child: Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color:
                                          isEnabled
                                              ? AppColors.primaryBlue
                                              : AppColors.primaryGrey
                                                  .withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.send_rounded,
                                      color:
                                          isEnabled
                                              ? AppColors.primaryWhite
                                              : AppColors.textSubtitle,
                                      size: 20.r,
                                    ),
                                  ),
                                );
                              },
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
        ),
      ),
    );
  }

  String _getLocalizedMessage(BuildContext context, String message) {
    final localizations = AppLocalizations.of(context)!;

    if (message.startsWith('feedbackContentRejected:')) {
      final reasonsString = message.substring(
        'feedbackContentRejected:'.length,
      );
      final keys = reasonsString.split(',');

      final translatedReasons = keys
          .map((key) {
            switch (key.trim()) {
              case 'toxicity_high':
                return localizations.toxicity_high;
              case 'spam_high':
                return localizations.spam_high;
              case 'rule_reject':
                return localizations.rule_reject;
              case 'toxicity_manual':
                return localizations.toxicity_manual;
              case 'spam_manual':
                return localizations.spam_manual;
              case 'rule_manual':
                return localizations.rule_manual;
              case 'too_short':
                return localizations.too_short;
              case 'profanity':
                return localizations.profanity;
              case 'sexual_content':
                return localizations.sexual_content;
              case 'harassment':
                return localizations.harassment;
              case 'hate_speech':
                return localizations.hate_speech;
              default:
                return key;
            }
          })
          .join(', ');

      return localizations.feedbackContentRejected(translatedReasons);
    }

    if (message == 'feedbackContentUnderReview') {
      return localizations.feedbackContentUnderReview;
    }

    if (message == 'too_short') {
      return localizations.too_short;
    }

    return message;
  }
}
