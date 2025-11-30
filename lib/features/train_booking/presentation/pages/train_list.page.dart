import 'package:flutter_svg/svg.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/train_booking/presentation/pages/train_detail.page.dart';
import 'package:tour_guide_app/features/train_booking/presentation/widgets/train_card.widget.dart';

class TrainListPage extends StatefulWidget {
  final String fromStation;
  final String toStation;
  final DateTime date;
  final int passengerCount;
  final bool isRoundTrip;
  final DateTime? returnDate;

  const TrainListPage({
    Key? key,
    required this.fromStation,
    required this.toStation,
    required this.date,
    required this.passengerCount,
    this.isRoundTrip = false,
    this.returnDate,
  }) : super(key: key);

  @override
  State<TrainListPage> createState() => _TrainListPageState();
}

class _TrainListPageState extends State<TrainListPage> 
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  Map<String, dynamic>? selectedDepartureTrain;
  Map<String, dynamic>? selectedReturnTrain;

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
    final trains = _getAllTrains();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.selectTrainTrip,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Route Info Header
          _buildRouteHeader(),

          // Train List
          Expanded(
            child: trains.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.all(16.r),
                    itemCount: trains.length,
                    itemBuilder: (context, index) {
                      final train = trains[index];
                      return TrainCard(
                        trainNumber: train['trainNumber'],
                        trainType: train['trainType'],
                        departureTime: train['departureTime'],
                        arrivalTime: train['arrivalTime'],
                        duration: train['duration'],
                        availableSeats: Map<String, int>.from(train['availableSeats']),
                        prices: Map<String, double>.from(train['prices']),
                        rating: train['rating'],
                        onTap: () => _navigateToTrainDetail(train),
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
                      if (selectedDepartureTrain != null)
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
                      if (selectedReturnTrain != null)
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
                _buildTrainListTab(true), // Departure
                _buildTrainListTab(false), // Return
              ],
            ),
          ),

          // Bottom Bar for Round Trip
          if (selectedDepartureTrain != null && selectedReturnTrain != null)
            _buildRoundTripBottomBar(),
        ],
      ),
    );
  }

  Widget _buildTrainListTab(bool isDeparture) {
    final trains = _getAllTrains();

    return Column(
      children: [
        // Train List
        Expanded(
          child: trains.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: EdgeInsets.all(16.r),
                  itemCount: trains.length,
                  itemBuilder: (context, index) {
                    final train = trains[index];
                    final isSelected = isDeparture
                        ? (selectedDepartureTrain != null && selectedDepartureTrain!['id'] == train['id'])
                        : (selectedReturnTrain != null && selectedReturnTrain!['id'] == train['id']);

                    return TrainCard(
                      trainNumber: train['trainNumber'],
                      trainType: train['trainType'],
                      departureTime: train['departureTime'],
                      arrivalTime: train['arrivalTime'],
                      duration: train['duration'],
                      availableSeats: Map<String, int>.from(train['availableSeats']),
                      prices: Map<String, double>.from(train['prices']),
                      rating: train['rating'],
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          if (isDeparture) {
                            selectedDepartureTrain = train;
                          } else {
                            selectedReturnTrain = train;
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
    // Get cheapest price from each train
    final departurePrices = (selectedDepartureTrain!['prices'] as Map<String, dynamic>)
        .values.map((e) => (e as num).toDouble()).toList();
    final departurePrice = departurePrices.reduce((a, b) => a < b ? a : b);
    
    final returnPrices = (selectedReturnTrain!['prices'] as Map<String, dynamic>)
        .values.map((e) => (e as num).toDouble()).toList();
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.bothTripsSelected),
        behavior: SnackBarBehavior.floating,
      ),
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
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                      decoration: BoxDecoration(
                        color: widget.isRoundTrip 
                            ? AppColors.primaryOrange 
                            : AppColors.primaryWhite.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: widget.isRoundTrip ? [
                          BoxShadow(
                            color: AppColors.primaryOrange.withOpacity(0.4),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ] : null,
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
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppColors.primaryWhite,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
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
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppColors.primaryWhite,
                                ),
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
                      // From Station
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
                                      color: AppColors.primaryWhite.withOpacity(0.5),
                                      width: 2,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Ga đi',
                                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                        color: AppColors.primaryWhite.withOpacity(0.85),
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              widget.fromStation,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
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
                                    color: AppColors.primaryWhite.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                widget.isRoundTrip 
                                    ? Icons.swap_horiz_rounded 
                                    : Icons.train_rounded,
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

                      // To Station
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Ga đến',
                                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                        color: AppColors.primaryWhite.withOpacity(0.85),
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
                                      color: AppColors.primaryWhite.withOpacity(0.5),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              widget.toStation,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                      color: AppColors.primaryWhite.withOpacity(0.8),
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
            Icons.train_rounded,
            size: 80.r,
            color: AppColors.textSubtitle.withOpacity(0.3),
          ),
          SizedBox(height: 16.h),
          Text(
            'Không tìm thấy chuyến tàu',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textSubtitle,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Vui lòng thử lại với bộ lọc khác',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSubtitle,
                ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getAllTrains() {
    return [
      {
        'id': 'train_1',
        'trainNumber': 'SE1',
        'trainType': 'Thống Nhất',
        'departureTime': '06:00',
        'arrivalTime': '09:30',
        'duration': '32h 30m',
        'availableSeats': {
          'Ngồi cứng': 45,
          'Ngồi mềm': 20,
          'Giường nằm cứng': 15,
          'Giường nằm mềm': 8,
        },
        'prices': {
          'Ngồi cứng': 550000.0,
          'Ngồi mềm': 750000.0,
          'Giường nằm cứng': 950000.0,
          'Giường nằm mềm': 1200000.0,
        },
        'rating': 4.7,
      },
      {
        'id': 'train_2',
        'trainNumber': 'SE3',
        'trainType': 'Thống Nhất',
        'departureTime': '08:00',
        'arrivalTime': '16:30',
        'duration': '32h 30m',
        'availableSeats': {
          'Ngồi cứng': 30,
          'Ngồi mềm': 12,
          'Giường nằm cứng': 8,
          'Giường nằm mềm': 4,
        },
        'prices': {
          'Ngồi cứng': 550000.0,
          'Ngồi mềm': 750000.0,
          'Giường nằm cứng': 950000.0,
          'Giường nằm mềm': 1200000.0,
        },
        'rating': 4.6,
      },
      {
        'id': 'train_3',
        'trainNumber': 'SE5',
        'trainType': 'Thống Nhất',
        'departureTime': '13:00',
        'arrivalTime': '21:30',
        'duration': '32h 30m',
        'availableSeats': {
          'Ngồi cứng': 50,
          'Ngồi mềm': 25,
          'Giường nằm cứng': 20,
          'Giường nằm mềm': 12,
        },
        'prices': {
          'Ngồi cứng': 550000.0,
          'Ngồi mềm': 750000.0,
          'Giường nằm cứng': 950000.0,
          'Giường nằm mềm': 1200000.0,
        },
        'rating': 4.8,
      },
      {
        'id': 'train_4',
        'trainNumber': 'SE7',
        'trainType': 'Thống Nhất',
        'departureTime': '19:00',
        'arrivalTime': '03:30',
        'duration': '32h 30m',
        'availableSeats': {
          'Ngồi cứng': 25,
          'Ngồi mềm': 10,
          'Giường nằm cứng': 12,
          'Giường nằm mềm': 6,
        },
        'prices': {
          'Ngồi cứng': 550000.0,
          'Ngồi mềm': 750000.0,
          'Giường nằm cứng': 950000.0,
          'Giường nằm mềm': 1200000.0,
        },
        'rating': 4.5,
      },
      {
        'id': 'train_5',
        'trainNumber': 'SE21',
        'trainType': 'Thống Nhất Nhanh',
        'departureTime': '10:00',
        'arrivalTime': '18:00',
        'duration': '30h',
        'availableSeats': {
          'Ngồi cứng': 0,
          'Ngồi mềm': 18,
          'Giường nằm cứng': 15,
          'Giường nằm mềm': 10,
        },
        'prices': {
          'Ngồi cứng': 600000.0,
          'Ngồi mềm': 850000.0,
          'Giường nằm cứng': 1050000.0,
          'Giường nằm mềm': 1400000.0,
        },
        'rating': 4.9,
      },
    ];
  }

  void _navigateToTrainDetail(Map<String, dynamic> train) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => TrainDetailPage(
          trainData: train,
          fromStation: widget.fromStation,
          toStation: widget.toStation,
          date: widget.date,
          passengerCount: widget.passengerCount,
        ),
      ),
    );
  }
}

