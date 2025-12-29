import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/button/like_button.dart';
import 'package:tour_guide_app/common/widgets/tab_item/about_tab.widget.dart';
import 'package:tour_guide_app/common/widgets/tab_item/photos_tab.widget.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/cooperation_detail/cooperation_detail_cubit.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/cooperation_detail/cooperation_detail_state.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/favorite_cooperations/favorite_cooperations_cubit.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/favorite_cooperations/favorite_cooperations_state.dart';
import 'package:tour_guide_app/features/cooperations/presentation/widgets/cooperation_reviews_tab.widget.dart';
import 'package:tour_guide_app/service_locator.dart';

class CooperationDetailPage extends StatefulWidget {
  final int id;

  const CooperationDetailPage({super.key, required this.id});

  // Static method to create route with BlocProvider
  static Widget withProvider({required int id}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  sl<CooperationDetailCubit>()..getCooperationDetail(id),
        ),
        BlocProvider(
          create: (context) => sl<FavoriteCooperationsCubit>()..loadFavorites(),
        ),
      ],
      child: CooperationDetailPage(id: id),
    );
  }

  @override
  State<CooperationDetailPage> createState() => _CooperationDetailPageState();
}

class _CooperationDetailPageState extends State<CooperationDetailPage>
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CooperationDetailCubit, CooperationDetailState>(
      listener: (context, state) {
        if (state is CooperationDetailError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.primaryRed,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is CooperationDetailLoading) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            ),
          );
        }

        if (state is CooperationDetailError) {
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
                    AppLocalizations.of(
                      context,
                    )!.failedToLoadDestination, 
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
                          .read<CooperationDetailCubit>()
                          .getCooperationDetail(widget.id);
                    },
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is CooperationDetailLoaded) {
          final cooperation = state.cooperation;
          return Scaffold(
            body: Stack(
              children: [
                // 🔹 Header Image
                _buildHeaderImage(cooperation.photo),

                // 🔹 Top App Bar (Back)
                _buildTopAppBar(),

                // 🔹 Draggable Bottom Sheet
                _buildDraggableBottomSheet(cooperation),
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

  Widget _buildHeaderImage(String? photo) {
    final bool hasPhoto = photo != null && photo.isNotEmpty;

    return Positioned.fill(
      child: Hero(
        tag: 'cooperation_${widget.id}',
        child:
            hasPhoto
                ? Image.network(
                  photo,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
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
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: AppColors.primaryWhite.withOpacity(0.9),
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

              // Favorite Button
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryWhite.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: BlocBuilder<
                  FavoriteCooperationsCubit,
                  FavoriteCooperationsState
                >(
                  builder: (context, state) {
                    final isLiked = state.favoriteIds.contains(widget.id);
                    return CustomLikeButton(
                      size: 22.r,
                      isLiked: isLiked,
                      likedColor: AppColors.primaryRed,
                      unlikedColor: AppColors.textSubtitle.withOpacity(0.6),
                      onTap: (bool liked) async {
                        return await context
                            .read<FavoriteCooperationsCubit>()
                            .toggleFavorite(widget.id);
                      },
                    );
                  },
                ),
              ),

              // Add Favorite button logic here if needed, similar to destination
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDraggableBottomSheet(cooperation) {
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
              // Drag Handle
              _buildDragHandle(),

              // Content
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
                          // Header Info
                          _buildHeaderInfo(cooperation),

                          SizedBox(height: 20.h),

                          // Tabs
                          _buildTabs(),

                          SizedBox(height: 20.h),

                          // Tab Content
                          _buildTabContent(cooperation),
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

  Widget _buildHeaderInfo(cooperation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        // Title
        Text(
          cooperation.name,
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
                cooperation.address ??
                    cooperation.province ??
                    AppLocalizations.of(context)!.unknownLocation,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: AppColors.textSubtitle),
              ),
            ),
          ],
        ),

        // Rating
        SizedBox(height: 12.h),
        Row(
          children: [
            Icon(Icons.star_rounded, color: Colors.amber, size: 20.r),
            SizedBox(width: 4.w),
            Text(
              cooperation.averageRating ?? "0",
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (cooperation.bookingTimes > 0) ...[
              SizedBox(width: 8.w),
              Container(
                width: 4.r,
                height: 4.r,
                decoration: BoxDecoration(
                  color: AppColors.textSubtitle,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                "${cooperation.bookingTimes} bookings",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSubtitle),
              ),
            ],
          ],
        ),

        // Additional Info (Boss info, etc)
        if (cooperation.bossName != null || cooperation.bossPhone != null) ...[
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.person, size: 16.r, color: AppColors.textSubtitle),
              SizedBox(width: 4.w),
              Text(
                "${cooperation.bossName ?? ''} ${cooperation.bossPhone != null ? '(${cooperation.bossPhone})' : ''}",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSubtitle),
              ),
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

  Widget _buildTabContent(cooperation) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, child) {
        switch (_tabController.index) {
          case 0:
            return AboutTab(description: cooperation.introduction ?? '');
          case 1:
            return CooperationReviewsTab(id: cooperation.id);
          case 2:
            return PhotosTab(
              photos: cooperation.photo != null ? [cooperation.photo!] : [],
              defaultImage: AppImage.defaultDestination,
            );
          default:
            return AboutTab(description: cooperation.introduction ?? '');
        }
      },
    );
  }
}
