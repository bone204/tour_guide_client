import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/my_itinerary/widgets/itinerary_action_buttons.widget.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/my_itinerary/widgets/itinerary_stats_grid.widget.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/my_itinerary/widgets/my_itinerary_header.widget.dart';

class MyItineraryPage extends StatelessWidget {
  const MyItineraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.myItinerary,
        showBackButton: true,
        backgroundColor: AppColors.backgroundColor,
        onBackPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const MyItineraryHeader(),
            SizedBox(height: 16.h),
            const ItineraryStatsGrid(),
            SizedBox(height: 4.h),
            const ItineraryActionButtons(),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
