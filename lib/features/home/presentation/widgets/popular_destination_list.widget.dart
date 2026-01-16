// ignore_for_file: deprecated_member_use
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/destination/presentation/bloc/favorite_destination/favorite_destinations_cubit.dart';
import 'package:tour_guide_app/features/destination/presentation/pages/destination_detail.page.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_destinations/get_destination_cubit.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_destinations/get_destination_state.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_query.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/destination_card.widget.dart';

class SliverPopularDestinationList extends StatefulWidget {
  @override
  State<SliverPopularDestinationList> createState() =>
      _SliverPopularDestinationListState();
}

class _SliverPopularDestinationListState
    extends State<SliverPopularDestinationList> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocProvider(
        create:
            (context) =>
                GetDestinationCubit()..getDestinations(
                  query: DestinationQuery(sortBy: DestinationSortBy.popularity),
                ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryOrange,
                    AppColors.primaryOrange.withOpacity(0.6),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -28,
                    right: 0,
                    child: Image.asset(
                      AppImage.sakura,
                      width: 140.w,
                      height: 140.h,
                    ),
                  ),

                  // 🔹 Nội dung
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Padding(
                        padding: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          bottom: 20.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.popular,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              AppLocalizations.of(context)!.popularDes,
                              style: Theme.of(context).textTheme.displayMedium
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),

                      // Carousel Destination Cards
                      BlocBuilder<GetDestinationCubit, GetDestinationState>(
                        builder: (context, state) {
                          if (state is GetDestinationLoading) {
                            return SizedBox(
                              height: 300.h,
                              child: ListView.separated(
                                padding: EdgeInsets.only(left: 16.w),
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                separatorBuilder:
                                    (context, index) => SizedBox(width: 12.w),
                                itemBuilder: (context, index) {
                                  return Shimmer.fromColors(
                                    baseColor: AppColors.secondaryGrey
                                        .withOpacity(0.3),
                                    highlightColor: AppColors.secondaryGrey
                                        .withOpacity(0.1),
                                    child: Container(
                                      width: 280.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.secondaryGrey,
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }

                          if (state is GetDestinationError) {
                            return Container(
                              height: 300.h,
                              padding: EdgeInsets.all(16.w),
                              child: Center(
                                child: Text(
                                  state.message,
                                  style: TextStyle(
                                    color: AppColors.primaryWhite,
                                  ),
                                ),
                              ),
                            );
                          }

                          if (state is GetDestinationLoaded) {
                            final destinations = state.destinations;

                            if (destinations.isEmpty) {
                              return Container(
                                height: 300.h,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.noDestinationsFound,
                                    style: TextStyle(
                                      color: AppColors.primaryWhite,
                                    ),
                                  ),
                                ),
                              );
                            }

                            final favoriteState =
                                context
                                    .watch<FavoriteDestinationsCubit>()
                                    .state;
                            final favoriteIds = favoriteState.favoriteIds;

                            return Padding(
                              padding: EdgeInsets.only(left: 16.w),
                              child: CarouselSlider.builder(
                                itemCount: destinations.length,
                                itemBuilder: (context, index, realIndex) {
                                  final destination = destinations[index];
                                  final favoriteCubit =
                                      context.read<FavoriteDestinationsCubit>();

                                  return DestinationCard(
                                    imageUrl:
                                        destination.photos?.isNotEmpty == true
                                            ? destination.photos!.first
                                            : AppImage.defaultDestination,
                                    name: destination.name,
                                    rating:
                                        destination.rating?.toString() ?? "0.0",
                                    location:
                                        destination.province ??
                                        AppLocalizations.of(context)!.unknown,
                                    favoriteTimes: destination.favouriteTimes,
                                    onTap: () {
                                      Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).push(
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  DestinationDetailPage.withProvider(
                                                    destinationId:
                                                        destination.id,
                                                    favoriteCubit:
                                                        favoriteCubit,
                                                  ),
                                        ),
                                      );
                                    },
                                    isFavorite: favoriteIds.contains(
                                      destination.id,
                                    ),
                                    onFavoriteTap: (_) async {
                                      return await favoriteCubit.toggleFavorite(
                                        destination.id,
                                      );
                                    },
                                  );
                                },
                                options: CarouselOptions(
                                  height: 300.h,
                                  padEnds: false,
                                  autoPlay: false,
                                  enableInfiniteScroll: false,
                                  viewportFraction: 0.8,
                                  enlargeCenterPage: false,
                                ),
                              ),
                            );
                          }

                          return Container(height: 300.h);
                        },
                      ),
                    ],
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
