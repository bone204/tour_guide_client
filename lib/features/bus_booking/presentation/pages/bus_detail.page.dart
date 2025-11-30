import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/bus_booking/presentation/pages/bus_booking_confirmation.page.dart';
import 'package:tour_guide_app/features/bus_booking/presentation/widgets/seat_layout.widget.dart';

class BusDetailPage extends StatefulWidget {
  final Map<String, dynamic> busData;
  final String fromLocation;
  final String toLocation;
  final DateTime date;
  final int passengerCount;

  const BusDetailPage({
    Key? key,
    required this.busData,
    required this.fromLocation,
    required this.toLocation,
    required this.date,
    required this.passengerCount,
  }) : super(key: key);

  @override
  State<BusDetailPage> createState() => _BusDetailPageState();
}

class _BusDetailPageState extends State<BusDetailPage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<int> selectedSeats = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          content: Text(AppLocalizations.of(context)!.pleaseSelectSeatBus),
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
        builder: (context) => BusBookingConfirmationPage(
          busData: widget.busData,
          fromLocation: widget.fromLocation,
          toLocation: widget.toLocation,
          date: widget.date,
          selectedSeats: selectedSeats,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.busTripDetails,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Bus Info Header
          _buildBusInfoHeader(),

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

  Widget _buildBusInfoHeader() {
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
                // Company & Rating Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: AppColors.primaryWhite,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: SvgPicture.asset(
                        AppIcons.bus,
                        width: 24.w,
                        height: 24.h,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.busData['company'],
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.primaryWhite,
                                ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            widget.busData['type'],
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: AppColors.primaryWhite.withOpacity(0.85),
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
                                      color: AppColors.primaryWhite.withOpacity(0.5),
                                      width: 2,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Điểm đi',
                                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                        color: AppColors.primaryWhite.withOpacity(0.85),
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              widget.fromLocation,
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
                              widget.busData['departureTime'],
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
                                    widget.busData['duration'],
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
                              widget.toLocation,
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
                              widget.busData['arrivalTime'],
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
          Tab(text: 'Chọn ghế'),
          Tab(text: 'Thông tin'),
        ],
      ),
    );
  }

  Widget _buildSeatsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: SeatLayoutWidget(
        busType: widget.busData['type'],
        maxSeats: widget.passengerCount,
        onSeatsChanged: (seats) {
          setState(() => selectedSeats = seats);
        },
      ),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            title: AppLocalizations.of(context)!.busTripInfo,
            items: [
              {'icon': Icons.location_on_outlined, 'label': 'Điểm đón', 'value': 'Bến xe Miền Đông'},
              {'icon': Icons.flag_outlined, 'label': 'Điểm trả', 'value': 'Bến xe Đà Lạt'},
              {'icon': Icons.access_time_rounded, 'label': 'Thời gian', 'value': widget.busData['duration']},
              {'icon': Icons.route_rounded, 'label': 'Quãng đường', 'value': '308 km'},
            ],
          ),

          SizedBox(height: 16.h),

          _buildInfoCard(
            title: AppLocalizations.of(context)!.amenities,
            items: (widget.busData['amenities'] as List).map((amenity) {
              return {
                'icon': _getAmenityIcon(amenity),
                'label': amenity,
                'value': '✓',
              };
            }).toList(),
          ),

          SizedBox(height: 16.h),

          _buildInfoCard(
            title: AppLocalizations.of(context)!.policy,
            items: [
              {'icon': Icons.cancel_outlined, 'label': 'Hủy vé', 'value': 'Miễn phí trước 24h'},
              {'icon': Icons.swap_horiz_rounded, 'label': 'Đổi vé', 'value': 'Phí 20.000đ'},
              {'icon': Icons.luggage_outlined, 'label': 'Hành lý', 'value': 'Tối đa 20kg'},
            ],
          ),
        ],
      ),
    );
  }

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'wifi':
        return Icons.wifi;
      case 'nước uống':
        return Icons.local_drink_outlined;
      case 'tv':
        return Icons.tv;
      case 'khăn lạnh':
        return Icons.dry_cleaning_outlined;
      case 'massage':
        return Icons.airline_seat_recline_extra_rounded;
      case 'chăn':
        return Icons.bed_outlined;
      default:
        return Icons.check_circle_outline;
    }
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
    final totalPrice = selectedSeats.length * widget.busData['price'];

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
                title: AppLocalizations.of(context)!.continueButton,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

