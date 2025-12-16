import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/widgets/itinerary_timeline.widget.dart';

class ItineraryDetailPage extends StatelessWidget {
  final Map<String, dynamic> itinerary;

  const ItineraryDetailPage({super.key, required this.itinerary});

  @override
  Widget build(BuildContext context) {
    // Unpack data (using dummy structure for now)
    final title = itinerary['title'] ?? 'Trip Details';
    final dateRange = itinerary['dateRange'] ?? 'Unknown Date';
    final status = itinerary['status'] ?? 'Scheduled';
    final imageUrl =
        itinerary['imageUrl'] ??
        'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=2073&auto=format&fit=crop';

    // Extended dummy data for detail view
    final days = [
      {'day': 'Day 1', 'activity': 'Arrival & Check-in', 'time': '10:00 AM'},
      {'day': 'Day 1', 'activity': 'City Tour', 'time': '02:00 PM'},
      {'day': 'Day 2', 'activity': 'Mountain Hiking', 'time': '08:00 AM'},
      {'day': 'Day 2', 'activity': 'Local Food Experience', 'time': '07:00 PM'},
      {'day': 'Day 3', 'activity': 'Departure', 'time': '12:00 PM'},
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.h,
            pinned: true,
            backgroundColor: AppColors.backgroundColor,
            leading: Padding(
              padding: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 8.h),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.9),
                child: IconButton(
                  icon: SvgPicture.asset(
        AppIcons.arrowLeft,
        width: 16.w,
        height: 16.h,
        colorFilter: ColorFilter.mode(
          AppColors.primaryBlack,
          BlendMode.srcIn,
        ),
      ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 16.w, top: 8.h, bottom: 8.h),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.black),
                    onPressed: () {
                      // Handle edit action
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            Container(color: Colors.grey),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20.h,
                    left: 20.w,
                    right: 20.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          margin: EdgeInsets.only(bottom: 8.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            status,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                        Text(
                          title,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(color: Colors.white),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Colors.white70,
                              size: 14.sp,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              dateRange,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
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
                  ItineraryTimeline(timelineItems: days),
                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
