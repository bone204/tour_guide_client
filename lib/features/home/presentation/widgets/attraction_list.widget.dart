// ignore_for_file: deprecated_member_use
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tour_guide_app/features/destination/presentation/bloc/favorite_destination/favorite_destinations_cubit.dart';
import 'package:tour_guide_app/features/destination/presentation/pages/destination_detail.page.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_recommend_destinations/get_recommend_destinations_cubit.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_recommend_destinations/get_recommend_destinations_state.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/attraction_card.widget.dart';

class SliverRestaurantNearbyAttractionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: AppColors.primaryWhite),
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.attraction,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.textPrimary),
            ),
            SizedBox(height: 4.h),
            Text(
              AppLocalizations.of(context)!.attractionDes,
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(color: AppColors.textPrimary),
            ),
            SizedBox(height: 20.h),

            BlocBuilder<
              GetRecommendDestinationsCubit,
              GetRecommendDestinationsState
            >(
              builder: (context, state) {
                if (state is GetRecommendDestinationsLoading) {
                  return MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.h,
                    crossAxisSpacing: 16.w,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 4, // Show 4 shimmer items
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: AppColors.secondaryGrey.withOpacity(0.3),
                        highlightColor: AppColors.secondaryGrey.withOpacity(
                          0.1,
                        ),
                        child: Container(
                          height:
                              (index % 2 == 0)
                                  ? 200.h
                                  : 250
                                      .h, // Randomize height for masonry effect
                          decoration: BoxDecoration(
                            color: AppColors.secondaryGrey,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      );
                    },
                  );
                }

                if (state is GetRecommendDestinationsError) {
                  return Container(
                    height: 200.h,
                    padding: EdgeInsets.all(16.w),
                    child: Center(
                      child: Text(
                        state.message,
                        style: TextStyle(color: AppColors.textSubtitle),
                      ),
                    ),
                  );
                }

                if (state is GetRecommendDestinationsLoaded) {
                  final destinations = state.destinations;

                  if (destinations.isEmpty) {
                    return Container(
                      height: 200.h,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.noAttractionsFound,
                          style: TextStyle(color: AppColors.textSubtitle),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.h,
                        crossAxisSpacing: 16.w,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(0),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: destinations.length,
                        itemBuilder: (context, index) {
                          final destination = destinations[index];

                          final favoriteCubit =
                              context.read<FavoriteDestinationsCubit>();

                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          DestinationDetailPage.withProvider(
                                            destinationId: destination.id,
                                            favoriteCubit: favoriteCubit,
                                          ),
                                ),
                              );
                            },
                            child: AttractionCard(
                              imageUrl:
                                  destination.photos?.isNotEmpty == true
                                      ? destination.photos!.first
                                      : AppImage.defaultDestination,
                              title: destination.name,
                              location: destination.province ?? "Unknown",
                              rating: destination.rating ?? 0.0,
                              reviews: destination.userRatingsTotal ?? 0,
                            ),
                          );
                        },
                      ),

                      // Loading more indicator
                      if (state.isLoadingMore)
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: StaggeredGrid.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8.h,
                            crossAxisSpacing: 16.w,
                            children: List.generate(
                              2,
                              (index) => Shimmer.fromColors(
                                baseColor: AppColors.secondaryGrey.withOpacity(
                                  0.3,
                                ),
                                highlightColor: AppColors.secondaryGrey
                                    .withOpacity(0.1),
                                child: Container(
                                  height: 200.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryGrey,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      // End of list message
                      if (state.hasReachedEnd && destinations.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(
                                context,
                              )!.youHaveSeenAllAttractions,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.textSubtitle),
                            ),
                          ),
                        ),
                    ],
                  );
                }

                return Container(height: 200.h);
              },
            ),
          ],
        ),
      ),
    );
  }
}
