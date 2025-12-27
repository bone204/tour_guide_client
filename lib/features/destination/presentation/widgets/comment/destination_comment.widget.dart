import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/features/destination/presentation/bloc/comment/destination_comment_cubit.dart';
import 'package:tour_guide_app/features/destination/presentation/bloc/comment/destination_comment_state.dart';
import 'package:tour_guide_app/features/destination/presentation/widgets/comment/destination_review_item.widget.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_cubit.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_state.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/widgets/comment_shimmer.widget.dart';
import 'package:tour_guide_app/service_locator.dart';

class DestinationCommentWidget extends StatefulWidget {
  final int destinationId;

  const DestinationCommentWidget({super.key, required this.destinationId});

  @override
  State<DestinationCommentWidget> createState() =>
      _DestinationCommentWidgetState();
}

class _DestinationCommentWidgetState extends State<DestinationCommentWidget> {
  final TextEditingController _commentController = TextEditingController();
  late DestinationCommentCubit _cubit;
  late GetMyProfileCubit _profileCubit;
  int _selectedRating = 5;

  @override
  void initState() {
    super.initState();
    _cubit = sl<DestinationCommentCubit>()..loadComments(widget.destinationId);
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
      child: BlocListener<DestinationCommentCubit, DestinationCommentState>(
        listener: (context, state) {
          if (state is DestinationCommentLoaded) {
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
          } else if (state is DestinationCommentError) {
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
    return Container(
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
          _buildRatingSelector(),
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
                      backgroundColor: AppColors.primaryGrey.withOpacity(0.2),
                      backgroundImage:
                          avatarUrl != null && avatarUrl.isNotEmpty
                              ? NetworkImage(avatarUrl)
                              : null,
                      child:
                          avatarUrl == null || avatarUrl.isEmpty
                              ? Icon(Icons.person, color: AppColors.primaryGrey)
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
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.addComment,
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
                    final isEnabled = value.text.trim().isNotEmpty;
                    return InkWell(
                      onTap:
                          isEnabled
                              ? () {
                                FocusScope.of(context).unfocus();
                                _cubit.addComment(
                                  widget.destinationId,
                                  _commentController.text.trim(),
                                  _selectedRating,
                                );
                                _commentController.clear();
                                setState(() {
                                  _selectedRating = 5;
                                });
                              }
                              : null,
                      borderRadius: BorderRadius.circular(20.r),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color:
                              isEnabled
                                  ? AppColors.primaryBlue
                                  : AppColors.primaryGrey.withOpacity(0.2),
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
    );
  }

  Widget _buildRatingSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
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
    return BlocBuilder<DestinationCommentCubit, DestinationCommentState>(
      builder: (context, state) {
        if (state is DestinationCommentLoading) {
          return ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) => const CommentShimmer(),
          );
        } else if (state is DestinationCommentLoaded) {
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
        } else if (state is DestinationCommentError) {
          final errorMsg = _getLocalizedMessage(context, state.message);
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Text(errorMsg, textAlign: TextAlign.center),
                  TextButton(
                    onPressed: () => _cubit.loadComments(widget.destinationId),
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
