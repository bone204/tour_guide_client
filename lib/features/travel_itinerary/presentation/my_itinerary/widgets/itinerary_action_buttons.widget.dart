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
            title: AppLocalizations.of(context)!.tripList,
            iconAsset: AppIcons.location,
            color: AppColors.primaryOrange,
            onTap: () {
              Navigator.of(context).pushNamed(AppRouteConstant.itineraryList);
            },
          ),
          SizedBox(height: 16.h),
          ItineraryActionButton(
            title: AppLocalizations.of(context)!.explore,
            iconAsset: AppIcons.star,
            color: AppColors.primaryBlue,
            onTap: () {
              Navigator.of(context).pushNamed(AppRouteConstant.itineraryExplore);
            },
          ),
          SizedBox(height: 16.h),
          ItineraryActionButton(
            title: AppLocalizations.of(context)!.foodWheel,
            iconAsset: AppIcons.restaurant,
            color: AppColors.primaryGreen,
            onTap: () {
              Navigator.of(context).pushNamed(AppRouteConstant.foodWheel);
            },
          ),
        ],
      ),
    );
  }
}
