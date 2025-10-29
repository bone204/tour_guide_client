import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/button/secondary_button.dart';
import 'package:tour_guide_app/common_libs.dart';

class BusTicketPage extends StatefulWidget {
  final Map<String, dynamic> busData;
  final String fromLocation;
  final String toLocation;
  final DateTime date;
  final List<int> selectedSeats;
  final String bookingCode;

  const BusTicketPage({
    super.key,
    required this.busData,
    required this.fromLocation,
    required this.toLocation,
    required this.date,
    required this.selectedSeats,
    required this.bookingCode,
  });

  @override
  State<BusTicketPage> createState() => _BusTicketPageState();
}

class _BusTicketPageState extends State<BusTicketPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'Vé xe khách',
        showBackButton: true,
        onBackPressed: () {
          Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
        },
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                // Ticket Card
                _buildTicketCard(context),

                SizedBox(height: 24.h),

                // Actions
                _buildActionButtons(context),
                
                SizedBox(height: 24.h),
                
                // Info Note
                _buildInfoNote(),
                
                SizedBox(height: 32.h),
                
                // Home Button
                SecondaryButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
                  },
                  title: 'Về trang chủ',
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 3,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Premium Header with gradient
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryBlue,
                  AppColors.primaryBlue.withOpacity(0.85),
                  const Color(0xFF1E88E5),
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    AppIcons.bus,
                    width: 40.w,
                    height: 40.h,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'VÉ XE KHÁCH ĐIỆN TỬ',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primaryWhite,
                        letterSpacing: 1.5,
                      ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'E-Ticket',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppColors.primaryWhite.withOpacity(0.9),
                      ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),
              
          // Ticket Content
          Column(
            children: [
              // Booking Code with enhanced design
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryYellow.withOpacity(0.15),
                      AppColors.primaryYellow.withOpacity(0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: AppColors.primaryYellow.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppIcons.star,
                      width: 16.w,
                      height: 16.h,
                      colorFilter: const ColorFilter.mode(AppColors.primaryYellow, BlendMode.srcIn),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Mã đặt vé: ',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: AppColors.textSubtitle,
                          ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      widget.bookingCode,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: Colors.orange.shade800,
                            letterSpacing: 1,
                          ),
                    ),
                  ],
                ),
              ),
          
              SizedBox(height: 24.h),
          
              // Company & Bus Type with cards
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      context,
                      'Nhà xe',
                      widget.busData['company'],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildInfoCard(
                      context,
                      'Loại xe',
                      widget.busData['type'],
                    ),
                  ),
                ],
              ),
          
              SizedBox(height: 24.h),
          
              // Modern Route Design
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                 color: AppColors.primaryWhite,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: AppColors.primaryBlue,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Departure
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGreen,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  'Khởi hành',
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                widget.busData['departureTime'],
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: AppColors.primaryBlue,
                                    ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                widget.fromLocation,
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                      height: 1.3,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
          
                        // Duration & Arrow
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Column(
                            children: [
                              SizedBox(height: 20.h),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  widget.busData['duration'],
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: AppColors.primaryBlue,
                                size: 24.r,
                              ),
                            ],
                          ),
                        ),
          
                        // Arrival
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryRed,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  'Đến nơi',
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                widget.busData['arrivalTime'],
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: AppColors.primaryRed,
                                    ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                widget.toLocation,
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                      height: 1.3,
                                    ),
                                textAlign: TextAlign.right,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          
              SizedBox(height: 20.h),
          
              // Dashed separator
              _buildDashedLine(),
          
              SizedBox(height: 20.h),
          
              // Date & Seats Info
              _buildModernInfoRow(
                context,
                AppIcons.calendar,
                'Ngày đi',
                '${widget.date.day}/${widget.date.month}/${widget.date.year}',
                Colors.orange,
              ),
              SizedBox(height: 14.h),
              _buildModernInfoRow(
                context,
                AppIcons.seat,
                'Số ghế',
                widget.selectedSeats.map((s) => s + 1).join(', '),
                Colors.blue,
              ),
              SizedBox(height: 14.h),
              _buildModernInfoRow(
                context,
                AppIcons.star,
                'Số lượng',
                '${widget.selectedSeats.length} vé',
                Colors.green,
              ),
          
              SizedBox(height: 24.h),
          
              // Enhanced QR Code Section
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryGrey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: AppColors.textSubtitle.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: AppColors.primaryWhite,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.qr_code_2_rounded,
                            size: 120.r,
                            color: AppColors.textPrimary,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            widget.bookingCode,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: AppColors.textSubtitle,
                                  letterSpacing: 2,
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 16.r,
                          color: AppColors.primaryBlue,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Vui lòng xuất trình mã QR khi lên xe',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: AppColors.textSubtitle,
                              ),
                        ),
                      ],
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
  
  Widget _buildDashedLine() {
    return Row(
      children: List.generate(
        30,
        (index) => Expanded(
          child: Container(
            height: 2,
            color: index.isEven ? AppColors.textSubtitle.withOpacity(0.2) : Colors.transparent,
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoCard(
    BuildContext context,
    String label,
    String value,
  ) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primaryBlack,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.textSubtitle,
                ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textPrimary,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  
  Widget _buildModernInfoRow(
    BuildContext context,
    String icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: SvgPicture.asset(
            icon,
            width: 20.w,
            height: 20.h,
            colorFilter: ColorFilter.mode(AppColors.primaryWhite , BlendMode.srcIn),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.textSubtitle,
                    ),
              ),
              SizedBox(height: 6.h),
              Text(
                value,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PrimaryButton(
            icon: AppIcons.star,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.download_done_rounded, color: Colors.white),
                      SizedBox(width: 8.w),
                      const Text('Đang tải vé xuống máy...'),
                    ],
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              );
            },
            title: 'Tải vé về máy',
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: PrimaryButton(
            icon: AppIcons.star,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.share_rounded, color: Colors.white),
                      SizedBox(width: 8.w),
                      const Text('Chia sẻ vé...'),
                    ],
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              );
            },
            title: 'Chia sẻ vé',
          ),
        ),
      ],
    );
  }
  
  Widget _buildInfoNote() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 3,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_rounded,
                color: AppColors.primaryBlue,
                size: 24.r,
              ),
              SizedBox(width: 8.w),
              Text(
                'Lưu ý quan trọng',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildNoteItem('Vui lòng có mặt tại điểm đón trước 15 phút'),
          SizedBox(height: 8.h),
          _buildNoteItem('Mang theo CMND/CCCD khi lên xe'),
          SizedBox(height: 8.h),
          _buildNoteItem('Xuất trình mã QR cho tài xế để xác nhận'),
        ],
      ),
    );
  }
  
  Widget _buildNoteItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 6.h),
          width: 5.w,
          height: 5.h,
          decoration: const BoxDecoration(
            color: AppColors.primaryBlue,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.textSubtitle,
                  height: 1.3,
                ),
          ),
        ),
      ],
    );
  }
}
