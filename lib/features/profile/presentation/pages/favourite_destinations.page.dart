import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/destination/presentation/pages/destination_detail.page.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/attraction_card.widget.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_favorites_cubit.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_favorites_state.dart';
import 'package:tour_guide_app/features/profile/presentation/pages/favourite_destinations_search.page.dart';

class FavouriteDestinationsPage extends StatefulWidget {
  const FavouriteDestinationsPage({super.key});

  static Widget withProvider() {
    return BlocProvider(
      create: (context) => GetFavoritesCubit()..getFavorites(),
      child: const FavouriteDestinationsPage(),
    );
  }

  @override
  State<FavouriteDestinationsPage> createState() => _FavouriteDestinationsPageState();
}

class _FavouriteDestinationsPageState extends State<FavouriteDestinationsPage> {

  @override
  Widget build(BuildContext context) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final isVietnamese = localeCode == 'vi';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        backgroundColor: AppColors.primaryBlue,
        titleColor: AppColors.primaryWhite,
        title: isVietnamese ? 'Điểm yêu thích' : 'Favourite Destinations',
        onBackPressed: () => Navigator.of(context).pop(),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              AppIcons.search,
              width: 20.w,
              height: 20.h,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryWhite,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FavouriteDestinationsSearchPage.withProvider(),
                ),
              );
            },
          ),
        ],
      ),
      body: _buildFavoritesList(context, isVietnamese),
    );
  }

  Widget _buildFavoritesList(BuildContext context, bool isVietnamese) {
    return BlocBuilder<GetFavoritesCubit, GetFavoritesState>(
      builder: (context, state) {
          if (state is GetFavoritesLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryBlue,
              ),
            );
          }

          if (state is GetFavoritesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.r,
                    color: AppColors.primaryRed,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSubtitle,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<GetFavoritesCubit>().getFavorites();
                    },
                    child: Text(isVietnamese ? 'Thử lại' : 'Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is GetFavoritesLoaded) {
            final destinations = state.destinations;

            if (destinations.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64.r,
                      color: AppColors.textSubtitle.withOpacity(0.5),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      isVietnamese ? 'Chưa có địa điểm yêu thích' : 'No favourite destinations',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textSubtitle,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      isVietnamese 
                          ? 'Thêm địa điểm vào yêu thích để xem ở đây'
                          : 'Add destinations to favourites to see them here',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSubtitle.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<GetFavoritesCubit>().getFavorites();
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isVietnamese 
                          ? '${destinations.length} địa điểm yêu thích'
                          : '${destinations.length} favourite destinations',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    MasonryGridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8.h,
                            crossAxisSpacing: 16.w,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: destinations.length,
                            itemBuilder: (context, index) {
                              final destination = destinations[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true).push(
                                    MaterialPageRoute(
                                      builder: (context) => DestinationDetailPage.withProvider(
                                        destinationId: destination.id,
                                      ),
                                    ),
                                  );
                                },
                                child: AttractionCard(
                                  imageUrl: destination.photos?.isNotEmpty == true
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
                  ],
                ),
              ),
            );
          }

          return Container();
        },
      );
  }
}

