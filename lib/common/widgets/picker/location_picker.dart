import 'package:flutter_svg/svg.dart';
import 'package:tour_guide_app/common_libs.dart';

class LocationField extends StatelessWidget {
  final String? label;
  final String placeholder;
  final String? locationText;

  const LocationField({
    super.key,
    this.label,
    required this.placeholder,
    this.locationText,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = locationText ?? placeholder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          SizedBox(height: 8.h),
        ],
        GestureDetector(
          onTap: () {
            debugPrint('LocationField tapped: $displayText');
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.primaryGrey, width: 1.w),
            ),
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: SvgPicture.asset(
                      AppIcons.location,
                      width: 20.w,
                      height: 20.h,
                      color: AppColors.primaryBlack,
                    )
                  ),
                Expanded(
                  child: Text(
                    displayText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: locationText == null ? AppColors.textSubtitle : AppColors.primaryBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
