import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/restaurant/presentation/widgets/restaurant_card.widget.dart';

class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({super.key});

  void _navigateToRestaurantDetail(BuildContext context) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(AppRouteConstant.restaurantDetail);
  }

  @override
  Widget build(BuildContext context) {
    final restaurants = [
      {
        "name": AppLocalizations.of(context)!.saigonRestaurant,
        "cuisine": AppLocalizations.of(context)!.foodTypeVietnamese,
        "location":
            "${AppLocalizations.of(context)!.district1}, ${AppLocalizations.of(context)!.hcmCity}",
        "priceRange": 150000,
        "rating": 4.5,
        "image": AppImage.defaultFood,
      },
      {
        "name": AppLocalizations.of(context)!.thaiHotpot,
        "cuisine": AppLocalizations.of(context)!.thaiFood,
        "location":
            "${AppLocalizations.of(context)!.district1}, ${AppLocalizations.of(context)!.hcmCity}",
        "priceRange": 200000,
        "rating": 4.7,
        "image": AppImage.defaultFood,
      },
      {
        "name": AppLocalizations.of(context)!.sushiWorld,
        "cuisine": AppLocalizations.of(context)!.foodTypeJapanese,
        "location":
            "${AppLocalizations.of(context)!.district1}, ${AppLocalizations.of(context)!.hcmCity}",
        "priceRange": 300000,
        "rating": 4.8,
        "image": AppImage.defaultFood,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.restaurantList,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8.h,
          crossAxisSpacing: 16.w,
          itemCount: restaurants.length,
          itemBuilder: (context, index) {
            final restaurant = restaurants[index];
            return RestaurantCard(
              name: restaurant["name"] as String,
              cuisine: restaurant["cuisine"] as String,
              location: restaurant["location"] as String,
              priceRange: restaurant["priceRange"] as int,
              rating: (restaurant["rating"] as num).toDouble(),
              imageUrl: restaurant["image"] as String,
              onTap: () => _navigateToRestaurantDetail(context),
            );
          },
        ),
      ),
    );
  }
}
