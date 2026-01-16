// ignore_for_file: deprecated_member_use
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/button/like_button.dart';
import 'package:tour_guide_app/common/widgets/tab_item/about_tab.widget.dart';
import 'package:tour_guide_app/common/widgets/tab_item/reviews_tab.widget.dart';
import 'package:tour_guide_app/common/widgets/tab_item/photos_tab.widget.dart';
import 'package:tour_guide_app/features/destination/presentation/bloc/favorite_destination/favorite_destinations_cubit.dart';
import 'package:tour_guide_app/features/destination/presentation/bloc/favorite_destination/favorite_destinations_state.dart';
import 'package:tour_guide_app/features/destination/presentation/bloc/get_destination_by_id/get_destination_by_id_cubit.dart';
import 'package:tour_guide_app/features/destination/presentation/bloc/get_destination_by_id/get_destination_by_id_state.dart';

class DestinationDetailPage extends StatefulWidget {
  final int destinationId;

  const DestinationDetailPage({super.key, required this.destinationId});

  // Static method to create route with BlocProvider
  static Widget withProvider({
    required int destinationId,
    FavoriteDestinationsCubit? favoriteCubit,
  }) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GetDestinationByIdCubit()),
        if (favoriteCubit != null)
          BlocProvider.value(value: favoriteCubit)
        else
          BlocProvider(
            create: (_) => FavoriteDestinationsCubit()..loadFavorites(),
          ),
      ],
      child: DestinationDetailPage(destinationId: destinationId),
    );
  }

  @override
  State<DestinationDetailPage> createState() => _DestinationDetailPageState();
}

class _DestinationDetailPageState extends State<DestinationDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Load destination data when page opens
    context.read<GetDestinationByIdCubit>().getDestinationById(
      widget.destinationId,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final favoritesCubit = context.read<FavoriteDestinationsCubit>();
      if (!favoritesCubit.state.hasLoaded && !favoritesCubit.state.isLoading) {
        favoritesCubit.loadFavorites();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetDestinationByIdCubit, GetDestinationByIdState>(
      listener: (context, state) {
        if (state is GetDestinationByIdError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.primaryRed,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is GetDestinationByIdLoading) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            ),
          );
        }

        if (state is GetDestinationByIdError) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.r,
                    color: AppColors.primaryRed,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    AppLocalizations.of(context)!.failedToLoadDestination,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSubtitle,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<GetDestinationByIdCubit>()
                          .getDestinationById(widget.destinationId);
                    },
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is GetDestinationByIdLoaded) {
          final destination = state.destination;
          return Scaffold(
            body: Stack(
              children: [
                // 🔹 Header Image/Map Section
                _buildHeaderImage(destination.photos),

                // 🔹 Top App Bar (Back & Favorite)
                _buildTopAppBar(),

                // 🔹 Draggable Bottom Sheet - Nằm trên cùng để che phủ khi kéo lên
                _buildDraggableBottomSheet(destination),
              ],
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Center(
            child: Text(AppLocalizations.of(context)!.somethingWentWrong),
          ),
        );
      },
    );
  }

  Widget _buildHeaderImage(List<String>? photos) {
    final bool hasPhotos = photos != null && photos.isNotEmpty;

    return Positioned.fill(
      child: Hero(
        tag: 'destination_${widget.destinationId}',
        child:
            hasPhotos
                ? Image.network(
                  photos.first,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Nếu network image lỗi, fallback sang asset image
                    return Image.asset(
                      AppImage.defaultDestination,
                      fit: BoxFit.cover,
                    );
                  },
                )
                : Image.asset(AppImage.defaultDestination, fit: BoxFit.cover),
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
              // Back Button
              GestureDetector(
                onTap: () => Navigator.of(context, rootNavigator: true).pop(),
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: AppColors.primaryWhite.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
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

              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryWhite.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: BlocBuilder<
                  FavoriteDestinationsCubit,
                  FavoriteDestinationsState
                >(
                  builder: (context, favoriteState) {
                    final isFavorite = favoriteState.favoriteIds.contains(
                      widget.destinationId,
                    );
                    return CustomLikeButton(
                      size: 22.r,
                      isLiked: isFavorite,
                      likedColor: AppColors.primaryRed,
                      unlikedColor: AppColors.textSubtitle.withOpacity(0.6),
                      onTap: (bool liked) async {
                        final cubit = context.read<FavoriteDestinationsCubit>();
                        return await cubit.toggleFavorite(widget.destinationId);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDraggableBottomSheet(destination) {
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      snap: true,
      snapSizes: [0.5, 0.7, 0.95],
      snapAnimationDuration: Duration(milliseconds: 300),
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: Offset(0, -5),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag Handle
              _buildDragHandle(),

              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Info
                          _buildHeaderInfo(destination),

                          SizedBox(height: 20.h),

                          // Tabs
                          _buildTabs(),

                          SizedBox(height: 20.h),

                          // Tab Content
                          _buildTabContent(destination),
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

  Widget _buildHeaderInfo(destination) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        // Title
        Text(
          destination.name,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
        ),

        SizedBox(height: 12.h),

        // Location
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
                color: AppColors.primaryBlue,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                destination.specificAddress ??
                    destination.province ??
                    AppLocalizations.of(context)!.unknownLocation,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: AppColors.textSubtitle),
              ),
            ),
          ],
        ),

        // Rating (if available)
        if (destination.rating != null) ...[
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.star_rounded, color: Colors.amber, size: 20.r),
              SizedBox(width: 4.w),
              Text(
                destination.rating!.toStringAsFixed(1),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (destination.userRatingsTotal != null) ...[
                SizedBox(width: 4.w),
                Text(
                  AppLocalizations.of(
                    context,
                  )!.reviewsCount(destination.userRatingsTotal!),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSubtitle,
                  ),
                ),
              ],
            ],
          ),
        ],
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
          Tab(text: AppLocalizations.of(context)!.tabAbout),
          Tab(text: AppLocalizations.of(context)!.tabReviews),
          Tab(text: AppLocalizations.of(context)!.tabPhotos),
        ],
      ),
    );
  }

  Widget _buildTabContent(destination) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, child) {
        switch (_tabController.index) {
          case 0:
            final isVietnamese =
                Localizations.localeOf(context).languageCode == 'vi';
            final description =
                isVietnamese
                    ? (destination.descriptionViet ??
                        destination.descriptionEng ??
                        '')
                    : (destination.descriptionEng ??
                        destination.descriptionViet ??
                        '');
            return AboutTab(description: description);
          case 1:
            return ReviewsTab(destinationId: destination.id);
          case 2:
            return PhotosTab(
              photos: destination.photos,
              defaultImage: AppImage.defaultDestination,
            );
          default:
            final isVietnamese =
                Localizations.localeOf(context).languageCode == 'vi';
            final description =
                isVietnamese
                    ? (destination.descriptionViet ??
                        destination.descriptionEng ??
                        '')
                    : (destination.descriptionEng ??
                        destination.descriptionViet ??
                        '');
            return AboutTab(description: description);
        }
      },
    );
  }
}
