import 'package:flutter/material.dart';
import 'package:tour_guide_app/common_libs.dart';

class ProfileVerificationBadge extends StatelessWidget {
  final bool isVerified;

  const ProfileVerificationBadge({Key? key, required this.isVerified})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color:
                isVerified ? AppColors.primaryGreen : AppColors.secondaryGrey,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            isVerified
                ? AppLocalizations.of(context)!.verified
                : AppLocalizations.of(context)!.unverified,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
