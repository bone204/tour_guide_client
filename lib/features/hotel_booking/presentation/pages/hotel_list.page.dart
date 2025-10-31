import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/hotel_booking/presentation/widgets/hotel_card.widget.dart';

class HotelListPage extends StatelessWidget {
  const HotelListPage({super.key});

  void _navigateToHotelDetail(BuildContext context) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(AppRouteConstant.hotelDetail);
  }

  @override
  Widget build(BuildContext context) {
    final hotels = [
      {
        "name": "Khách sạn Continental",
        "type": "Khách sạn 5 sao",
        "location": "Quận 1, TP.HCM",
        "pricePerNight": 1500000.0,
        "rating": 4.8,
        "image": AppImage.defaultCar,
      },
      {
        "name": "Rex Hotel",
        "type": "Khách sạn 4 sao",
        "location": "Quận 1, TP.HCM",
        "pricePerNight": 1200000.0,
        "rating": 4.6,
        "image": AppImage.defaultCar,
      },
      {
        "name": "New World Saigon",
        "type": "Khách sạn 5 sao",
        "location": "Quận 1, TP.HCM",
        "pricePerNight": 2000000.0,
        "rating": 4.9,
        "image": AppImage.defaultCar,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'Danh sách khách sạn',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8.h,
          crossAxisSpacing: 16.w,
          itemCount: hotels.length,
          itemBuilder: (context, index) {
            final hotel = hotels[index];
            return HotelCard(
              name: hotel["name"] as String,
              type: hotel["type"] as String,
              location: hotel["location"] as String,
              pricePerNight: hotel["pricePerNight"] as double,
              rating: (hotel["rating"] as num).toDouble(),
              imageUrl: hotel["image"] as String,
              onTap: () => _navigateToHotelDetail(context),
            );
          },
        ),
      ),
    );
  }
}

