import 'package:tour_guide_app/common_libs.dart';

class AboutTab extends StatelessWidget {
  final String description;

  const AboutTab({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.description,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: 12.h),
        Text(
          description.isEmpty
              ? AppLocalizations.of(context)!.noDescription
              : description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.6,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
