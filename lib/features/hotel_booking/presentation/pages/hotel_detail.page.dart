import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/tab_item/about_tab.widget.dart';
import 'package:tour_guide_app/common/widgets/tab_item/reviews_tab.widget.dart';
import 'package:tour_guide_app/common/widgets/tab_item/photos_tab.widget.dart';
import 'package:tour_guide_app/common/widgets/tab_item/videos_tab.widget.dart';

class HotelDetailPage extends StatefulWidget {
  final String? imageUrl;
  final String? name;
  final String? location;
  final String? type;

  const HotelDetailPage({
    super.key,
    this.imageUrl,
    this.name,
    this.location,
    this.type,
  });

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  void _navigateToRoomList(BuildContext context) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(AppRouteConstant.hotelRoomList);
  }

  @override
  Widget build(BuildContext context) {
    final displayImageUrl = widget.imageUrl ?? AppImage.defaultCar;
    final displayName = widget.name ?? 'Khách sạn Continental';
    final displayLocation = widget.location ?? 'Quận 1, TP.HCM';
    final displayType = widget.type ?? 'Khách sạn 5 sao';

    return Scaffold(
      body: Stack(
        children: [
          _buildHeaderImage(displayImageUrl),
          _buildTopAppBar(),
          _buildDraggableBottomSheet(displayName, displayLocation, displayType, displayImageUrl),
        ],
      ),
    );
  }

  Widget _buildHeaderImage(String imageUrl) {
    return Positioned.fill(
      child: Hero(
        tag: 'hotel_${widget.name}',
        child: Image.asset(
          imageUrl,
          fit: BoxFit.cover,
        ),
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
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                },
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
                    _isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 20.r,
                    color: AppColors.primaryRed,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDraggableBottomSheet(String name, String location, String type, String imageUrl) {
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
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(32.r),
            ),
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
                          _buildTabContent(name, imageUrl),
                          SizedBox(height: 20.h),
                          PrimaryButton(
                            title: AppLocalizations.of(context)!.bookRoom,
                            onPressed: () => _navigateToRoomList(context),
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
        Text(
          name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 8.h),
        Text(
          type,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.textSubtitle,
          ),
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
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSubtitle,
                ),
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
        tabs: const [
          Tab(text: 'About'),
          Tab(text: 'Reviews'),
          Tab(text: 'Photos'),
          Tab(text: 'Videos'),
        ],
      ),
    );
  }

  Widget _buildTabContent(String name, String imageUrl) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, child) {
        switch (_tabController.index) {
          case 0:
            return AboutTab(name: name);
          case 1:
            return const ReviewsTab();
          case 2:
            return PhotosTab();
          case 3:
            return VideosTab();
          default:
            return AboutTab(name: name);
        }
      },
    );
  }
}

