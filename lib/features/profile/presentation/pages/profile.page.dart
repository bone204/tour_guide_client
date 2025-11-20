import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/profile/presentation/pages/favourite_destinations.page.dart';
import 'package:tour_guide_app/features/profile/presentation/widgets/profile_feature_tile.widget.dart';
import 'package:tour_guide_app/features/profile/presentation/widgets/profile_header_card.widget.dart';
import 'package:tour_guide_app/features/profile/presentation/widgets/profile_stats_row.widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final isVietnamese = localeCode == 'vi';
    final textTheme = Theme.of(context).textTheme;
    final featureItems = _buildFeatureItems(isVietnamese);

    const String avatarUrl =
        'https://images.unsplash.com/photo-1527980965255-d3b416303d12?auto=format&fit=crop&w=200&q=60';
    const String fullName = 'Nguyễn Văn A';
    const String tier = 'Gold';
    final DateTime createdAt = DateTime(2023, 5, 12);

    const int travelPoints = 1280;
    const int reviews = 24;
    const double walletBalance = 1_585_000;

    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 160.h,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF66B2FF),
                    Color(0xFF007BFF),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileHeaderCard(
                      avatarUrl: avatarUrl,
                      fullName: fullName,
                      tier: tier,
                      createdAt: createdAt,
                      isVietnamese: isVietnamese,
                    ),
                    SizedBox(height: 20.h),
                    ProfileStatsRow(
                      travelPoints: travelPoints,
                      reviews: reviews,
                      walletBalance: walletBalance,
                      isVietnamese: isVietnamese,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      isVietnamese ? 'Tính năng hội viên' : 'Member Features',
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (_, index) {
                          final item = featureItems[index];
                          return ProfileFeatureTile(
                            iconAsset: item.iconAsset,
                            iconColor: item.iconColor,
                            title: item.title,
                            onTap: () {
                              if (index == 0) {
                                // Navigate to favourite destinations
                                Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                    builder: (context) => FavouriteDestinationsPage.withProvider(),
                                  ),
                                );
                              }
                            },
                          );
                        },
                        separatorBuilder: (_, __) => SizedBox(height: 16.h),
                        itemCount: featureItems.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<_ProfileFeatureItem> _buildFeatureItems(bool isVietnamese) {
    return [
      _ProfileFeatureItem(
        iconAsset: AppIcons.location,
        iconColor: AppColors.primaryBlue,
        title: isVietnamese ? 'Điểm yêu thích' : 'Favourite Destinations',
      ),
      _ProfileFeatureItem(
        iconAsset: AppIcons.clock,
        iconColor: AppColors.primaryOrange,
        title: isVietnamese ? 'Lịch sử chuyến đi' : 'Travel History',
      ),
      _ProfileFeatureItem(
        iconAsset: AppIcons.gift,
        iconColor: AppColors.primaryGreen,
        title: isVietnamese ? 'Ví của tôi' : 'My Wallet',
      ),
    ];
  }
}

class _ProfileFeatureItem {
  const _ProfileFeatureItem({
    required this.iconAsset,
    required this.iconColor,
    required this.title,
  });

  final String iconAsset;
  final Color iconColor;
  final String title;
}
