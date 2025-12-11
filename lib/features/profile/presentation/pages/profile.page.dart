import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/profile/presentation/pages/favourite_destinations.page.dart';
import 'package:tour_guide_app/features/profile/presentation/widgets/profile_feature_tile.widget.dart';
import 'package:tour_guide_app/features/profile/presentation/widgets/profile_header_card.widget.dart';
import 'package:tour_guide_app/features/profile/presentation/widgets/profile_stats_row.widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final featureItems = _buildFeatureItems(context);

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
                  colors: [Color(0xFF66B2FF), Color(0xFF007BFF)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: ProfileHeaderCard(
                    avatarUrl: avatarUrl,
                    fullName: fullName,
                    tier: tier,
                    createdAt: createdAt,
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: ProfileStatsRow(
                    travelPoints: travelPoints,
                    reviews: reviews,
                    walletBalance: walletBalance,
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    AppLocalizations.of(context)!.memberFeatures,
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
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
                                builder:
                                    (context) =>
                                        FavouriteDestinationsPage.withProvider(),
                              ),
                            );
                          } else if (index == 1) {
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pushNamed(AppRouteConstant.myItinerary);
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
        ],
      ),
    );
  }

  List<_ProfileFeatureItem> _buildFeatureItems(BuildContext context) {
    return [
      _ProfileFeatureItem(
        iconAsset: AppIcons.location,
        iconColor: AppColors.primaryBlue,
        title: AppLocalizations.of(context)!.favouriteDestinations,
      ),
      _ProfileFeatureItem(
        iconAsset: AppIcons.calendar,
        iconColor: AppColors.primaryPurple,
        title: AppLocalizations.of(context)!.myItinerary,
      ),
      _ProfileFeatureItem(
        iconAsset: AppIcons.clock,
        iconColor: AppColors.primaryOrange,
        title: AppLocalizations.of(context)!.travelHistory,
      ),
      _ProfileFeatureItem(
        iconAsset: AppIcons.gift,
        iconColor: AppColors.primaryGreen,
        title: AppLocalizations.of(context)!.myWallet,
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
