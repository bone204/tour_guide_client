import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common_libs.dart';

class RestaurantInfoItem extends StatelessWidget {
  final String icon;
  final String text;

  const RestaurantInfoItem({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.primaryGrey.withOpacity(0.5),
          width: 1.w,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: 24.w,
            height: 24.h,
            color: AppColors.primaryBlue,
          ),
          SizedBox(height: 6.h),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

