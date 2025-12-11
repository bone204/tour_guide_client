import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/my_itinerary/widgets/itinerary_action_button.widget.dart';

class ItineraryActionButtons extends StatelessWidget {
  const ItineraryActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          ItineraryActionButton(
            title: AppLocalizations.of(context)!.createTrip,
            description: AppLocalizations.of(context)!.createTripDesc,
            iconAsset: AppIcons.calendar,
            color: AppColors.primaryBlue,
            onTap: () {
              Navigator.of(
                context,
              ).pushNamed(AppRouteConstant.itineraryProvinceSelection);
            },
          ),
          SizedBox(height: 16.h),
          ItineraryActionButton(
            title: AppLocalizations.of(context)!.tripList,
            description: AppLocalizations.of(context)!.tripListDesc,
            iconAsset: AppIcons.location,
            color: AppColors.primaryOrange,
            onTap: () {
              // Navigate to trip list
            },
          ),
          SizedBox(height: 16.h),
          ItineraryActionButton(
            title: AppLocalizations.of(context)!.foodWheel,
            description: AppLocalizations.of(context)!.foodWheelDesc,
            iconAsset: AppIcons.restaurant,
            color: AppColors.primaryGreen,
            onTap: () {
              // Navigate to food wheel
            },
          ),
        ],
      ),
    );
  }
}
