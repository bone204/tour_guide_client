import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_search_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';
import 'package:tour_guide_app/features/destination/presentation/pages/destination_detail.page.dart';
import 'package:tour_guide_app/features/home/presentation/widgets/attraction_card.widget.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_favorites/get_favorites_cubit.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_favorites/get_favorites_state.dart';

class FavouriteDestinationsSearchPage extends StatefulWidget {
  const FavouriteDestinationsSearchPage({super.key});

  static Widget withProvider() {
    return BlocProvider(
      create: (context) => GetFavoritesCubit()..getFavorites(),
      child: const FavouriteDestinationsSearchPage(),
    );
  }

  @override
  State<FavouriteDestinationsSearchPage> createState() =>
      _FavouriteDestinationsSearchPageState();
}

class _FavouriteDestinationsSearchPageState
    extends State<FavouriteDestinationsSearchPage> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = value.trim().toLowerCase();
      });
    });
  }

  List<Destination> _filterDestinations(
    List<Destination> destinations,
    String query,
  ) {
    if (query.isEmpty) return [];

    return destinations.where((destination) {
      final name = destination.name.toLowerCase();
      final province = destination.province?.toLowerCase() ?? '';
      final type = destination.type?.toLowerCase() ?? '';

      return name.contains(query) ||
          province.contains(query) ||
          type.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomSearchAppBar(
        hintText: AppLocalizations.of(context)!.searchDestinationsHint,
        controller: _controller,
        onBack: () => Navigator.of(context).pop(),
        onSearchChanged: _onSearchChanged,
      ),
      body: BlocBuilder<GetFavoritesCubit, GetFavoritesState>(
        builder: (context, state) {
          if (state is GetFavoritesLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
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
                ],
              ),
            );
          }

          if (state is GetFavoritesLoaded) {
            final allDestinations = state.destinations;
            final destinations = _filterDestinations(
              allDestinations,
              _searchQuery,
            );

            if (_searchQuery.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      size: 64.r,
                      color: AppColors.textSubtitle.withOpacity(0.3),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      AppLocalizations.of(context)!.searchInFavourites,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textSubtitle,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      AppLocalizations.of(context)!.enterDestinationName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSubtitle.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (destinations.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64.r,
                      color: AppColors.textSubtitle.withOpacity(0.5),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      AppLocalizations.of(context)!.noResultsFound,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSubtitle,
                      ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search result header
                  Text(
                    AppLocalizations.of(
                      context,
                    )!.foundResults(destinations.length),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Grid of attraction cards
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
            );
          }

          return Container();
        },
      ),
    );
  }
}
