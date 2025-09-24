import 'dart:math';
import 'package:tour_guide_app/common_libs.dart';

class FeatureChip extends StatelessWidget {
  final String text;

  const FeatureChip({Key? key, required this.text}) : super(key: key);

  Color _randomColor() {
    final colors = [
      AppColors.primaryBlue,
      AppColors.primaryGreen,
      AppColors.primaryOrange,
      AppColors.primaryPink,
      AppColors.primaryPurple,
      AppColors.primaryRed,
    ];
    return colors[Random().nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        text,
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      backgroundColor: _randomColor(),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
        side: BorderSide.none, 
      ),
    );
  }
}
