import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';

class MyItineraryListPage extends StatelessWidget {
  const MyItineraryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.myItinerary,
        onBackPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: const Center(child: Text('My Itinerary List')),
    );
  }
}
