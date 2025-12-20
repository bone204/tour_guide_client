import 'package:timelines_plus/timelines_plus.dart';
import 'package:tour_guide_app/common_libs.dart';

class ItineraryTimeline extends StatelessWidget {
  final List<Map<String, dynamic>> timelineItems;
  final int itineraryId;

  const ItineraryTimeline({
    super.key,
    required this.timelineItems,
    required this.itineraryId,
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

  Widget _buildTimelineContent(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
    return GestureDetector(
      onTap: () {
        if (item['stop'] != null) {
          Navigator.pushNamed(
            context,
            AppRouteConstant.itineraryStopDetail,
            arguments: {'stop': item['stop'], 'itineraryId': itineraryId},
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['time']! as String,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primaryBlue,
                  ),
                ),
                Text(
                  item['day']! as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSubtitle,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              item['activity']! as String,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
