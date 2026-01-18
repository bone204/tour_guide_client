// Same structure as HotelCommentWidget but for Restaurant
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/features/restaurant/presentation/bloc/comment/restaurant_comment_cubit.dart';
import 'package:tour_guide_app/features/restaurant/presentation/bloc/comment/restaurant_comment_state.dart';
import 'package:tour_guide_app/features/restaurant/presentation/widgets/comment/restaurant_review_item.widget.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_cubit.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_state.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/widgets/comment_shimmer.widget.dart';
import 'package:tour_guide_app/service_locator.dart';

// Widget code is nearly identical to HotelCommentWidget
// Changed only: RestaurantCommentCubit, RestaurantCommentState, restaurantId parameter
class RestaurantCommentWidget extends StatefulWidget {
  final int restaurantId;

  const RestaurantCommentWidget({super.key, required this.restaurantId});

  @override
  State<RestaurantCommentWidget> createState() =>
      _RestaurantCommentWidgetState();
}

class _RestaurantCommentWidgetState extends State<RestaurantCommentWidget> {
  final TextEditingController _commentController = TextEditingController();
  late RestaurantCommentCubit _cubit;
  late GetMyProfileCubit _profileCubit;
  int _selectedRating = 5;

  @override
  void initState() {
    super.initState();
    _cubit = sl<RestaurantCommentCubit>()..loadComments(widget.restaurantId);
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
      child: BlocListener<RestaurantCommentCubit, RestaurantCommentState>(
        listener: (context, state) {
          if (state is RestaurantCommentLoaded) {
            if (state.warningMessage != null) {
              CustomSnackbar.show(
                context,
                message: _getLocalizedMessage(context, state.warningMessage!),
                type: SnackbarType.warning,
              );
            }
            if (state.errorMessage != null) {
              CustomSnackbar.show(
                context,
                message: _getLocalizedMessage(context, state.errorMessage!),
                type: SnackbarType.error,
              );
            }
          } else if (state is RestaurantCommentError) {
            CustomSnackbar.show(
              context,
              message: _getLocalizedMessage(context, state.message),
              type: SnackbarType.error,
            );
          }
        },
        child: Column(
          children: [
            _buildCommentList(),
            SizedBox(height: 20.h),
            _buildInputSection(),
          ],
        ),
      ),
    );
  }

  // [Rest of methods identical to HotelCommentWidget - buildInputSection, buildRatingSelector, buildCommentList, getLocalizedMessage]
  // For brevity, see hotel_comment.widget.dart

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
                    if (state is GetMyProfileSuccess)
                      avatarUrl = state.user.avatarUrl;
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
                                  widget.restaurantId,
                                  _commentController.text.trim(),
                                  _selectedRating,
                                );
                                _commentController.clear();
                                setState(() => _selectedRating = 5);
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

  Widget _buildRatingSelector() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      5,
      (index) => GestureDetector(
        onTap: () => setState(() => _selectedRating = index + 1),
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
      ),
    ),
  );

  Widget _buildCommentList() =>
      BlocBuilder<RestaurantCommentCubit, RestaurantCommentState>(
        builder: (context, state) {
          if (state is RestaurantCommentLoading)
            return ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (_, __) => const CommentShimmer(),
            );
          if (state is RestaurantCommentLoaded) {
            if (state.comments.isEmpty)
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Text(AppLocalizations.of(context)!.noComments),
                ),
              );
            return Column(
              children: [
                ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.comments.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16.h),
                  itemBuilder:
                      (_, i) =>
                          RestaurantReviewItem(feedback: state.comments[i]),
                ),
                if (!state.hasReachedEnd)
                  Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child:
                        state.isLoadingMore
                            ? const CommentShimmer()
                            : TextButton(
                              onPressed: () => _cubit.loadMoreComments(),
                              child: Text(
                                AppLocalizations.of(context)!.loadMore,
                              ),
                            ),
                  ),
              ],
            );
          }
          if (state is RestaurantCommentError)
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    Text(
                      _getLocalizedMessage(context, state.message),
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () => _cubit.loadComments(widget.restaurantId),
                      child: Text(AppLocalizations.of(context)!.retry),
                    ),
                  ],
                ),
              ),
            );
          return const SizedBox();
        },
      );

  String _getLocalizedMessage(BuildContext context, String message) {
    final l = AppLocalizations.of(context)!;
    if (message.startsWith('feedbackContentRejected:')) {
      final reasons = message
          .substring('feedbackContentRejected:'.length)
          .split(',')
          .map((k) {
            switch (k.trim()) {
              case 'toxicity_high':
                return l.toxicity_high;
              case 'spam_high':
                return l.spam_high;
              case 'rule_reject':
                return l.rule_reject;
              case 'toxicity_manual':
                return l.toxicity_manual;
              case 'spam_manual':
                return l.spam_manual;
              case 'rule_manual':
                return l.rule_manual;
              case 'too_short':
                return l.too_short;
              case 'profanity':
                return l.profanity;
              case 'sexual_content':
                return l.sexual_content;
              case 'harassment':
                return l.harassment;
              case 'hate_speech':
                return l.hate_speech;
              default:
                return k;
            }
          })
          .join(', ');
      return l.feedbackContentRejected(reasons);
    }
    if (message == 'feedbackContentUnderReview')
      return l.feedbackContentUnderReview;
    if (message == 'too_short') return l.too_short;
    return message;
  }
}
