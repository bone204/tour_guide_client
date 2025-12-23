import 'package:flutter/material.dart';
import 'package:tour_guide_app/common_libs.dart';

class ProfileVerificationBadge extends StatelessWidget {
  final bool isVerified;
  final VoidCallback? onTap;

  const ProfileVerificationBadge({
    Key? key,
    required this.isVerified,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isVerified) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        padding: EdgeInsets.all(4.w),
        decoration: const BoxDecoration(
          color: AppColors.primaryGreen,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check, color: Colors.white, size: 12.sp),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              AppLocalizations.of(context)!.verify,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
