import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common_libs.dart';

class CarInfoItem extends StatelessWidget {
  final String icon;
  final String text;

  const CarInfoItem({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      margin: EdgeInsets.only(right: 8.w, top: 6.h, bottom: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite, 
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primaryBlue),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: 20.w,
            height: 20.h,
            color: AppColors.primaryBlue,
          ),
          SizedBox(height: 8.h),
          Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
