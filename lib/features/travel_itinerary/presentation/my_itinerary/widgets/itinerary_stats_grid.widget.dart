import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/my_itinerary/widgets/itinerary_stat_card.widget.dart';

class ItineraryStatsGrid extends StatelessWidget {
  const ItineraryStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final stats = [
      _StatItem(
        title: l10n.totalTrips,
        value: '12',
        iconAsset: AppIcons.travel,
        gradientColors: [
          const Color(0xFF6A11CB),
          const Color(0xFF2575FC),
        ], // Purple to Blue
        shadowColor: const Color(0xFF6A11CB),
      ),
      _StatItem(
        title: l10n.upcomingTrips,
        value: '2',
        iconAsset: AppIcons.calendar,
        gradientColors: [
          const Color(0xFFFF512F),
          const Color(0xFFDD2476),
        ], // Orange to Red
        shadowColor: const Color(0xFFFF512F),
      ),
      _StatItem(
        title: l10n.completedTrips,
        value: '10',
        iconAsset: AppIcons.star,
        gradientColors: [
          const Color(0xFF11998e),
          const Color(0xFF38ef7d),
        ], // Green to Light Green
        shadowColor: const Color(0xFF11998e),
      ),
    ];

    return SizedBox(
      height: 130.h,
      child: PageView.builder(
        clipBehavior: Clip.none,
        controller: PageController(viewportFraction: (1.sw - 24.w) / 1.sw),
        itemCount: stats.length,
        itemBuilder: (context, index) {
          final item = stats[index];
          return ItineraryStatCard(
            title: item.title,
            value: item.value,
            iconAsset: item.iconAsset,
            gradientColors: item.gradientColors,
            shadowColor: item.shadowColor,
          );
        },
      ),
    );
  }
}

class _StatItem {
  final String title;
  final String value;
  final String iconAsset;
  final List<Color> gradientColors;
  final Color shadowColor;

  _StatItem({
    required this.title,
    required this.value,
    required this.iconAsset,
    required this.gradientColors,
    required this.shadowColor,
  });
}
