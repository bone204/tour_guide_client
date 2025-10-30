import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/restaurant/presentation/widgets/table_card.widget.dart';

class RestaurantTableListPage extends StatelessWidget {
  const RestaurantTableListPage({super.key});

  void _navigateToBookingInfo(BuildContext context) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(AppRouteConstant.restaurantBookingInfo);
  }

  @override
  Widget build(BuildContext context) {
    final tables = [
      {
        "tableName": "Bàn 01",
        "seats": 2,
        "location": "Tầng 1 - Gần cửa sổ",
        "isAvailable": true,
      },
      {
        "tableName": "Bàn 02",
        "seats": 4,
        "location": "Tầng 1 - Giữa phòng",
        "isAvailable": true,
      },
      {
        "tableName": "Bàn 03",
        "seats": 6,
        "location": "Tầng 2 - VIP",
        "isAvailable": false,
      },
      {
        "tableName": "Bàn 04",
        "seats": 4,
        "location": "Tầng 1 - Góc phòng",
        "isAvailable": true,
      },
      {
        "tableName": "Bàn 05",
        "seats": 8,
        "location": "Tầng 2 - Phòng riêng",
        "isAvailable": true,
      },
      {
        "tableName": "Bàn 06",
        "seats": 2,
        "location": "Tầng 1 - Ban công",
        "isAvailable": false,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'Chọn bàn',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 0.95,
        ),
        itemCount: tables.length,
        itemBuilder: (context, index) {
          final table = tables[index];
          return TableCard(
            tableName: table["tableName"] as String,
            seats: table["seats"] as int,
            location: table["location"] as String,
            isAvailable: table["isAvailable"] as bool,
            onSelect: () => _navigateToBookingInfo(context),
          );
        },
      ),
    );
  }
}

