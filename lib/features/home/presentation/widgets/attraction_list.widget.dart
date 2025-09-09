// ignore_for_file: deprecated_member_use
import 'package:tour_guide_app/common_libs.dart';

class SliverRestaurantNearbyAttractionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
        ),
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.attraction,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.textPrimary),
              ),
              SizedBox(height: 4.h),
              Text(
                AppLocalizations.of(context)!.attractionDes,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
