import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/flight_booking/presentation/pages/flight_ticket.page.dart';
import 'package:tour_guide_app/features/car_rental/presentation/widgets/payment_method_selector.widget.dart';

class FlightBookingConfirmationPage extends StatefulWidget {
  final Map<String, dynamic> flightData;
  final String fromAirport;
  final String toAirport;
  final DateTime date;
  final List<Map<String, dynamic>> selectedSeats;
  final String seatClass;

  const FlightBookingConfirmationPage({
    Key? key,
    required this.flightData,
    required this.fromAirport,
    required this.toAirport,
    required this.date,
    required this.selectedSeats,
    required this.seatClass,
  }) : super(key: key);

  @override
  State<FlightBookingConfirmationPage> createState() => _FlightBookingConfirmationPageState();
}

class _FlightBookingConfirmationPageState extends State<FlightBookingConfirmationPage> {
  String? selectedPaymentMethod = 'momo';
  String userName = '';
  String userEmail = '';
  bool isLoadingUserInfo = true;
  
  final List<Map<String, String>> paymentOptions = [
    {'id': 'momo', 'image': AppImage.momo},
    {'id': 'zalopay', 'image': AppImage.zalopay},
    {'id': 'visa', 'image': AppImage.visa},
    {'id': 'mastercard', 'image': AppImage.mastercard},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    // Simulate loading user info
    setState(() {
      userName = 'Nguyễn Văn A';
      userEmail = 'user@example.com';
      isLoadingUserInfo = false;
    });
  }

  void _confirmBooking() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => FlightTicketPage(
          flightData: widget.flightData,
          fromAirport: widget.fromAirport,
          toAirport: widget.toAirport,
          date: widget.date,
          selectedSeats: widget.selectedSeats,
          seatClass: widget.seatClass,
          bookingCode: 'FLIGHT${DateTime.now().millisecondsSinceEpoch}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prices = widget.flightData['prices'] as Map<String, dynamic>;
    final pricePerSeat = prices[widget.seatClass] as num;
    final totalPrice = widget.selectedSeats.length * pricePerSeat;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.confirmBookingTicket,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Flight Summary
                  _buildFlightSummary(),

                  SizedBox(height: 20.h),

                  // Passenger Info Display
                  _buildPassengerInfoSection(),

                  SizedBox(height: 20.h),

                  // Price Breakdown
                  _buildPriceBreakdown(totalPrice.toDouble()),

                  SizedBox(height: 28.h),

                  // Payment Method
                  Text(
                    'Phương thức thanh toán',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                  ),
                  SizedBox(height: 12.h),
                  PaymentMethodSelector(
                    bankOptions: paymentOptions,
                    selectedBank: selectedPaymentMethod,
                    onSelect: (method) {
                      setState(() => selectedPaymentMethod = method);
                    },
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar
          _buildBottomBar(totalPrice.toDouble()),
        ],
      ),
    );
  }

  Widget _buildFlightSummary() {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
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
                // Flight Number & Airline Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: AppColors.primaryWhite,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.flight_rounded,
                        size: 24.r,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.flightData['flightNumber'],
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.primaryWhite,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            widget.flightData['airline'],
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
                                      color: AppColors.primaryWhite.withOpacity(0.5),
                                      width: 2,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Từ',
                                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                        color: AppColors.primaryWhite.withOpacity(0.85),
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              widget.fromAirport,
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
                              widget.flightData['departureTime'],
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
                                    Icons.flight_rounded,
                                    color: AppColors.primaryBlue,
                                    size: 16.r,
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    widget.flightData['duration'],
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
                              widget.toAirport,
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
                              widget.flightData['arrivalTime'],
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

                SizedBox(height: 16.h),

                Divider(color: AppColors.primaryWhite.withOpacity(0.3), thickness: 2),

                SizedBox(height: 16.h),

                // Date, Class & Seats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            color: AppColors.primaryWhite.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.calendar_today_rounded,
                            size: 16.r,
                            color: AppColors.primaryWhite,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '${widget.date.day}/${widget.date.month}/${widget.date.year}',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: AppColors.primaryWhite,
                              ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        widget.seatClass,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: AppColors.primaryWhite,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerInfoSection() {
    if (isLoadingUserInfo) {
      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(12.r),
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
            'Thông tin hành khách',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
          SizedBox(height: 16.h),
          
          // User Info Display
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: SvgPicture.asset(AppIcons.user, width: 24.w, height: 24.h, color: AppColors.primaryWhite),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Họ và tên',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: AppColors.textSubtitle,
                          ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      userName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.email_outlined, size: 24.r, color: AppColors.primaryWhite),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: AppColors.textSubtitle,
                          ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      userEmail,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.airline_seat_recline_normal_rounded, size: 24.r, color: AppColors.primaryWhite),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ghế đã chọn',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: AppColors.textSubtitle,
                          ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      widget.selectedSeats.map((s) => s['seatLabel']).join(', '),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown(double totalPrice) {
    final ticketPrice = totalPrice;
    final serviceFee = totalPrice * 0.05;
    final insurance = 30000.0 * widget.selectedSeats.length;
    final airportTax = 50000.0 * widget.selectedSeats.length;
    final total = ticketPrice + serviceFee + insurance + airportTax;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(12.r),
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
            'Chi tiết giá',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
          SizedBox(height: 12.h),
          _buildPriceRow('Giá vé (${widget.selectedSeats.length} ghế)', ticketPrice),
          SizedBox(height: 8.h),
          _buildPriceRow('Phí dịch vụ', serviceFee),
          SizedBox(height: 8.h),
          _buildPriceRow('Bảo hiểm hành khách', insurance),
          SizedBox(height: 8.h),
          _buildPriceRow('Thuế sân bay', airportTax),
          SizedBox(height: 12.h),
          Divider(color: AppColors.textSubtitle.withOpacity(0.2), thickness: 2),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng cộng',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
              Text(
                '${total.toStringAsFixed(0)}đ',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primaryBlue,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: AppColors.textSubtitle,
              ),
        ),
        Text(
          '${price.toStringAsFixed(0)}đ',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
              ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(double totalPrice) {
    final serviceFee = totalPrice * 0.05;
    final insurance = 30000.0 * widget.selectedSeats.length;
    final airportTax = 50000.0 * widget.selectedSeats.length;
    final total = totalPrice + serviceFee + insurance + airportTax;

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
                    'Tổng thanh toán',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSubtitle,
                        ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${total.toStringAsFixed(0)}đ',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.primaryBlue,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: PrimaryButton(
                onPressed: _confirmBooking,
                title: AppLocalizations.of(context)!.confirmBookingTicket,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

