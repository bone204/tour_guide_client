import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/card/vehicle_card.dart';
import 'package:tour_guide_app/common_libs.dart';

class MotorbikeListPage extends StatelessWidget {
  const MotorbikeListPage({super.key});

  void _navigateToMotorbikeDetailsPage(BuildContext context) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(AppRouteConstant.motorbikeDetails);
  }

  void _navigateToMotorbikeBillPage(BuildContext context) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(AppRouteConstant.motorbikeBill);
  }

  @override
  Widget build(BuildContext context) {
    final motorbikes = [
      {
        "name": "Honda Wave RSX",
        "type": "Số",
        "price": 100000,
        "image": AppImage.defaultCar,
        "seats": 2,
      },
      {
        "name": "Yamaha Exciter",
        "type": "Côn tay",
        "price": 150000,
        "image": AppImage.defaultCar,
        "seats": 2,
      },
      {
        "name": "Honda SH",
        "type": "Tự động",
        "price": 200000,
        "image": AppImage.defaultCar,
        "seats": 2,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.motorbikeList,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: motorbikes.length,
        separatorBuilder: (_, __) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          final motorbike = motorbikes[index];
          return VehicleCard(
            name: motorbike["name"] as String,
            type: motorbike["type"] as String,
            price: motorbike["price"] as int,
            imageUrl: motorbike["image"] as String,
            seats: motorbike["seats"] as int,
            onDetail: () => _navigateToMotorbikeDetailsPage(context),
            onRent: () => _navigateToMotorbikeBillPage(context),
          );
        },
      ),
    );
  }
}

