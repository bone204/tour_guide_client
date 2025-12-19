import 'package:flutter_svg/svg.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/bus_booking/presentation/pages/bus_detail.page.dart';
import 'package:tour_guide_app/features/bus_booking/presentation/widgets/bus_card.widget.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';

class BusListPage extends StatefulWidget {
  final String fromLocation;
  final String toLocation;
  final DateTime date;
  final int passengerCount;
  final bool isRoundTrip;
  final DateTime? returnDate;

  const BusListPage({
    Key? key,
    required this.fromLocation,
    required this.toLocation,
    required this.date,
    required this.passengerCount,
    this.isRoundTrip = false,
    this.returnDate,
  }) : super(key: key);

  @override
  State<BusListPage> createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  Map<String, dynamic>? selectedDepartureBus;
  Map<String, dynamic>? selectedReturnBus;

  @override
  void initState() {
    super.initState();
    if (widget.isRoundTrip) {
      _tabController = TabController(length: 2, vsync: this);
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isRoundTrip) {
      return _buildRoundTripView();
    } else {
      return _buildOneWayView();
    }
  }

  Widget _buildOneWayView() {
    final buses = _getAllBuses();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.selectBusTrip,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Route Info Header
          _buildRouteHeader(),

          // Bus List
          Expanded(
            child:
                buses.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      padding: EdgeInsets.all(16.r),
                      itemCount: buses.length,
                      itemBuilder: (context, index) {
                        final bus = buses[index];
                        return BusCard(
                          busCompany: bus['company'],
                          busType: bus['type'],
                          departureTime: bus['departureTime'],
                          arrivalTime: bus['arrivalTime'],
                          duration: bus['duration'],
                          availableSeats: bus['availableSeats'],
                          price: bus['price'],
                          rating: bus['rating'],
                          amenities: List<String>.from(bus['amenities']),
                          onTap: () => _navigateToBusDetail(bus),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundTripView() {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.selectRoundTrip,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Route Info Header
          _buildRouteHeader(),

          // Tabs
          Container(
            color: AppColors.primaryWhite,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primaryBlue,
              unselectedLabelColor: AppColors.textSubtitle,
              labelStyle: Theme.of(context).textTheme.titleSmall,
              unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
              indicatorColor: AppColors.primaryBlue,
              indicatorWeight: 3,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.departureTrip),
                      if (selectedDepartureBus != null)
                        Container(
                          margin: EdgeInsets.only(left: 12.w),
                          padding: EdgeInsets.all(4.r),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            size: 12.r,
                            color: AppColors.primaryWhite,
                          ),
                        ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.returnTrip),
                      if (selectedReturnBus != null)
                        Container(
                          margin: EdgeInsets.only(left: 12.w),
                          padding: EdgeInsets.all(4.r),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            size: 12.r,
                            color: AppColors.primaryWhite,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBusListTab(true), // Departure
                _buildBusListTab(false), // Return
              ],
            ),
          ),

          // Bottom Bar for Round Trip
          if (selectedDepartureBus != null && selectedReturnBus != null)
            _buildRoundTripBottomBar(),
        ],
      ),
    );
  }

  Widget _buildBusListTab(bool isDeparture) {
    final buses = _getAllBuses();

    return Column(
      children: [
        // Bus List
        Expanded(
          child:
              buses.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                    padding: EdgeInsets.all(16.r),
                    itemCount: buses.length,
                    itemBuilder: (context, index) {
                      final bus = buses[index];
                      final isSelected =
                          isDeparture
                              ? (selectedDepartureBus != null &&
                                  selectedDepartureBus!['id'] == bus['id'])
                              : (selectedReturnBus != null &&
                                  selectedReturnBus!['id'] == bus['id']);

                      return BusCard(
                        busCompany: bus['company'],
                        busType: bus['type'],
                        departureTime: bus['departureTime'],
                        arrivalTime: bus['arrivalTime'],
                        duration: bus['duration'],
                        availableSeats: bus['availableSeats'],
                        price: bus['price'],
                        rating: bus['rating'],
                        amenities: List<String>.from(bus['amenities']),
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            if (isDeparture) {
                              selectedDepartureBus = bus;
                            } else {
                              selectedReturnBus = bus;
                            }
                          });
                        },
                      );
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildRoundTripBottomBar() {
    final totalPrice =
        (selectedDepartureBus!['price'] + selectedReturnBus!['price']) as num;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Tổng tiền (2 chuyến)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSubtitle,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${totalPrice.toStringAsFixed(0)}đ',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _navigateToRoundTripDetail(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Tiếp tục',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryWhite,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToRoundTripDetail() {
    // Navigate to confirmation with both trips
    CustomSnackbar.show(
      context,
      message: AppLocalizations.of(context)!.bothTripsSelected,
      type: SnackbarType.info,
    );
  }

  Widget _buildRouteHeader() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.r, 16.h, 16.r, 16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBlue,
            AppColors.primaryBlue.withOpacity(0.88),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.3),
            blurRadius: 6,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryWhite.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryWhite.withOpacity(0.08),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              children: [
                // Trip Type & Passenger Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 7.h,
                      ),
                      decoration: BoxDecoration(
                        color:
                            widget.isRoundTrip
                                ? AppColors.primaryOrange
                                : AppColors.primaryWhite.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow:
                            widget.isRoundTrip
                                ? [
                                  BoxShadow(
                                    color: AppColors.primaryOrange.withOpacity(
                                      0.4,
                                    ),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ]
                                : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.isRoundTrip
                                ? Icons.repeat_rounded
                                : Icons.arrow_forward_rounded,
                            size: 16.r,
                            color: AppColors.primaryWhite,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            widget.isRoundTrip ? 'Khứ hồi' : 'Một chiều',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(color: AppColors.primaryWhite),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 7.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryWhite.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppIcons.user,
                            width: 16.r,
                            height: 16.r,
                            color: AppColors.primaryWhite,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            '${widget.passengerCount} người',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(color: AppColors.primaryWhite),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // Route Section
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // From Location
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 10.w,
                                  height: 10.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryWhite,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.primaryWhite.withOpacity(
                                        0.5,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Điểm đi',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displayLarge?.copyWith(
                                    color: AppColors.primaryWhite.withOpacity(
                                      0.85,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              widget.fromLocation,
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                color: AppColors.primaryWhite,
                                fontWeight: FontWeight.w800,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              '${widget.date.day} Th${widget.date.month}, ${widget.date.year}',
                              style: Theme.of(
                                context,
                              ).textTheme.displayMedium?.copyWith(
                                color: AppColors.primaryWhite.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Middle Connector
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 2,
                              height: 30.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColors.primaryWhite.withOpacity(0.3),
                                    AppColors.primaryWhite.withOpacity(0.1),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              padding: EdgeInsets.all(10.r),
                              decoration: BoxDecoration(
                                color: AppColors.primaryWhite,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryWhite.withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                widget.isRoundTrip
                                    ? Icons.swap_horiz_rounded
                                    : Icons.arrow_forward_rounded,
                                color: AppColors.primaryBlue,
                                size: 20.r,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              width: 2,
                              height: 30.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColors.primaryWhite.withOpacity(0.1),
                                    AppColors.primaryWhite.withOpacity(0.3),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // To Location
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Điểm đến',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displayLarge?.copyWith(
                                    color: AppColors.primaryWhite.withOpacity(
                                      0.85,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  width: 10.w,
                                  height: 10.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryOrange,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.primaryWhite.withOpacity(
                                        0.5,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              widget.toLocation,
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                color: AppColors.primaryWhite,
                                fontWeight: FontWeight.w800,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(height: 8.h),
                            if (widget.isRoundTrip && widget.returnDate != null)
                              Text(
                                '${widget.returnDate!.day} Th${widget.returnDate!.month}, ${widget.returnDate!.year}',
                                style: Theme.of(
                                  context,
                                ).textTheme.displayMedium?.copyWith(
                                  color: AppColors.primaryWhite.withOpacity(
                                    0.8,
                                  ),
                                ),
                              )
                            else
                              SizedBox(height: 14.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_bus_rounded,
            size: 80.r,
            color: AppColors.textSubtitle.withOpacity(0.3),
          ),
          SizedBox(height: 16.h),
          Text(
            'Không tìm thấy chuyến xe',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.textSubtitle),
          ),
          SizedBox(height: 8.h),
          Text(
            'Vui lòng thử lại với bộ lọc khác',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSubtitle),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getAllBuses() {
    return [
      {
        'id': 'bus_1',
        'company': 'Phương Trang (FUTA)',
        'type': 'Giường nằm VIP 40 chỗ',
        'departureTime': '06:00',
        'arrivalTime': '12:30',
        'duration': '6h 30m',
        'availableSeats': 12,
        'price': 250000.0,
        'rating': 4.8,
        'amenities': ['WiFi', 'Nước uống', 'Khăn lạnh', 'TV'],
        'timeCategory': 'morning',
      },
      {
        'id': 'bus_2',
        'company': 'Thành Bưởi',
        'type': 'Ghế ngồi 45 chỗ',
        'departureTime': '08:30',
        'arrivalTime': '15:00',
        'duration': '6h 30m',
        'availableSeats': 8,
        'price': 180000.0,
        'rating': 4.5,
        'amenities': ['WiFi', 'Nước uống'],
        'timeCategory': 'morning',
      },
      {
        'id': 'bus_3',
        'company': 'Hoàng Long',
        'type': 'Giường nằm Limousine 22 chỗ',
        'departureTime': '13:00',
        'arrivalTime': '19:30',
        'duration': '6h 30m',
        'availableSeats': 15,
        'price': 320000.0,
        'rating': 4.9,
        'amenities': ['WiFi', 'Nước uống', 'Khăn lạnh', 'TV', 'Massage'],
        'timeCategory': 'afternoon',
      },
      {
        'id': 'bus_4',
        'company': 'Mai Linh Express',
        'type': 'Ghế ngồi 40 chỗ',
        'departureTime': '15:30',
        'arrivalTime': '22:00',
        'duration': '6h 30m',
        'availableSeats': 20,
        'price': 200000.0,
        'rating': 4.6,
        'amenities': ['WiFi', 'Nước uống', 'TV'],
        'timeCategory': 'afternoon',
      },
      {
        'id': 'bus_5',
        'company': 'Phương Trang (FUTA)',
        'type': 'Giường nằm VIP 40 chỗ',
        'departureTime': '20:00',
        'arrivalTime': '02:30',
        'duration': '6h 30m',
        'availableSeats': 18,
        'price': 270000.0,
        'rating': 4.8,
        'amenities': ['WiFi', 'Nước uống', 'Khăn lạnh', 'TV', 'Chăn'],
        'timeCategory': 'evening',
      },
      {
        'id': 'bus_6',
        'company': 'Kumho Samco',
        'type': 'Giường nằm cao cấp 34 chỗ',
        'departureTime': '22:00',
        'arrivalTime': '04:30',
        'duration': '6h 30m',
        'availableSeats': 6,
        'price': 300000.0,
        'rating': 4.7,
        'amenities': ['WiFi', 'Nước uống', 'Khăn lạnh', 'TV', 'Chăn'],
        'timeCategory': 'evening',
      },
    ];
  }

  void _navigateToBusDetail(Map<String, dynamic> bus) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder:
            (context) => BusDetailPage(
              busData: bus,
              fromLocation: widget.fromLocation,
              toLocation: widget.toLocation,
              date: widget.date,
              passengerCount: widget.passengerCount,
            ),
      ),
    );
  }
}
