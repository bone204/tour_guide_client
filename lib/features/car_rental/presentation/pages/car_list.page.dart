import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/card/vehicle_card.dart';
import 'package:tour_guide_app/common_libs.dart';

class CarListPage extends StatelessWidget {
  const CarListPage({super.key});

  void _navigateToCarDetailsPage(BuildContext context) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(AppRouteConstant.carDetails);
  }

  @override
  Widget build(BuildContext context) {
    final cars = [
      {
        "name": "Toyota Vios",
        "type": "Sedan",
        "price": 800000,
        "image": AppImage.defaultCar,
        "seats": 5,
      },
      {
        "name": "Ford Transit",
        "type": "Minivan",
        "price": 1200000,
        "image": AppImage.defaultCar,
        "seats": 16,
      },
      {
        "name": "Kia Morning",
        "type": "Hatchback",
        "price": 500000,
        "image": AppImage.defaultCar,
        "seats": 4,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.carList,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: cars.length,
        separatorBuilder: (_, __) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          final car = cars[index];
          return VehicleCard(
            name: car["name"] as String,
            type: car["type"] as String,
            price: car["price"] as int,
            imageUrl: car["image"] as String,
            seats: car["seats"] as int,
            onDetail: () => _navigateToCarDetailsPage(context),
            onRent: () {
              
            },
          );
        },
      ),
    );
  }
}
