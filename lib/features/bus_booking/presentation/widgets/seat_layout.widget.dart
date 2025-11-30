import 'package:flutter_svg/svg.dart';
import 'package:tour_guide_app/common_libs.dart';

enum SeatStatus { available, selected, booked }

class SeatLayoutWidget extends StatefulWidget {
  final String busType;
  final Function(List<int>) onSeatsChanged;
  final int maxSeats;

  const SeatLayoutWidget({
    Key? key,
    required this.busType,
    required this.onSeatsChanged,
    this.maxSeats = 5,
  }) : super(key: key);

  @override
  State<SeatLayoutWidget> createState() => _SeatLayoutWidgetState();
}

class _SeatLayoutWidgetState extends State<SeatLayoutWidget> {
  List<int> selectedSeats = [];
  late List<SeatStatus> seatStatuses;

  @override
  void initState() {
    super.initState();
    _initializeSeatStatuses();
  }

  void _initializeSeatStatuses() {
    final totalSeats = widget.busType.contains('40') ? 40 : 
                       widget.busType.contains('45') ? 45 : 
                       widget.busType.contains('34') ? 34 : 22;
    
    // Random booked seats for demo
    seatStatuses = List.generate(totalSeats, (index) {
      if ([3, 7, 12, 15, 23, 28, 31].contains(index)) {
        return SeatStatus.booked;
      }
      return SeatStatus.available;
    });
  }

  void _toggleSeat(int index) {
    if (seatStatuses[index] == SeatStatus.booked) return;

    setState(() {
      if (seatStatuses[index] == SeatStatus.selected) {
        seatStatuses[index] = SeatStatus.available;
        selectedSeats.remove(index);
      } else if (selectedSeats.length < widget.maxSeats) {
        seatStatuses[index] = SeatStatus.selected;
        selectedSeats.add(index);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.maxSeatsSelectedBus(widget.maxSeats)),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
    });

    widget.onSeatsChanged(selectedSeats);
  }

  @override
  Widget build(BuildContext context) {
    final isLimousine = widget.busType.contains('Limousine') || 
                        widget.busType.contains('22');
    
    return Column(
      children: [
        // Legend
        _buildLegend(),
        
        SizedBox(height: 20.h),

        // Seat Layout
        Container(
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
            children: [
              // Driver section
              _buildDriverSection(),
              
              SizedBox(height: 16.h),

              // Seats
              isLimousine 
                  ? _buildLimousineSeatLayout() 
                  : _buildStandardSeatLayout(),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Selected seats info
        if (selectedSeats.isNotEmpty) _buildSelectedSeatsInfo(),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem(AppColors.textSubtitle.withOpacity(0.1), 'Trống'),
        _buildLegendItem(AppColors.primaryBlue, 'Đang chọn'),
        _buildLegendItem(AppColors.textSubtitle.withOpacity(0.4), 'Đã đặt'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 24.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppColors.textSubtitle,
              ),
        ),
      ],
    );
  }

  Widget _buildDriverSection() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                AppIcons.user,
                width: 16.w,
                height: 16.h,
                color: AppColors.primaryBlue,
              ),
              SizedBox(width: 6.w),
              Text(
                'Tài xế',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.primaryBlue,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStandardSeatLayout() {
    // Standard bus: 4 seats per row (2-2 layout)
    final rows = (seatStatuses.length / 4).ceil();
    
    return Column(
      children: List.generate(rows, (rowIndex) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Row(
            children: [
              // Left side (2 seats)
              _buildSeat(rowIndex * 4),
              SizedBox(width: 8.w),
              _buildSeat(rowIndex * 4 + 1),
              
              // Aisle
              SizedBox(width: 24.w),
              
              // Right side (2 seats)
              if (rowIndex * 4 + 2 < seatStatuses.length) 
                _buildSeat(rowIndex * 4 + 2),
              SizedBox(width: 8.w),
              if (rowIndex * 4 + 3 < seatStatuses.length) 
                _buildSeat(rowIndex * 4 + 3),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLimousineSeatLayout() {
    // Limousine: 2 beds per row (1-1 layout)
    final rows = (seatStatuses.length / 2).ceil();
    
    return Column(
      children: List.generate(rows, (rowIndex) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left bed
              _buildBedSeat(rowIndex * 2),
              
              // Right bed
              if (rowIndex * 2 + 1 < seatStatuses.length)
                _buildBedSeat(rowIndex * 2 + 1),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSeat(int index) {
    if (index >= seatStatuses.length) return SizedBox.shrink();

    final status = seatStatuses[index];
    Color backgroundColor;
    
    switch (status) {
      case SeatStatus.selected:
        backgroundColor = AppColors.primaryBlue;
        break;
      case SeatStatus.booked:
        backgroundColor = AppColors.textSubtitle.withOpacity(0.4);
        break;
      default:
        backgroundColor = AppColors.textSubtitle.withOpacity(0.1);
    }

    return GestureDetector(
      onTap: () => _toggleSeat(index),
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: status == SeatStatus.selected 
                      ? AppColors.primaryWhite 
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildBedSeat(int index) {
    if (index >= seatStatuses.length) return SizedBox.shrink();

    final status = seatStatuses[index];
    Color backgroundColor;
    
    switch (status) {
      case SeatStatus.selected:
        backgroundColor = AppColors.primaryBlue;
        break;
      case SeatStatus.booked:
        backgroundColor = AppColors.textSubtitle.withOpacity(0.4);
        break;
      default:
        backgroundColor = AppColors.textSubtitle.withOpacity(0.1);
    }

    return GestureDetector(
      onTap: () => _toggleSeat(index),
      child: Container(
        width: 140.w,
        height: 60.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: status == SeatStatus.selected 
                ? AppColors.primaryBlue.withOpacity(0.5)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.airline_seat_flat_rounded,
                size: 24.r,
                color: status == SeatStatus.selected 
                    ? AppColors.primaryWhite 
                    : AppColors.textPrimary,
              ),
              SizedBox(height: 4.h),
              Text(
                '${index + 1}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: status == SeatStatus.selected 
                          ? AppColors.primaryWhite 
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedSeatsInfo() {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.event_seat_rounded,
            color: AppColors.primaryWhite,
            size: 20.r,
          ),
          SizedBox(width: 8.w),
          Text(
            'Đã chọn: ',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          Text(
            selectedSeats.map((s) => s + 1).join(', '),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondary,
                            ),
          ),
        ],
      ),
    );
  }
}

