import 'package:tour_guide_app/common_libs.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.avatarUrl,
    required this.fullName,
    required this.tier,
    required this.createdAt,
  });

  final String? avatarUrl;
  final String fullName;
  final String tier;
  final String createdAt;

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
              border: Border.all(color: AppColors.primaryBlue, width: 3),
            ),
            child: ClipOval(
              child: SizedBox(
                width: 96.r,
                height: 96.r,
                child:
                    avatarUrl != null &&
                            avatarUrl!.isNotEmpty &&
                            !avatarUrl!.contains('default_avatar.png')
                        ? Image.network(
                          avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) =>
                                  _buildFallbackAvatar(context, fullName),
                        )
                        : _buildFallbackAvatar(context, fullName),
              ),
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
                _ProfileTierBadge(tier: tier),
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
    final parsedDate = _parseCreatedAt(createdAt);
    if (parsedDate == null) {
      return AppLocalizations.of(context)!.memberForDays(0);
    }
    final days = DateTime.now().difference(parsedDate).inDays;
    return AppLocalizations.of(context)!.memberForDays(days);
  }

  DateTime? _parseCreatedAt(String dateStr) {
    // Try ISO 8601 format first
    var parsed = DateTime.tryParse(dateStr);
    if (parsed != null) return parsed;

    // Try DD-MM-YYYY HH:mm:ss format
    try {
      final parts = dateStr.split(' ');
      if (parts.length == 2) {
        final dateParts = parts[0].split('-');
        final timeParts = parts[1].split(':');

        if (dateParts.length == 3 && timeParts.length == 3) {
          final day = int.parse(dateParts[0]);
          final month = int.parse(dateParts[1]);
          final year = int.parse(dateParts[2]);
          final hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          final second = int.parse(timeParts[2]);

          return DateTime(year, month, day, hour, minute, second);
        }
      }
    } catch (e) {
      print('Error parsing date: $e');
    }

    return null;
  }

  Widget _buildFallbackAvatar(BuildContext context, String text) {
    return Container(
      color: AppColors.primaryBlue.withOpacity(0.2),
      alignment: Alignment.center,
      child: Text(
        text.isNotEmpty ? text[0].toUpperCase() : '?',
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
          color: AppColors.primaryBlue,
          fontSize: 40.sp,
        ),
      ),
    );
  }
}

class _ProfileTierBadge extends StatelessWidget {
  const _ProfileTierBadge({required this.tier});

  final String tier;

  @override
  Widget build(BuildContext context) {
    final config = _TierConfig.fromTier(context, tier);
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
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          SizedBox(width: 8.w),
          Text(
            config.label,
            style: textTheme.displayMedium?.copyWith(color: Colors.white),
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

  factory _TierConfig.fromTier(BuildContext context, String tier) {
    switch (tier) {
      case 'Bronze':
        return _TierConfig(
          backgroundColor: const Color(0xFFCD7F32),
          iconAsset: AppIcons.star,
          label: AppLocalizations.of(context)!.bronzeMember,
        );
      case 'Silver':
        return _TierConfig(
          backgroundColor: const Color(0xFFC0C0C0),
          iconAsset: AppIcons.star,
          label: AppLocalizations.of(context)!.silverMember,
        );
      case 'Gold':
        return _TierConfig(
          backgroundColor: const Color(0xFFFFD700),
          iconAsset: AppIcons.star,
          label: AppLocalizations.of(context)!.goldMember,
        );
      case 'Platinum':
        return _TierConfig(
          backgroundColor: const Color(0xFFE5E4E2),
          iconAsset: AppIcons.star,
          label: AppLocalizations.of(context)!.platinumMember,
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
