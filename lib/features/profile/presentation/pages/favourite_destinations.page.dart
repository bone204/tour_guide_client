import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/favorite_cooperations/favorite_cooperations_cubit.dart';

import 'package:tour_guide_app/features/destination/presentation/pages/destination_detail.page.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/attraction_card.widget.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_favorite_cooperations/get_favorite_cooperations_cubit.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_favorite_cooperations/get_favorite_cooperations_state.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_favorites/get_favorites_cubit.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_favorites/get_favorites_state.dart';
import 'package:tour_guide_app/features/profile/presentation/pages/favourite_destinations_search.page.dart';
import 'package:tour_guide_app/service_locator.dart';

class FavouriteDestinationsPage extends StatefulWidget {
  const FavouriteDestinationsPage({super.key});

  static Widget withProvider() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GetFavoritesCubit()..getFavorites()),
        BlocProvider(
          create: (context) => GetFavoriteCooperationsCubit()..getFavorites(),
        ),
        BlocProvider(
          create: (context) => sl<FavoriteCooperationsCubit>()..loadFavorites(),
        ),
      ],
      child: const FavouriteDestinationsPage(),
    );
  }

  @override
  State<FavouriteDestinationsPage> createState() =>
      _FavouriteDestinationsPageState();
}

class _FavouriteDestinationsPageState extends State<FavouriteDestinationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final isVietnamese = localeCode == 'vi';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        backgroundColor: AppColors.primaryBlue,
        titleColor: AppColors.primaryWhite,
        title: AppLocalizations.of(context)!.favouriteDestinations,
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
                  builder:
                      (context) =>
                          FavouriteDestinationsSearchPage.withProvider(),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryWhite,
          unselectedLabelColor: AppColors.primaryWhite.withOpacity(0.6),
          indicatorColor: AppColors.primaryWhite,
          indicatorWeight: 3.h,
          labelStyle: Theme.of(context).textTheme.titleMedium,
          tabs: [
            Tab(text: isVietnamese ? 'Điểm đến' : 'Destinations'),
            Tab(text: isVietnamese ? 'Dịch vụ' : 'Services'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFavoritesList(context, isVietnamese),
          _buildFavoriteCooperationsList(context, isVietnamese),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(BuildContext context, bool isVietnamese) {
    return BlocBuilder<GetFavoritesCubit, GetFavoritesState>(
      builder: (context, state) {
        if (state is GetFavoritesLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }

        if (state is GetFavoritesError) {
          return _buildErrorState(context, state.message, () {
            context.read<GetFavoritesCubit>().getFavorites();
          });
        }

        if (state is GetFavoritesLoaded) {
          final destinations = state.destinations;

          if (destinations.isEmpty) {
            return _buildEmptyState(context, isVietnamese);
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
                              builder:
                                  (context) =>
                                      DestinationDetailPage.withProvider(
                                        destinationId: destination.id,
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
                ],
              ),
            ),
          );
        }

        return Container();
      },
    );
  }

  Widget _buildFavoriteCooperationsList(
    BuildContext context,
    bool isVietnamese,
  ) {
    return BlocBuilder<
      GetFavoriteCooperationsCubit,
      GetFavoriteCooperationsState
    >(
      builder: (context, state) {
        if (state is GetFavoriteCooperationsLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }

        if (state is GetFavoriteCooperationsError) {
          return _buildErrorState(context, state.message, () {
            context.read<GetFavoriteCooperationsCubit>().getFavorites();
          });
        }

        if (state is GetFavoriteCooperationsLoaded) {
          final cooperations = state.cooperations;

          if (cooperations.isEmpty) {
            return _buildEmptyState(context, isVietnamese);
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<GetFavoriteCooperationsCubit>().getFavorites();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isVietnamese
                        ? '${cooperations.length} dịch vụ yêu thích'
                        : '${cooperations.length} favourite services',
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
                    itemCount: cooperations.length,
                    itemBuilder: (context, index) {
                      final cooperation = cooperations[index];
                      // Wrap CooperationCard to constrain width in Grid or ensure it fits
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pushNamed(
                            AppRouteConstant.cooperationDetail,
                            arguments: cooperation.id,
                          );
                        },
                        child: AttractionCard(
                          imageUrl:
                              cooperation.photo ?? AppImage.defaultDestination,
                          title: cooperation.name,
                          location:
                              cooperation.province ??
                              cooperation.address ??
                              "Unknown",
                          rating:
                              double.tryParse(cooperation.averageRating) ?? 0.0,
                          reviews: 0,
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

  Widget _buildErrorState(
    BuildContext context,
    String message,
    VoidCallback onRetry,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.r, color: AppColors.primaryRed),
          SizedBox(height: 16.h),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSubtitle),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isVietnamese) {
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
            isVietnamese ? 'Chưa có yêu thích nào' : 'No favorites yet',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.textSubtitle),
          ),
          SizedBox(height: 8.h),
          Text(
            isVietnamese
                ? 'Thêm vào yêu thích để xem ở đây'
                : 'Add to favorites to see them here',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSubtitle.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
