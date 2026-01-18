import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/comment/cooperation_comment_cubit.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/comment/cooperation_comment_state.dart';
import 'package:tour_guide_app/features/destination/presentation/widgets/comment/destination_review_item.widget.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_cubit.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_state.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/widgets/comment_shimmer.widget.dart';
import 'package:tour_guide_app/service_locator.dart';

class CooperationCommentWidget extends StatefulWidget {
  final int cooperationId;

  const CooperationCommentWidget({super.key, required this.cooperationId});

  @override
  State<CooperationCommentWidget> createState() =>
      _CooperationCommentWidgetState();
}

class _CooperationCommentWidgetState extends State<CooperationCommentWidget> {
  final TextEditingController _commentController = TextEditingController();
  late CooperationCommentCubit _cubit;
  late GetMyProfileCubit _profileCubit;
  int _selectedRating = 5;
  bool _wasSubmitting = false;

  @override
  void initState() {
    super.initState();
    _cubit = sl<CooperationCommentCubit>()..loadComments(widget.cooperationId);
    _profileCubit = sl<GetMyProfileCubit>()..getMyProfile();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _cubit.close();
    _profileCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cubit),
        BlocProvider.value(value: _profileCubit),
      ],
      child: BlocListener<CooperationCommentCubit, CooperationCommentState>(
        listener: (context, state) {
          if (state is CooperationCommentLoaded) {
            if (_wasSubmitting &&
                !state.isSubmitting &&
                state.errorMessage == null) {
              _commentController.clear();
              setState(() => _selectedRating = 5);
            }
            _wasSubmitting = state.isSubmitting;

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
              final error = _getLocalizedMessage(context, state.errorMessage!);
              CustomSnackbar.show(
                context,
                message: error,
                type: SnackbarType.error,
              );
            }
          } else if (state is CooperationCommentError) {
            final error = _getLocalizedMessage(context, state.message);
            CustomSnackbar.show(
              context,
              message: error,
              type: SnackbarType.error,
            );
          }
        },
        child: Column(
          children: [
            // Comment List
            _buildCommentList(),
            SizedBox(height: 20.h),
            // Input Field
            _buildInputSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return BlocBuilder<CooperationCommentCubit, CooperationCommentState>(
      builder: (context, state) {
        final isSubmitting =
            state is CooperationCommentLoaded && state.isSubmitting;

        return Opacity(
          opacity: isSubmitting ? 0.6 : 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 2),
                  blurRadius: 10,
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRatingSelector(isSubmitting),
                SizedBox(height: 12.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: BlocBuilder<GetMyProfileCubit, GetMyProfileState>(
                        builder: (context, state) {
                          String? avatarUrl;
                          if (state is GetMyProfileSuccess) {
                            avatarUrl = state.user.avatarUrl;
                          }

                          return CircleAvatar(
                            radius: 16.r,
                            backgroundColor: AppColors.primaryGrey.withOpacity(
                              0.2,
                            ),
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
                            enabled: !isSubmitting,
                            maxLines: null,
                            textCapitalization: TextCapitalization.sentences,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color:
                                  isSubmitting
                                      ? AppColors.textSubtitle.withOpacity(0.5)
                                      : AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  AppLocalizations.of(context)!.addComment,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              hintStyle: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textSubtitle),
                            ),
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
                          final isEnabled =
                              value.text.trim().isNotEmpty && !isSubmitting;
                          return InkWell(
                            onTap:
                                isEnabled
                                    ? () {
                                      FocusScope.of(context).unfocus();
                                      _cubit.addComment(
                                        widget.cooperationId,
                                        _commentController.text.trim(),
                                        _selectedRating,
                                      );
                                    }
                                    : null,
                            borderRadius: BorderRadius.circular(20.r),
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color:
                                    isEnabled
                                        ? AppColors.primaryBlue
                                        : AppColors.primaryGrey.withOpacity(
                                          0.2,
                                        ),
                                shape: BoxShape.circle,
                              ),
                              child:
                                  isSubmitting
                                      ? SizedBox(
                                        width: 20.r,
                                        height: 20.r,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                AppColors.primaryWhite,
                                              ),
                                        ),
                                      )
                                      : Icon(
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
        );
      },
    );
  }

  Widget _buildRatingSelector(bool isSubmitting) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap:
              isSubmitting
                  ? null
                  : () {
                    setState(() {
                      _selectedRating = index + 1;
                    });
                  },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: SvgPicture.asset(
              AppIcons.star,
              width: 24.r,
              height: 24.r,
              colorFilter: ColorFilter.mode(
                index < _selectedRating
                    ? AppColors.primaryYellow
                    : AppColors.textSubtitle.withOpacity(0.3),
                BlendMode.srcIn,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCommentList() {
    return BlocBuilder<CooperationCommentCubit, CooperationCommentState>(
      builder: (context, state) {
        if (state is CooperationCommentLoading) {
          return ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) => const CommentShimmer(),
          );
        } else if (state is CooperationCommentLoaded) {
          if (state.comments.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: Text(AppLocalizations.of(context)!.noComments),
              ),
            );
          }
          return Column(
            children: [
              ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.comments.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  return DestinationReviewItem(feedback: state.comments[index]);
                },
              ),
              if (!state.hasReachedEnd)
                Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child:
                      state.isLoadingMore
                          ? const CommentShimmer()
                          : TextButton(
                            onPressed: () => _cubit.loadMoreComments(),
                            child: Text(AppLocalizations.of(context)!.loadMore),
                          ),
                ),
            ],
          );
        } else if (state is CooperationCommentError) {
          final errorMsg = _getLocalizedMessage(context, state.message);
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Text(errorMsg, textAlign: TextAlign.center),
                  TextButton(
                    onPressed: () => _cubit.loadComments(widget.cooperationId),
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
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
