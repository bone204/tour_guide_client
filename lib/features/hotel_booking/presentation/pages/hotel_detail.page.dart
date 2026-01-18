import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel.dart';
import 'package:tour_guide_app/common/widgets/tab_item/about_tab.widget.dart';
import 'package:tour_guide_app/common/widgets/tab_item/reviews_tab.widget.dart';
import 'package:tour_guide_app/common/widgets/tab_item/photos_tab.widget.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/room.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel_room_search_request.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/button/like_button.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/favorite_cooperations/favorite_cooperations_cubit.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/favorite_cooperations/favorite_cooperations_state.dart';

class HotelDetailPage extends StatefulWidget {
  final Hotel? hotel;
  final List<HotelRoom>? rooms;
  final HotelRoomSearchRequest? request;

  const HotelDetailPage({super.key, this.hotel, this.rooms, this.request});

  static Widget withProvider({
    Hotel? hotel,
    List<HotelRoom>? rooms,
    HotelRoomSearchRequest? request,
  }) {
    return BlocProvider(
      create: (context) => sl<FavoriteCooperationsCubit>()..loadFavorites(),
      child: HotelDetailPage(hotel: hotel, rooms: rooms, request: request),
    );
  }

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage>
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

  void _navigateToRoomList(BuildContext context) {
    if (widget.hotel != null) {
      Navigator.of(context, rootNavigator: true).pushNamed(
        AppRouteConstant.hotelRoomList,
        arguments: {
          'request': widget.request,
          'rooms': widget.rooms,
          'hotel': widget.hotel,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hotel = widget.hotel;
    final localizations = AppLocalizations.of(context)!;
    final displayName = hotel?.name ?? localizations.continentalHotel;
    final displayLocation = hotel?.province ?? localizations.district1Hcm;
    final displayType = localizations.hotelNearbyDes;
    final displayImageUrl = hotel?.photo ?? AppImage.defaultHotel;

    return Scaffold(
      body: Stack(
        children: [
          _buildHeaderImage(displayImageUrl, hotel),
          _buildTopAppBar(hotel),
          _buildDraggableBottomSheet(
            displayName,
            displayLocation,
            displayType,
            displayImageUrl,
            hotel,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage(String? imageUrl, Hotel? hotel) {
    if (imageUrl == null) return const SizedBox();
    return Positioned.fill(
      child: Hero(
        tag: 'hotel_${hotel?.id ?? "default"}',
        child:
            imageUrl.startsWith('http')
                ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      AppImage.defaultHotel,
                      fit: BoxFit.cover,
                    );
                  },
                )
                : Image.asset(imageUrl, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildTopAppBar(Hotel? hotel) {
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
              if (hotel != null)
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
                      final isLiked = state.favoriteIds.contains(hotel.id);
                      return CustomLikeButton(
                        size: 22.r,
                        isLiked: isLiked,
                        likedColor: AppColors.primaryRed,
                        unlikedColor: AppColors.textSubtitle.withOpacity(0.6),
                        onTap: (bool liked) async {
                          return await context
                              .read<FavoriteCooperationsCubit>()
                              .toggleFavorite(hotel.id);
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

  Widget _buildDraggableBottomSheet(
    String name,
    String location,
    String type,
    String imageUrl,
    Hotel? hotel,
  ) {
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
                          _buildHeaderInfo(name, location, type),
                          SizedBox(height: 20.h),
                          _buildTabs(),
                          SizedBox(height: 20.h),
                          _buildTabContent(name, imageUrl, hotel),
                          SizedBox(height: 20.h),
                          PrimaryButton(
                            title: AppLocalizations.of(context)!.bookRoom,
                            onPressed: () {
                              if (hotel != null) {
                                _navigateToRoomList(context);
                              }
                            },
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

  Widget _buildHeaderInfo(String name, String location, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Text(name, style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: 8.h),
        Text(
          type,
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
                location,
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

  Widget _buildTabContent(String name, String imageUrl, Hotel? hotel) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, child) {
        switch (_tabController.index) {
          case 0:
            return AboutTab(
              description:
                  hotel?.introduction ??
                  'Discover the beauty of $name. This stunning destination offers breathtaking views, rich cultural experiences, and unforgettable memories. Perfect for travelers seeking adventure and relaxation.\n\nWhether you\'re exploring historic landmarks, enjoying local cuisine, or simply taking in the scenery, this location has something special for everyone.\n\nThe destination is known for its unique charm and exceptional experiences that leave lasting impressions on every visitor. From morning till evening, there are countless activities and sights to explore.',
            );
          case 1:
            return ReviewsTab(hotelId: hotel?.id);
          case 2:
            return PhotosTab(
              photos:
                  hotel?.photo != null && hotel!.photo!.isNotEmpty
                      ? [hotel.photo!]
                      : [],
            );
          default:
            return AboutTab(
              description:
                  hotel?.introduction ??
                  'Discover the beauty of $name. This stunning destination offers breathtaking views, rich cultural experiences, and unforgettable memories. Perfect for travelers seeking adventure and relaxation.\n\nWhether you\'re exploring historic landmarks, enjoying local cuisine, or simply taking in the scenery, this location has something special for everyone.\n\nThe destination is known for its unique charm and exceptional experiences that leave lasting impressions on every visitor. From morning till evening, there are countless activities and sights to explore.',
            );
        }
      },
    );
  }
}
