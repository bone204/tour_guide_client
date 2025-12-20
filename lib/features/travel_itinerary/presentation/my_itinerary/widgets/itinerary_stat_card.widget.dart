import 'package:tour_guide_app/common_libs.dart';

class ItineraryStatCard extends StatelessWidget {
  const ItineraryStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.iconAsset,
    required this.gradientColors,
    required this.shadowColor,
  });

  final String title;
  final String value;
  final String iconAsset;
  final List<Color> gradientColors;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 16.h),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.4),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: SvgPicture.asset(
              iconAsset,
              width: 28.w,
              height: 28.h,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
