import 'package:tour_guide_app/common_libs.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.avatarUrl,
    required this.fullName,
    required this.tier,
    required this.createdAt,
    required this.isVietnamese,
  });

  final String avatarUrl;
  final String fullName;
  final String tier;
  final DateTime createdAt;
  final bool isVietnamese;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: 335.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.15),
            blurRadius: 8.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.25),
                  blurRadius: 16.r,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: AppColors.primaryBlue.withOpacity(0.2),
                width: 3,
              ),
            ),
            child: CircleAvatar(
              radius: 48.r,
              backgroundImage: NetworkImage(avatarUrl),
              onBackgroundImageError: (_, __) {},
            ),
          ),
          SizedBox(width: 18.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                _ProfileTierBadge(
                  tier: tier,
                  isVietnamese: isVietnamese,
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.calendar,
                      width: 16.w,
                      height: 16.h,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primaryBlue,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      _memberSinceText(context),
                      style: textTheme.displayMedium?.copyWith(
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _memberSinceText(BuildContext context) {
    final days = DateTime.now().difference(createdAt).inDays + 1;
    return isVietnamese ? 'Thành viên được $days ngày' : 'Member for $days days';
  }
}

class _ProfileTierBadge extends StatelessWidget {
  const _ProfileTierBadge({
    required this.tier,
    required this.isVietnamese,
  });

  final String tier;
  final bool isVietnamese;

  @override
  Widget build(BuildContext context) {
    final config = _TierConfig.fromTier(tier, isVietnamese);
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: config.backgroundColor.withOpacity(0.85),
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: config.backgroundColor.withOpacity(0.25),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            config.iconAsset,
            width: 16.w,
            height: 16.h,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            config.label,
            style: textTheme.displayMedium?.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _TierConfig {
  const _TierConfig({
    required this.backgroundColor,
    required this.iconAsset,
    required this.label,
  });

  final Color backgroundColor;
  final String iconAsset;
  final String label;

  factory _TierConfig.fromTier(String tier, bool isVietnamese) {
    switch (tier) {
      case 'Bronze':
        return _TierConfig(
          backgroundColor: const Color(0xFFCD7F32),
          iconAsset: AppIcons.star,
          label: isVietnamese ? 'Thành viên Đồng' : 'Bronze Member',
        );
      case 'Silver':
        return _TierConfig(
          backgroundColor: const Color(0xFFC0C0C0),
          iconAsset: AppIcons.star,
          label: isVietnamese ? 'Thành viên Bạc' : 'Silver Member',
        );
      case 'Gold':
        return _TierConfig(
          backgroundColor: const Color(0xFFFFD700),
          iconAsset: AppIcons.star,
          label: isVietnamese ? 'Thành viên Vàng' : 'Gold Member',
        );
      case 'Platinum':
        return _TierConfig(
          backgroundColor: const Color(0xFFE5E4E2),
          iconAsset: AppIcons.star,
          label: isVietnamese ? 'Thành viên Bạch Kim' : 'Platinum Member',
        );
      default:
        return _TierConfig(
          backgroundColor: AppColors.primaryBlue,
          iconAsset: AppIcons.user,
          label: tier,
        );
    }
  }
}

