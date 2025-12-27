// ignore_for_file: deprecated_member_use
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/destination/presentation/bloc/favorite_destinations_cubit.dart';
import 'package:tour_guide_app/features/destination/presentation/pages/destination_detail.page.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_destinations/get_destination_cubit.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_destinations/get_destination_state.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/destination_card.widget.dart';

class SliverNearbyDestinationList extends StatefulWidget {
  @override
  State<SliverNearbyDestinationList> createState() =>
      _SliverNearbyDestinationListState();
}

class _SliverNearbyDestinationListState
    extends State<SliverNearbyDestinationList> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryRed,
                  AppColors.primaryRed.withOpacity(0.6),
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
                  right: -20,
                  child: Image.asset(
                    AppImage.rose,
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
                            AppLocalizations.of(context)!.nearby,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            AppLocalizations.of(context)!.nearbyDes,
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
                          return Container(
                            height: 300.h,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryWhite,
                              ),
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
                                style: TextStyle(color: AppColors.primaryWhite),
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
                                  'No destinations found',
                                  style: TextStyle(
                                    color: AppColors.primaryWhite,
                                  ),
                                ),
                              ),
                            );
                          }

                          final favoriteState =
                              context.watch<FavoriteDestinationsCubit>().state;
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
                                  location: destination.province ?? "Unknown",
                                  category:
                                      destination.type ??
                                      (destination.categories?.isNotEmpty ==
                                              true
                                          ? destination.categories!.first
                                          : "Destination"),
                                  onTap: () {
                                    Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).push(
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
    );
  }
}
