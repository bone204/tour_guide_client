import 'package:flutter_svg/svg.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/flight_booking/presentation/pages/flight_detail.page.dart';
import 'package:tour_guide_app/features/flight_booking/presentation/widgets/flight_card.widget.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';

class FlightListPage extends StatefulWidget {
  final String fromAirport;
  final String toAirport;
  final DateTime date;
  final int passengerCount;
  final bool isRoundTrip;
  final DateTime? returnDate;

  const FlightListPage({
    Key? key,
    required this.fromAirport,
    required this.toAirport,
    required this.date,
    required this.passengerCount,
    this.isRoundTrip = false,
    this.returnDate,
  }) : super(key: key);

  @override
  State<FlightListPage> createState() => _FlightListPageState();
}

class _FlightListPageState extends State<FlightListPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  Map<String, dynamic>? selectedDepartureFlight;
  Map<String, dynamic>? selectedReturnFlight;

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
    final flights = _getAllFlights();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.selectFlightTrip,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Route Info Header
          _buildRouteHeader(),

          // Flight List
          Expanded(
            child:
                flights.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      padding: EdgeInsets.all(16.r),
                      itemCount: flights.length,
                      itemBuilder: (context, index) {
                        final flight = flights[index];
                        return FlightCard(
                          flightNumber: flight['flightNumber'],
                          airline: flight['airline'],
                          airlineLogo: flight['airlineLogo'],
                          departureTime: flight['departureTime'],
                          arrivalTime: flight['arrivalTime'],
                          duration: flight['duration'],
                          stops: flight['stops'],
                          availableSeats: Map<String, int>.from(
                            flight['availableSeats'],
                          ),
                          prices: Map<String, double>.from(flight['prices']),
                          rating: flight['rating'],
                          onTap: () => _navigateToFlightDetail(flight),
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
                      if (selectedDepartureFlight != null)
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
                      if (selectedReturnFlight != null)
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
                _buildFlightListTab(true), // Departure
                _buildFlightListTab(false), // Return
              ],
            ),
          ),

          // Bottom Bar for Round Trip
          if (selectedDepartureFlight != null && selectedReturnFlight != null)
            _buildRoundTripBottomBar(),
        ],
      ),
    );
  }

  Widget _buildFlightListTab(bool isDeparture) {
    final flights = _getAllFlights();

    return Column(
      children: [
        // Flight List
        Expanded(
          child:
              flights.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                    padding: EdgeInsets.all(16.r),
                    itemCount: flights.length,
                    itemBuilder: (context, index) {
                      final flight = flights[index];
                      final isSelected =
                          isDeparture
                              ? (selectedDepartureFlight != null &&
                                  selectedDepartureFlight!['id'] ==
                                      flight['id'])
                              : (selectedReturnFlight != null &&
                                  selectedReturnFlight!['id'] == flight['id']);

                      return FlightCard(
                        flightNumber: flight['flightNumber'],
                        airline: flight['airline'],
                        airlineLogo: flight['airlineLogo'],
                        departureTime: flight['departureTime'],
                        arrivalTime: flight['arrivalTime'],
                        duration: flight['duration'],
                        stops: flight['stops'],
                        availableSeats: Map<String, int>.from(
                          flight['availableSeats'],
                        ),
                        prices: Map<String, double>.from(flight['prices']),
                        rating: flight['rating'],
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            if (isDeparture) {
                              selectedDepartureFlight = flight;
                            } else {
                              selectedReturnFlight = flight;
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
    // Get cheapest price from each flight
    final departurePrices =
        (selectedDepartureFlight!['prices'] as Map<String, dynamic>).values
            .map((e) => (e as num).toDouble())
            .toList();
    final departurePrice = departurePrices.reduce((a, b) => a < b ? a : b);

    final returnPrices =
        (selectedReturnFlight!['prices'] as Map<String, dynamic>).values
            .map((e) => (e as num).toDouble())
            .toList();
    final returnPrice = returnPrices.reduce((a, b) => a < b ? a : b);

    final totalPrice = departurePrice + returnPrice;

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
                    'Tổng tiền (từ)',
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
                      // From Airport
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
                                  'Từ',
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
                              widget.fromAirport,
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
                                    : Icons.flight_rounded,
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

                      // To Airport
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Đến',
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
                              widget.toAirport,
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
            Icons.flight_rounded,
            size: 80.r,
            color: AppColors.textSubtitle.withOpacity(0.3),
          ),
          SizedBox(height: 16.h),
          Text(
            'Không tìm thấy chuyến bay',
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

  List<Map<String, dynamic>> _getAllFlights() {
    return [
      {
        'id': 'flight_1',
        'flightNumber': 'VN210',
        'airline': 'Vietnam Airlines',
        'airlineLogo': 'assets/airlines/vn.png',
        'departureTime': '06:00',
        'arrivalTime': '08:15',
        'duration': '2h 15m',
        'stops': 0,
        'availableSeats': {
          'Phổ thông': 45,
          'Phổ thông đặc biệt': 20,
          'Thương gia': 12,
        },
        'prices': {
          'Phổ thông': 1200000.0,
          'Phổ thông đặc biệt': 1800000.0,
          'Thương gia': 3500000.0,
        },
        'rating': 4.8,
      },
      {
        'id': 'flight_2',
        'flightNumber': 'VJ520',
        'airline': 'VietJet Air',
        'airlineLogo': 'assets/airlines/vj.png',
        'departureTime': '08:30',
        'arrivalTime': '10:45',
        'duration': '2h 15m',
        'stops': 0,
        'availableSeats': {
          'Phổ thông': 60,
          'Phổ thông đặc biệt': 30,
          'Thương gia': 0,
        },
        'prices': {
          'Phổ thông': 999000.0,
          'Phổ thông đặc biệt': 1499000.0,
          'Thương gia': 2999000.0,
        },
        'rating': 4.5,
      },
      {
        'id': 'flight_3',
        'flightNumber': 'BL350',
        'airline': 'Bamboo Airways',
        'airlineLogo': 'assets/airlines/bl.png',
        'departureTime': '10:00',
        'arrivalTime': '12:15',
        'duration': '2h 15m',
        'stops': 0,
        'availableSeats': {
          'Phổ thông': 50,
          'Phổ thông đặc biệt': 25,
          'Thương gia': 15,
        },
        'prices': {
          'Phổ thông': 1150000.0,
          'Phổ thông đặc biệt': 1750000.0,
          'Thương gia': 3200000.0,
        },
        'rating': 4.7,
      },
      {
        'id': 'flight_4',
        'flightNumber': 'VN212',
        'airline': 'Vietnam Airlines',
        'airlineLogo': 'assets/airlines/vn.png',
        'departureTime': '13:30',
        'arrivalTime': '15:45',
        'duration': '2h 15m',
        'stops': 0,
        'availableSeats': {
          'Phổ thông': 30,
          'Phổ thông đặc biệt': 15,
          'Thương gia': 8,
        },
        'prices': {
          'Phổ thông': 1250000.0,
          'Phổ thông đặc biệt': 1850000.0,
          'Thương gia': 3600000.0,
        },
        'rating': 4.8,
      },
      {
        'id': 'flight_5',
        'flightNumber': 'VJ522',
        'airline': 'VietJet Air',
        'airlineLogo': 'assets/airlines/vj.png',
        'departureTime': '16:00',
        'arrivalTime': '18:15',
        'duration': '2h 15m',
        'stops': 0,
        'availableSeats': {
          'Phổ thông': 55,
          'Phổ thông đặc biệt': 28,
          'Thương gia': 0,
        },
        'prices': {
          'Phổ thông': 1099000.0,
          'Phổ thông đặc biệt': 1599000.0,
          'Thương gia': 3099000.0,
        },
        'rating': 4.6,
      },
      {
        'id': 'flight_6',
        'flightNumber': 'BL352',
        'airline': 'Bamboo Airways',
        'airlineLogo': 'assets/airlines/bl.png',
        'departureTime': '19:00',
        'arrivalTime': '21:15',
        'duration': '2h 15m',
        'stops': 0,
        'availableSeats': {
          'Phổ thông': 40,
          'Phổ thông đặc biệt': 20,
          'Thương gia': 10,
        },
        'prices': {
          'Phổ thông': 1200000.0,
          'Phổ thông đặc biệt': 1800000.0,
          'Thương gia': 3300000.0,
        },
        'rating': 4.7,
      },
    ];
  }

  void _navigateToFlightDetail(Map<String, dynamic> flight) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder:
            (context) => FlightDetailPage(
              flightData: flight,
              fromAirport: widget.fromAirport,
              toAirport: widget.toAirport,
              date: widget.date,
              passengerCount: widget.passengerCount,
            ),
      ),
    );
  }
}
