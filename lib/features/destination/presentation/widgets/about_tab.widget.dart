import 'package:tour_guide_app/common_libs.dart';

class AboutTab extends StatelessWidget {
  final String name;

  const AboutTab({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'Discover the beauty of $name. This stunning destination offers breathtaking views, rich cultural experiences, and unforgettable memories. Perfect for travelers seeking adventure and relaxation.\n\nWhether you\'re exploring historic landmarks, enjoying local cuisine, or simply taking in the scenery, this location has something special for everyone.\n\nThe destination is known for its unique charm and exceptional experiences that leave lasting impressions on every visitor. From morning till evening, there are countless activities and sights to explore.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.6,
            color: AppColors.textSubtitle,
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}

