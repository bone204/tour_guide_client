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
        "tableName": "${AppLocalizations.of(context)!.table} 01",
        "seats": 2,
        "location":
            "${AppLocalizations.of(context)!.floor1} - ${AppLocalizations.of(context)!.nearWindow}",
        "isAvailable": true,
      },
      {
        "tableName": "${AppLocalizations.of(context)!.table} 02",
        "seats": 4,
        "location":
            "${AppLocalizations.of(context)!.floor1} - ${AppLocalizations.of(context)!.middleOfRoom}",
        "isAvailable": true,
      },
      {
        "tableName": "${AppLocalizations.of(context)!.table} 03",
        "seats": 6,
        "location":
            "${AppLocalizations.of(context)!.floor2} - ${AppLocalizations.of(context)!.vip}",
        "isAvailable": false,
      },
      {
        "tableName": "${AppLocalizations.of(context)!.table} 04",
        "seats": 4,
        "location":
            "${AppLocalizations.of(context)!.floor1} - ${AppLocalizations.of(context)!.cornerOfRoom}",
        "isAvailable": true,
      },
      {
        "tableName": "${AppLocalizations.of(context)!.table} 05",
        "seats": 8,
        "location":
            "${AppLocalizations.of(context)!.floor2} - ${AppLocalizations.of(context)!.privateRoom}",
        "isAvailable": true,
      },
      {
        "tableName": "${AppLocalizations.of(context)!.table} 06",
        "seats": 2,
        "location":
            "${AppLocalizations.of(context)!.floor1} - ${AppLocalizations.of(context)!.balcony}",
        "isAvailable": false,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.selectTable,
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
