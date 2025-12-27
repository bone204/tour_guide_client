import 'package:lottie/lottie.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/get_draft_itineraries/get_draft_itineraries_cubit.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_cubit.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_state.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/comment/comment_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/comment/comment_state.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/widgets/explore_itinerary_card.widget.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/widgets/comment_bottom_sheet.widget.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/like_itinerary/like_itinerary_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/like_itinerary/like_itinerary_state.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/my_itinerary/widgets/shimmer_itinerary_list.dart';

class ItineraryExplorePage extends StatefulWidget {
  const ItineraryExplorePage({super.key});

  @override
  State<ItineraryExplorePage> createState() => _ItineraryExplorePageState();
}

class _ItineraryExplorePageState extends State<ItineraryExplorePage> {
  late GetDraftItinerariesCubit _cubit;
  late GetMyProfileCubit _profileCubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<GetDraftItinerariesCubit>()..getDraftItineraries();
    _profileCubit = sl<GetMyProfileCubit>()..getMyProfile();
  }

  @override
  void dispose() {
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
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.exploreItineraries,
          showBackButton: true,
          backgroundColor: AppColors.backgroundColor,
          onBackPressed: () {
            Navigator.of(context).pop();
          },
        ),
        body: BlocBuilder<GetDraftItinerariesCubit, GetDraftItinerariesState>(
          builder: (context, state) {
            if (state is GetDraftItinerariesLoading) {
              return const ShimmerItineraryList();
            } else if (state is GetDraftItinerariesFailure) {
              return Center(child: Text(state.message));
            } else if (state is GetDraftItinerariesSuccess) {
              if (state.itineraries.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        AppLotties.empty,
                        width: 200.w,
                        height: 200.h,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        AppLocalizations.of(context)!.emptyItinerary,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSubtitle,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  await _cubit.getDraftItineraries();
                  context.read<GetMyProfileCubit>().getMyProfile();
                },
                child: BlocBuilder<GetMyProfileCubit, GetMyProfileState>(
                  builder: (context, profileState) {
                    List<String> favoriteIds = [];
                    if (profileState is GetMyProfileSuccess) {
                      favoriteIds = profileState.user.favoriteTravelRouteIds;
                    }

                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      itemCount: state.itineraries.length,
                      itemBuilder: (context, index) {
                        final item = state.itineraries[index];
                        String imageUrl =
                            'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=2073&auto=format&fit=crop';

                        if (item.stops.isNotEmpty) {
                          for (final stop in item.stops) {
                            if (stop.destination?.photos != null &&
                                stop.destination!.photos!.isNotEmpty) {
                              imageUrl = stop.destination!.photos!.first;
                              break;
                            }
                          }
                        }

                        // Determine initial like status from user profile
                        bool initialIsLiked = favoriteIds.contains(
                          item.id.toString(),
                        );

                        return MultiBlocProvider(
                          key: ValueKey('${item.id}_$initialIsLiked'),
                          providers: [
                            BlocProvider(
                              create: (_) {
                                final cubit = sl<LikeItineraryCubit>();
                                cubit.init(
                                  item.id,
                                  initialIsLiked,
                                  item.likeCount,
                                );
                                return cubit;
                              },
                            ),
                            BlocProvider(
                              create:
                                  (_) =>
                                      sl<CommentCubit>()..loadComments(item.id),
                            ),
                          ],
                          child: Builder(
                            builder: (context) {
                              return BlocBuilder<
                                LikeItineraryCubit,
                                LikeItineraryState
                              >(
                                builder: (context, likeState) {
                                  bool isLiked = initialIsLiked;
                                  int likeCount = item.likeCount;

                                  if (likeState is LikeItineraryUpdate &&
                                      likeState.itineraryId == item.id) {
                                    isLiked = likeState.isLiked;
                                    likeCount = likeState.likeCount;
                                  }

                                  return BlocBuilder<
                                    CommentCubit,
                                    CommentState
                                  >(
                                    builder: (context, commentState) {
                                      int commentCount = 0;
                                      if (commentState is CommentLoaded) {
                                        commentCount =
                                            commentState.comments.length;
                                        // Sum up replies for each comment to get the total count
                                        for (final comment
                                            in commentState.comments) {
                                          commentCount +=
                                              (comment.replies?.length ?? 0);
                                        }
                                      }

                                      return ExploreItineraryCard(
                                        title: item.name,
                                        authorName: item.user.username,
                                        authorAvatar: item.user.avatarUrl,
                                        destinationCount:
                                            item.stops.length.toString(),
                                        imageUrl: imageUrl,
                                        isLiked: isLiked,
                                        likeCount: likeCount,
                                        commentCount: commentCount,
                                        onLike: (val) async {
                                          context
                                              .read<LikeItineraryCubit>()
                                              .toggleLike(
                                                item.id,
                                                isLiked,
                                                likeCount,
                                              );
                                          return !isLiked;
                                        },
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                            AppRouteConstant
                                                .itineraryExploreDetail,
                                            arguments: item.id,
                                          );
                                        },
                                        onComment: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder:
                                                (context) => SizedBox(
                                                  height:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.height *
                                                      0.75,
                                                  child: CommentBottomSheet(
                                                    itineraryId: item.id,
                                                  ),
                                                ),
                                          ).then((_) {
                                            // Refresh comments count when bottom sheet closes
                                            if (context.mounted) {
                                              context
                                                  .read<CommentCubit>()
                                                  .loadComments(item.id);
                                            }
                                          });
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
