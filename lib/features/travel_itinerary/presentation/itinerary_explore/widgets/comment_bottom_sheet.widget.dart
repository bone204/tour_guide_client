import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/widgets/comment_item.widget.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/comment/comment_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/comment/comment_state.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/widgets/comment_shimmer.widget.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_cubit.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_state.dart';

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
    super.dispose();
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
        BlocProvider.value(value: _profileCubit),
      ],
      child: Container(
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
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
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
                      itemBuilder: (context, index) => const CommentShimmer(),
                    );
                  } else if (state is CommentLoaded) {
                    if (state.comments.isEmpty) {
                      return Center(
                        child: Text(AppLocalizations.of(context)!.noComments),
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
                        return CommentItem(feedback: state.comments[index]);
                      },
                    );
                  } else if (state is CommentError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),

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
              child: Row(
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
                          onSubmitted: (value) {
                            // Handled by Send button mostly, but keep for enter key
                            if (value.trim().isNotEmpty) {
                              _cubit.addComment(
                                widget.itineraryId,
                                value.trim(),
                              );
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
                                    _cubit.addComment(
                                      widget.itineraryId,
                                      _commentController.text.trim(),
                                    );
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
            ),
          ],
        ),
      ),
    );
  }
}
