import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/tab_item/about_tab.widget.dart';
import 'package:tour_guide_app/common/widgets/tab_item/photos_tab.widget.dart';
import 'package:tour_guide_app/common/widgets/tab_item/reviews_tab.widget.dart';

import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/common/widgets/button/like_button.dart';

import 'package:tour_guide_app/features/cooperations/presentation/bloc/favorite_cooperations/favorite_cooperations_cubit.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/favorite_cooperations/favorite_cooperations_state.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_search_response.dart';

class RestaurantDetailPage extends StatefulWidget {
  final RestaurantSearchResponse restaurant;
  final DateTime? reservationTime;
  final int? numberOfGuests;

  const RestaurantDetailPage({
    super.key,
    required this.restaurant,
    this.reservationTime,
    this.numberOfGuests,
  });

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  void _navigateToTableSelection(BuildContext context) {
    // Navigate to page to select tables for this restaurant
    Navigator.of(context, rootNavigator: true).pushNamed(
      AppRouteConstant.restaurantTableSelection,
      arguments: {
        'restaurant': widget.restaurant,
        'reservationTime': widget.reservationTime,
        'numberOfGuests': widget.numberOfGuests,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<FavoriteCooperationsCubit>()..loadFavorites(),
        ),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            _buildHeaderImage(),
            _buildTopAppBar(),
            _buildDraggableBottomSheet(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Positioned.fill(
      child: Hero(
        tag: 'restaurant_${widget.restaurant.id}',
        child:
            (widget.restaurant.photo != null &&
                    widget.restaurant.photo!.isNotEmpty)
                ? Image.network(
                  widget.restaurant.photo!,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          Image.asset(AppImage.defaultFood, fit: BoxFit.cover),
                )
                : Image.asset(AppImage.defaultFood, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context, rootNavigator: true).pop(),
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: AppColors.primaryWhite,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 20.r,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              _buildFavoriteButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BlocBuilder<FavoriteCooperationsCubit, FavoriteCooperationsState>(
        builder: (context, state) {
          final isFavorite = state.favoriteIds.contains(widget.restaurant.id);

          return CustomLikeButton(
            size: 22.r,
            isLiked: isFavorite,
            likedColor: AppColors.primaryRed,
            unlikedColor: AppColors.textSubtitle.withOpacity(0.6),
            onTap: (isLiked) async {
              await context.read<FavoriteCooperationsCubit>().toggleFavorite(
                widget.restaurant.id,
              );
              return !isLiked;
            },
          );
        },
      ),
    );
  }

  Widget _buildDraggableBottomSheet() {
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      snap: true,
      snapSizes: const [0.5, 0.7, 0.95],
      snapAnimationDuration: const Duration(milliseconds: 300),
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, -5),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              _buildDragHandle(),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeaderInfo(),
                          SizedBox(height: 20.h),
                          _buildTabs(),
                          SizedBox(height: 20.h),
                          _buildTabContent(),
                          SizedBox(height: 20.h),
                          PrimaryButton(
                            title: AppLocalizations.of(context)!.bookTable,
                            onPressed: () => _navigateToTableSelection(context),
                            backgroundColor: AppColors.primaryBlue,
                            textColor: AppColors.textSecondary,
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
      width: 40.w,
      height: 5.h,
      decoration: BoxDecoration(
        color: AppColors.textSubtitle.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    // Fallback logic for cuisine if needed, similar to card
    String cuisineText = "";
    if (widget.restaurant.restaurantTables.isNotEmpty &&
        widget.restaurant.restaurantTables.first.dishType != null) {
      cuisineText = widget.restaurant.restaurantTables.first.dishType!;
    } else {
      cuisineText = AppLocalizations.of(context)!.foodTypeVietnamese;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Text(
          widget.restaurant.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 8.h),
        Text(
          cuisineText,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: AppColors.textSubtitle),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: SvgPicture.asset(
                AppIcons.location,
                width: 16.w,
                height: 16.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.primaryBlue,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                "${widget.restaurant.province}",
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: AppColors.textSubtitle),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColors.textSubtitle.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TabBar(
        controller: _tabController,
        padding: EdgeInsets.all(4.r),
        indicator: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(8.r),
        ),
        labelColor: AppColors.primaryWhite,
        unselectedLabelColor: AppColors.textSubtitle,
        labelStyle: Theme.of(context).textTheme.displayMedium,
        unselectedLabelStyle: Theme.of(context).textTheme.displayMedium,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(text: AppLocalizations.of(context)!.aboutTab),
          Tab(text: AppLocalizations.of(context)!.reviewsTab),
          Tab(text: AppLocalizations.of(context)!.photosTab),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, child) {
        switch (_tabController.index) {
          case 0:
            return AboutTab(
              description:
                  widget.restaurant.introduction ??
                  AppLocalizations.of(
                    context,
                  )!.restaurantDescriptionFallback(widget.restaurant.name),
            );
          case 1:
            return const ReviewsTab();
          case 2:
            return PhotosTab(
              photos:
                  widget.restaurant.photo != null &&
                          widget.restaurant.photo!.isNotEmpty
                      ? [widget.restaurant.photo!]
                      : [],
            );
          default:
            return AboutTab(
              description:
                  widget.restaurant.introduction ??
                  AppLocalizations.of(
                    context,
                  )!.restaurantDescriptionFallback(widget.restaurant.name),
            );
        }
      },
    );
  }
}
