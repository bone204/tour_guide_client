import 'package:timelines_plus/timelines_plus.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';

class ItineraryTimeline extends StatelessWidget {
  final List<Map<String, dynamic>> timelineItems;
  final int itineraryId;
  final String? itineraryStatus;

  const ItineraryTimeline({
    super.key,
    required this.timelineItems,
    required this.itineraryId,
    this.itineraryStatus,
  });

  @override
  Widget build(BuildContext context) {
    return FixedTimeline.tileBuilder(
      theme: TimelineThemeData(
        nodePosition: 0,
        color: AppColors.primaryGrey,
        indicatorTheme: IndicatorThemeData(position: 0, size: 20.0),
        connectorTheme: ConnectorThemeData(thickness: 2.5),
      ),
      builder: TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.before,
        itemCount: timelineItems.length,
        contentsBuilder: (context, index) {
          final item = timelineItems[index];
          return Padding(
            padding: EdgeInsets.only(left: 12.w, bottom: 24.h),
            child: _buildTimelineContent(context, item),
          );
        },
        indicatorBuilder: (_, index) {
          return DotIndicator(
            color: AppColors.primaryBlue,
            child: Icon(Icons.check, color: Colors.white, size: 10.0),
          );
        },
        connectorBuilder:
            (_, index, ___) => SolidLineConnector(
              color: AppColors.primaryBlue.withOpacity(0.3),
            ),
      ),
    );
  }

  String _getStopStatusText(BuildContext context, String status) {
    switch (status) {
      case 'upcoming':
        return AppLocalizations.of(context)!.stopStatusUpcoming;
      case 'in_progress':
        return AppLocalizations.of(context)!.stopStatusInProgress;
      case 'completed':
        return AppLocalizations.of(context)!.stopStatusCompleted;
      case 'missed':
        return AppLocalizations.of(context)!.stopStatusMissed;
      default:
        return status;
    }
  }

  IconData _getStopStatusIcon(String status) {
    switch (status) {
      case 'upcoming':
        return Icons.schedule_rounded;
      case 'in_progress':
        return Icons.play_circle_rounded;
      case 'completed':
        return Icons.check_circle_rounded;
      case 'missed':
        return Icons.cancel_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  Color _getStopStatusColor(String status) {
    switch (status) {
      case 'upcoming':
        return const Color(0xFF3B82F6); // Blue
      case 'in_progress':
        return const Color(0xFFF59E0B); // Amber
      case 'completed':
        return const Color(0xFF10B981); // Green
      case 'missed':
        return const Color(0xFF6B7280); // Gray
      default:
        return const Color(0xFF6B7280);
    }
  }

  Widget _buildTimelineContent(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
    final stop = item['stop'] as Stop;
    final imageUrl =
        (stop.destination?.photos != null &&
                stop.destination!.photos!.isNotEmpty)
            ? stop.destination!.photos!.first
            : null;

    return GestureDetector(
      onTap: () {
        if (itineraryStatus == 'preview') return;
        if (item['stop'] != null) {
          Navigator.pushNamed(
            context,
            AppRouteConstant.itineraryStopDetail,
            arguments: {
              'stop': item['stop'],
              'itineraryId': itineraryId,
              'itineraryStatus': itineraryStatus,
            },
          );
        }
      },
      child: Container(
        height: 160.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Background Image
              if (imageUrl != null)
                Image.network(imageUrl, fit: BoxFit.cover)
              else
                Container(
                  color: AppColors.primaryGrey.withOpacity(0.1),
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.primaryGrey,
                      size: 40.sp,
                    ),
                  ),
                ),

              // 2. Gradient Overlay for readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.2), // Slight dark at top
                      Colors.transparent,
                      Colors.black.withOpacity(0.8), // Dark at bottom for text
                    ],
                  ),
                ),
              ),

              // 3. Content
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Header: Time, Day, and Status Badges
                    if (itineraryStatus == 'in_progress')
                      // Use Wrap when status badge is present
                      Wrap(
                        spacing: 6.w,
                        runSpacing: 6.h,
                        children: [
                          // Time Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  color: Colors.white,
                                  size: 14.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  item['time']! as String,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Day Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              item['day']! as String,
                              style: Theme.of(
                                context,
                              ).textTheme.displayMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          // Status Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: _getStopStatusColor(stop.status),
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: _getStopStatusColor(
                                    stop.status,
                                  ).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getStopStatusIcon(stop.status),
                                  color: Colors.white,
                                  size: 14.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  _getStopStatusText(context, stop.status),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displayMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      // Use Row with spaceBetween when no status badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Time Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  color: Colors.white,
                                  size: 14.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  item['time']! as String,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Day Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              item['day']! as String,
                              style: Theme.of(
                                context,
                              ).textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                    // Footer: Activity Name
                    Text(
                      item['activity']! as String,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
