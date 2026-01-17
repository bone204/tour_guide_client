import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/restaurant/presentation/bloc/restaurant_list/restaurant_list_cubit.dart';
import 'package:tour_guide_app/features/restaurant/presentation/bloc/restaurant_list/restaurant_list_state.dart';
import 'package:tour_guide_app/features/restaurant/presentation/widgets/restaurant_card.widget.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_search_response.dart';
import 'package:tour_guide_app/service_locator.dart';

class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({super.key});

  void _navigateToRestaurantDetail(
    BuildContext context,
    RestaurantSearchResponse restaurant,
  ) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(AppRouteConstant.restaurantDetail, arguments: restaurant);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RestaurantListCubit>()..getRestaurants(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.restaurantList,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: BlocBuilder<RestaurantListCubit, RestaurantListState>(
          builder: (context, state) {
            if (state is RestaurantListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RestaurantListError) {
              return Center(child: Text(state.message));
            } else if (state is RestaurantListLoaded) {
              final restaurants = state.restaurants;
              if (restaurants.isEmpty) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.noData),
                );
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.h,
                  crossAxisSpacing: 16.w,
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = restaurants[index];
                    return RestaurantCard(
                      restaurant: restaurant,
                      onTap:
                          () =>
                              _navigateToRestaurantDetail(context, restaurant),
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
