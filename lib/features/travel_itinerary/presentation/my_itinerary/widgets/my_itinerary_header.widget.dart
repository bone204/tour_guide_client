import 'package:lottie/lottie.dart';
import 'package:tour_guide_app/common_libs.dart';

class MyItineraryHeader extends StatelessWidget {
  const MyItineraryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.h,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Modern clean background container
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32.r),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFE8F5E9).withOpacity(0.8), // Light Green 50
                    const Color(0xFFC8E6C9).withOpacity(0.6), // Light Green 100
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Subtle decorative circle
                  Positioned(
                    top: -20,
                    right: -20,
                    child: Container(
                      width: 150.w,
                      height: 150.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryGreen.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    left: -30,
                    child: Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(
                          0xFF81C784,
                        ).withOpacity(0.1), // Green 300
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Animation
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Lottie.asset(
              AppLotties.travelFun,
              width: 300.w,
              height: 300.h,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image_not_supported,
                  size: 64.sp,
                  color: AppColors.primaryGrey,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
