import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/my_itinerary/widgets/itinerary_card.widget.dart';

class ItineraryListPage extends StatelessWidget {
  const ItineraryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final itineraries = [
      {
        'title': 'Summer Vacation in Da Nang',
        'dateRange': '15 Jun - 20 Jun 2024',
        'destinationCount': '5',
        'status': 'Upcoming',
      },
      {
        'title': 'Weekend Trip to Dalat',
        'dateRange': '01 May - 03 May 2024',
        'destinationCount': '3',
        'status': 'Completed',
      },
      {
        'title': 'Hanoi Historical Tour',
        'dateRange': '10 Oct - 12 Oct 2023',
        'destinationCount': '8',
        'status': 'Completed',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.tripList,
        showBackButton: true,
        backgroundColor: AppColors.backgroundColor,
        onBackPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: ListView.builder(
          itemCount: itineraries.length,
          itemBuilder: (context, index) {
            final item = itineraries[index];
            return ItineraryCard(
              title: item['title']!,
              dateRange: item['dateRange']!,
              destinationCount: item['destinationCount']!,
              status: item['status']!,
              onTap: () {
                Navigator.of(
                  context,
                ).pushNamed(AppRouteConstant.itineraryDetail, arguments: item);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).pushNamed(AppRouteConstant.itineraryProvinceSelection);
        },
        backgroundColor: AppColors.primaryBlue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
