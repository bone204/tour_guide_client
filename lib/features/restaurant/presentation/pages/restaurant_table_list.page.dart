import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_search_response.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_table_search_request.dart';
import 'package:tour_guide_app/features/restaurant/presentation/bloc/search_restaurant_tables/search_restaurant_tables_cubit.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/favorite_cooperations/favorite_cooperations_cubit.dart';
import 'package:tour_guide_app/features/restaurant/presentation/widgets/restaurant_card.widget.dart';
import 'package:tour_guide_app/features/restaurant/presentation/widgets/restaurant_list_shimmer.widget.dart';
import 'package:tour_guide_app/service_locator.dart';

class RestaurantTableListPage extends StatefulWidget {
  final RestaurantTableSearchRequest? request;

  const RestaurantTableListPage({super.key, this.request});

  @override
  State<RestaurantTableListPage> createState() =>
      _RestaurantTableListPageState();
}

class _RestaurantTableListPageState extends State<RestaurantTableListPage> {
  List<RestaurantSearchResponse> _restaurants = [];
  late SearchRestaurantTablesCubit _searchCubit;

  @override
  void initState() {
    super.initState();
    _searchCubit = sl<SearchRestaurantTablesCubit>();
    _fetchRestaurants();
  }

  void _fetchRestaurants() {
    final searchRequest = widget.request ?? RestaurantTableSearchRequest();
    _searchCubit.searchRestaurants(searchRequest);
  }

  @override
  void dispose() {
    _searchCubit.close();
    super.dispose();
  }

  void _navigateToRestaurantDetail(RestaurantSearchResponse restaurant) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(AppRouteConstant.restaurantDetail, arguments: restaurant);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _searchCubit),
        BlocProvider(
          create: (context) => sl<FavoriteCooperationsCubit>()..loadFavorites(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.restaurantList,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: BlocConsumer<
          SearchRestaurantTablesCubit,
          SearchRestaurantTablesState
        >(
          listener: (context, state) {
            if (state.status == SearchRestaurantTablesStatus.failure) {
              CustomSnackbar.show(
                context,
                message:
                    state.errorMessage ??
                    AppLocalizations.of(context)!.errorOccurred,
                type: SnackbarType.error,
              );
            } else if (state.status == SearchRestaurantTablesStatus.success) {
              setState(() {
                _restaurants = state.restaurants;
              });
            }
          },
          builder: (context, state) {
            if (state.status == SearchRestaurantTablesStatus.loading) {
              return const RestaurantListShimmer();
            }

            if (_restaurants.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_outlined,
                      size: 64.sp,
                      color: AppColors.textSubtitle,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      AppLocalizations.of(context)!.noRestaurantsFound,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textSubtitle,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: _restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = _restaurants[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: RestaurantCard(
                    restaurant: restaurant,
                    onTap: () => _navigateToRestaurantDetail(restaurant),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
