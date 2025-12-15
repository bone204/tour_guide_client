import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';

class ItineraryDetailPage extends StatelessWidget {
  final String provinceName;

  const ItineraryDetailPage({super.key, required this.provinceName});

  @override
  Widget build(BuildContext context) {
    // Giả lập dữ liệu itinerary cơ bản
    final itineraryInfo = {
      AppLocalizations.of(context)!.itineraryName: AppLocalizations.of(
        context,
      )!.exploreProvince(provinceName),
      AppLocalizations.of(context)!.itineraryCity: provinceName,
      AppLocalizations.of(context)!.itineraryDays: 3,
      AppLocalizations.of(context)!.itineraryPlaces: 5,
      AppLocalizations.of(context)!.itineraryStartDate: '01/01/2026',
      AppLocalizations.of(context)!.itineraryEndDate: '03/01/2026',
    };

    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.itineraryDetailTitle,
        showBackButton: true,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.itineraryInfo,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20.h),
            ...itineraryInfo.entries.map(
              (e) => Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        e.key,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSubtitle,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        e.value.toString(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
