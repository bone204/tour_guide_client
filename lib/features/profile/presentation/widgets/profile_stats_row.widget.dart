import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/constants/app_icon.constant.dart';

class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({
    super.key,
    required this.travelPoints,
    required this.reviews,
    required this.walletBalance,
  });

  final int travelPoints;
  final int reviews;
  final double walletBalance;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ProfileStatCard(
          title: AppLocalizations.of(context)!.travelPoints,
          value: travelPoints.toString(),
          iconAsset: AppIcons.travel,
          iconColor: AppColors.primaryYellow,
        ),
        _ProfileStatCard(
          title: AppLocalizations.of(context)!.reviews,
          value: reviews.toString(),
          iconAsset: AppIcons.star,
          iconColor: AppColors.primaryYellow,
        ),
        _ProfileStatCard(
          title: AppLocalizations.of(context)!.wallet,
          value: '${_formatWalletBalance(walletBalance)} ₫',
          iconAsset: AppIcons.gift,
          iconColor: AppColors.primaryYellow,
        ),
      ],
    );
  }

  String _formatWalletBalance(double balance) {
    if (balance >= 1_000_000_000) {
      final value = balance / 1_000_000_000;
      return value == value.toInt()
          ? '${value.toInt()}B'
          : '${value.toStringAsFixed(1)}B';
    } else if (balance >= 1_000_000) {
      final value = balance / 1_000_000;
      return value == value.toInt()
          ? '${value.toInt()}M'
          : '${value.toStringAsFixed(1)}M';
    } else if (balance >= 1_000) {
      final value = balance / 1_000;
      return value == value.toInt()
          ? '${value.toInt()}K'
          : '${value.toStringAsFixed(1)}K';
    }
    return balance.toInt().toString();
  }
}

class _ProfileStatCard extends StatelessWidget {
  const _ProfileStatCard({
    required this.title,
    required this.value,
    required this.iconAsset,
    required this.iconColor,
  });

  final String title;
  final String value;
  final String iconAsset;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: 104.w,
      height: 130.h,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryBlue, Color(0xFF0056b3)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.15),
            blurRadius: 8.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconAsset,
            width: 24.w,
            height: 24.h,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.primaryYellow,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: textTheme.bodySmall?.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
