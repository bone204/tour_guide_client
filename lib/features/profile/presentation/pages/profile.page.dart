import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/events/app_events.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_cubit.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_state.dart';
import 'package:tour_guide_app/features/profile/presentation/pages/favourite_destinations.page.dart';
import 'package:tour_guide_app/features/profile/presentation/widgets/profile_feature_tile.widget.dart';
import 'package:tour_guide_app/features/profile/presentation/widgets/profile_header_card.widget.dart';
import 'package:tour_guide_app/features/profile/presentation/widgets/profile_stats_row.widget.dart';
import 'package:tour_guide_app/service_locator.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GetMyProfileCubit>()..getMyProfile(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  StreamSubscription? _profileUpdatedSubscription;

  @override
  void initState() {
    super.initState();
    _profileUpdatedSubscription = eventBus.on<ProfileUpdatedEvent>().listen((
      _,
    ) {
      if (mounted) {
        context.read<GetMyProfileCubit>().getMyProfile();
      }
    });
  }

  @override
  void dispose() {
    _profileUpdatedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final featureItems = _buildFeatureItems(context);

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
            child: BlocBuilder<GetMyProfileCubit, GetMyProfileState>(
              builder: (context, state) {
                if (state is GetMyProfileLoading) {
                  return _buildShimmerLoading(context);
                } else if (state is GetMyProfileSuccess) {
                  final user = state.user;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: ProfileHeaderCard(
                          avatarUrl: user.avatarUrl,
                          fullName: user.fullName ?? user.username,
                          tier: user.userTier,
                          createdAt: user.createdAt,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: ProfileStatsRow(
                          travelPoints: user.travelPoint,
                          reviews: user.feedbackTimes,
                          travelTrips: user.travelTrip,
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
                                if (index == 1) {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).push(
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              FavouriteDestinationsPage.withProvider(),
                                    ),
                                  );
                                } else if (index == 2) {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pushNamed(AppRouteConstant.myItinerary);
                                } else if (index == 0) {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pushNamed(AppRouteConstant.personalInfo);
                                } else if (index == 3) {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pushNamed(AppRouteConstant.rentalBillList);
                                }
                              },
                            );
                          },
                          separatorBuilder: (_, __) => SizedBox(height: 16.h),
                          itemCount: featureItems.length,
                        ),
                      ),
                    ],
                  );
                } else if (state is GetMyProfileFailure) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              height: 100.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                3,
                (index) => Container(
                  height: 60.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(height: 20.h, width: 150.w, color: Colors.white),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              itemBuilder:
                  (_, __) => Container(
                    height: 80.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemCount: 4,
            ),
          ),
        ],
      ),
    );
  }

  List<_ProfileFeatureItem> _buildFeatureItems(BuildContext context) {
    return [
      _ProfileFeatureItem(
        iconAsset: AppIcons.user,
        iconColor: AppColors.primaryOrange,
        title: AppLocalizations.of(context)!.personalInfo,
      ),
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
        iconAsset: AppIcons.policy,
        iconColor: AppColors.primaryGreen,
        title: AppLocalizations.of(context)!.myRentalBills,
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
