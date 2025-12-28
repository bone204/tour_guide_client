import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/core/utils/date_formatter.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/widgets/itinerary_timeline.widget.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';

class SuggestItineraryPreviewPage extends StatelessWidget {
  final Itinerary itinerary;

  const SuggestItineraryPreviewPage({super.key, required this.itinerary});

  @override
  Widget build(BuildContext context) {
    final dateRange = DateFormatter.formatDateRange(
      itinerary.startDate,
      itinerary.endDate,
    );

    final List<Map<String, dynamic>> timelineItems =
        itinerary.stops
            .map(
              (stop) => <String, dynamic>{
                'day': AppLocalizations.of(
                  context,
                )!.dayNumber(stop.dayOrder > 0 ? stop.dayOrder : 1),
                'activity': stop.destination?.name ?? '',
                'time': stop.startTime,
                'stop': stop,
              },
            )
            .toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.itineraryPreview,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, dateRange),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.itinerarySchedule,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  if (timelineItems.isNotEmpty)
                    ItineraryTimeline(
                      timelineItems: timelineItems,
                      itineraryId: 0, // 0 for preview since not saved yet
                    )
                  else
                    Center(
                      child: Text(AppLocalizations.of(context)!.noSchedule),
                    ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String dateRange) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGrey.withOpacity(0.25),
              blurRadius: 8.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      
            Text(
              itinerary.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.primaryBlack,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                SvgPicture.asset(
                  AppIcons.calendar,
                  width: 16.w,
                  height: 16.h,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryBlue,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  dateRange,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.primaryGrey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
