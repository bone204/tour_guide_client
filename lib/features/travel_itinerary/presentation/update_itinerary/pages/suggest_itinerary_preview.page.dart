import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/core/utils/date_formatter.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/widgets/itinerary_timeline.widget.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/suggest_itinerary/suggest_itinerary_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/suggest_itinerary/suggest_itinerary_state.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/core/config/theme/color.dart';
import 'package:tour_guide_app/common/constants/app_route.constant.dart';

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

    return BlocConsumer<SuggestItineraryCubit, SuggestItineraryState>(
      listener: (context, state) {
        if (state.claimStatus == ClaimStatus.success &&
            state.claimedItinerary != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.useItinerarySuccess,
              ), // Placeholder for success
              backgroundColor: AppColors.primaryGreen,
            ),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouteConstant.mainScreen,
            (route) => false,
          );
          Navigator.of(context).pushNamed(AppRouteConstant.itineraryList);
          Navigator.of(context).pushNamed(
            AppRouteConstant.itineraryDetail,
            arguments: state.claimedItinerary!.id,
          );
        } else if (state.claimStatus == ClaimStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Error'),
              backgroundColor: AppColors.primaryRed,
            ),
          );
        }
      },
      builder: (context, state) {
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
                          itineraryId: 0,
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
          bottomNavigationBar: Container(
            padding: EdgeInsets.all(20.w),
            color: AppColors.primaryWhite,
            child: PrimaryButton(
              title: AppLocalizations.of(context)!.confirm,
              isLoading: state.claimStatus == ClaimStatus.loading,
              onPressed: () {
                context.read<SuggestItineraryCubit>().claimItinerary(itinerary);
              },
            ),
          ),
        );
      },
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
