import 'package:tour_guide_app/common_libs.dart';

class ItineraryActionButton extends StatelessWidget {
  const ItineraryActionButton({
    super.key,
    required this.title,
    required this.iconAsset,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String iconAsset;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGrey.withOpacity(0.25),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () async {
            await Future.delayed(const Duration(milliseconds: 200));
            onTap();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    iconAsset,
                    width: 20.w,
                    height: 20.h,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.titleSmall?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                SvgPicture.asset(
                  AppIcons.arrowRight,
                  width: 16.w,
                  height: 16.h,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryGrey,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
