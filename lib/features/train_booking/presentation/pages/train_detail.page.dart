import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/train_booking/presentation/pages/train_booking_confirmation.page.dart';
import 'package:tour_guide_app/features/train_booking/presentation/widgets/train_seat_layout.widget.dart';

class TrainDetailPage extends StatefulWidget {
  final Map<String, dynamic> trainData;
  final String fromStation;
  final String toStation;
  final DateTime date;
  final int passengerCount;

  const TrainDetailPage({
    Key? key,
    required this.trainData,
    required this.fromStation,
    required this.toStation,
    required this.date,
    required this.passengerCount,
  }) : super(key: key);

  @override
  State<TrainDetailPage> createState() => _TrainDetailPageState();
}

class _TrainDetailPageState extends State<TrainDetailPage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> selectedSeats = [];
  String? selectedSeatClass;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Set default seat class to first available
    _setDefaultSeatClass();
  }

  void _setDefaultSeatClass() {
    final availableSeats = widget.trainData['availableSeats'] as Map<String, dynamic>;
    for (var entry in availableSeats.entries) {
      if (entry.value > 0) {
        selectedSeatClass = entry.key;
        break;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToConfirmation() {
    if (selectedSeats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng chọn chỗ'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
      return;
    }

    if (selectedSeatClass == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng chọn hạng chỗ'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
      return;
    }

    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => TrainBookingConfirmationPage(
          trainData: widget.trainData,
          fromStation: widget.fromStation,
          toStation: widget.toStation,
          date: widget.date,
          selectedSeats: selectedSeats,
          seatClass: selectedSeatClass!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'Chi tiết chuyến tàu',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Train Info Header
          _buildTrainInfoHeader(),

          // Tabs
          _buildTabs(),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSeatsTab(),
                _buildInfoTab(),
              ],
            ),
          ),

          // Bottom Bar with total and book button
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildTrainInfoHeader() {
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
                              widget.trainData['departureTime'],
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.primaryWhite,
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
                              height: 10.h,
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
                                borderRadius: BorderRadius.circular(10.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryWhite.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: AppColors.primaryBlue,
                                    size: 16.r,
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    widget.trainData['duration'],
                                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                          color: AppColors.primaryBlue,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              width: 2,
                              height: 10.h,
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
                            Text(
                              widget.trainData['arrivalTime'],
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.primaryWhite,
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
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: AppColors.primaryWhite,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primaryBlue,
        unselectedLabelColor: AppColors.textSubtitle,
        labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
        unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
        indicatorColor: AppColors.primaryBlue,
        indicatorWeight: 3,
        tabs: [
          Tab(text: 'Chọn chỗ'),
          Tab(text: 'Thông tin'),
        ],
      ),
    );
  }

  Widget _buildSeatsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Seat Class Selector
          Text(
            'Chọn hạng chỗ',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
          SizedBox(height: 12.h),
          _buildSeatClassSelector(),
          
          SizedBox(height: 20.h),
          
          // Seat Layout
          if (selectedSeatClass != null)
            TrainSeatLayoutWidget(
              seatClass: selectedSeatClass!,
              maxSeats: widget.passengerCount,
              onSeatsChanged: (seats) {
                setState(() => selectedSeats = seats);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSeatClassSelector() {
    final availableSeats = widget.trainData['availableSeats'] as Map<String, dynamic>;
    final prices = widget.trainData['prices'] as Map<String, dynamic>;

    return Column(
      children: availableSeats.keys.map((seatClass) {
        final isAvailable = availableSeats[seatClass] > 0;
        final isSelected = selectedSeatClass == seatClass;
        
        return GestureDetector(
          onTap: isAvailable ? () {
            setState(() {
              selectedSeatClass = seatClass;
              selectedSeats = []; // Reset selected seats when changing class
            });
          } : null,
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color:AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected 
                    ? AppColors.primaryBlue
                    : AppColors.textSubtitle.withOpacity(0.2),
                width: isSelected ? 2 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppColors.primaryBlue
                        : AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    seatClass.contains('Giường') 
                        ? Icons.bed_rounded 
                        : Icons.event_seat_rounded,
                    color: isSelected 
                        ? AppColors.primaryWhite
                        : AppColors.primaryBlue,
                    size: 24.r,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        seatClass,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        isAvailable 
                            ? '${availableSeats[seatClass]} chỗ trống'
                            : 'Hết chỗ',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: isAvailable 
                                  ? AppColors.primaryGreen
                                  : AppColors.primaryRed,
                            ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(prices[seatClass] as num).toStringAsFixed(0)}đ',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.primaryBlue,
                      ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            title: 'Thông tin chuyến tàu',
            items: [
              {'icon': Icons.train_rounded, 'label': 'Số hiệu', 'value': widget.trainData['trainNumber']},
              {'icon': Icons.category_rounded, 'label': 'Loại tàu', 'value': widget.trainData['trainType']},
              {'icon': Icons.access_time_rounded, 'label': 'Thời gian', 'value': widget.trainData['duration']},
              {'icon': Icons.route_rounded, 'label': 'Quãng đường', 'value': '1726 km'},
            ],
          ),

          SizedBox(height: 16.h),

          _buildInfoCard(
            title: 'Tiện nghi trên tàu',
            items: [
              {'icon': Icons.restaurant_rounded, 'label': 'Toa ăn uống', 'value': '✓'},
              {'icon': Icons.local_drink_outlined, 'label': 'Nước miễn phí', 'value': '✓'},
              {'icon': Icons.ac_unit_rounded, 'label': 'Điều hòa', 'value': '✓'},
              {'icon': Icons.power_rounded, 'label': 'Ổ cắm điện', 'value': '✓'},
              {'icon': Icons.wc_rounded, 'label': 'Nhà vệ sinh', 'value': '✓'},
            ],
          ),

          SizedBox(height: 16.h),

          _buildInfoCard(
            title: 'Chính sách',
            items: [
              {'icon': Icons.cancel_outlined, 'label': 'Hủy vé', 'value': 'Trước 24h: 80%'},
              {'icon': Icons.swap_horiz_rounded, 'label': 'Đổi vé', 'value': 'Phí 50.000đ'},
              {'icon': Icons.luggage_outlined, 'label': 'Hành lý', 'value': 'Tối đa 30kg'},
              {'icon': Icons.pets_rounded, 'label': 'Thú cưng', 'value': 'Không cho phép'},
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Map<String, dynamic>> items,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
          SizedBox(height: 12.h),
          ...items.map((item) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  Icon(
                    item['icon'],
                    size: 20.r,
                    color: AppColors.primaryBlue,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      item['label'],
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: AppColors.textSubtitle,
                          ),
                    ),
                  ),
                  Text(
                    item['value'],
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    if (selectedSeats.isEmpty || selectedSeatClass == null) {
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
          child: PrimaryButton(
            onPressed: () {},
            title: 'Chọn chỗ để tiếp tục',
            backgroundColor: AppColors.textSubtitle.withOpacity(0.3),
          ),
        ),
      );
    }

    final prices = widget.trainData['prices'] as Map<String, dynamic>;
    final pricePerSeat = prices[selectedSeatClass!] as num;
    final totalPrice = selectedSeats.length * pricePerSeat;

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
                    'Tổng tiền',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSubtitle,
                        ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${totalPrice.toStringAsFixed(0)}đ',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: PrimaryButton(
                onPressed: _navigateToConfirmation,
                title: 'Tiếp tục',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

