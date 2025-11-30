import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common_libs.dart';

enum SeatStatus { available, selected, booked }

class TrainSeatLayoutWidget extends StatefulWidget {
  final String seatClass;
  final Function(List<Map<String, dynamic>>) onSeatsChanged;
  final int maxSeats;

  const TrainSeatLayoutWidget({
    Key? key,
    required this.seatClass,
    required this.onSeatsChanged,
    this.maxSeats = 5,
  }) : super(key: key);

  @override
  State<TrainSeatLayoutWidget> createState() => _TrainSeatLayoutWidgetState();
}

class _TrainSeatLayoutWidgetState extends State<TrainSeatLayoutWidget> {
  int selectedCoach = 1;
  List<Map<String, dynamic>> selectedSeats = []; // {coach, seat}
  late Map<int, List<SeatStatus>> coachSeatStatuses; // coach -> seat statuses

  @override
  void initState() {
    super.initState();
    _initializeSeatStatuses();
  }

  void _initializeSeatStatuses() {
    coachSeatStatuses = {};
    
    // Initialize 8 coaches with different seat layouts based on class
    for (int coach = 1; coach <= 8; coach++) {
      final totalSeats = _getTotalSeatsForClass();
      
      // Random booked seats for demo
      final bookedIndices = [3, 7, 12, 15, 20, 25, 28].where((i) => i < totalSeats).toList();
      
      coachSeatStatuses[coach] = List.generate(totalSeats, (index) {
        if (bookedIndices.contains(index)) {
          return SeatStatus.booked;
        }
        return SeatStatus.available;
      });
    }
  }

  int _getTotalSeatsForClass() {
    switch (widget.seatClass) {
      case 'Ngồi cứng':
        return 64; // 16 rows x 4 seats
      case 'Ngồi mềm':
        return 48; // 12 rows x 4 seats
      case 'Giường nằm cứng':
        return 42; // 7 compartments x 6 berths
      case 'Giường nằm mềm':
        return 28; // 7 compartments x 4 berths
      default:
        return 48;
    }
  }

  void _toggleSeat(int seatIndex) {
    final currentCoachSeats = coachSeatStatuses[selectedCoach]!;
    
    if (currentCoachSeats[seatIndex] == SeatStatus.booked) return;

    setState(() {
      final seatIdentifier = {'coach': selectedCoach, 'seat': seatIndex};
      final alreadySelected = selectedSeats.any(
        (s) => s['coach'] == selectedCoach && s['seat'] == seatIndex
      );

      if (alreadySelected) {
        currentCoachSeats[seatIndex] = SeatStatus.available;
        selectedSeats.removeWhere(
          (s) => s['coach'] == selectedCoach && s['seat'] == seatIndex
        );
      } else if (selectedSeats.length < widget.maxSeats) {
        currentCoachSeats[seatIndex] = SeatStatus.selected;
        selectedSeats.add(seatIdentifier);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.maxSeatsSelectedTrain(widget.maxSeats)),
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
    final isBerth = widget.seatClass.contains('Giường nằm');
    
    return Column(
      children: [
        // Coach Selector
        _buildCoachSelector(),
        
        SizedBox(height: 24.h),

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
              // Coach Header
              _buildCoachHeader(),
              
              SizedBox(height: 16.h),

              // Seats
              isBerth 
                  ? _buildBerthLayout() 
                  : _buildSeatLayout(),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Selected seats info
        if (selectedSeats.isNotEmpty) _buildSelectedSeatsInfo(),
      ],
    );
  }

  Widget _buildCoachSelector() {
    final totalCoaches = coachSeatStatuses.length;
    
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(8.r),
        itemCount: totalCoaches,
        itemBuilder: (context, index) {
          final coach = index + 1;
          return GestureDetector(
            onTap: () {
              setState(() => selectedCoach = coach);
            },
            child: Container(
              width: 80.w,
              margin: EdgeInsets.only(right: 8.w),
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                color: selectedCoach == coach 
                    ? AppColors.primaryBlue 
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppIcons.train,
                    width: 24.w,
                    height: 24.h,
                    colorFilter: ColorFilter.mode(
                      selectedCoach == coach 
                          ? AppColors.primaryWhite 
                          : AppColors.textSubtitle,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Toa $coach',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: selectedCoach == coach 
                              ? AppColors.primaryWhite 
                              : AppColors.textSubtitle,
                          fontWeight: selectedCoach == coach 
                              ? FontWeight.w700 
                              : FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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

  Widget _buildCoachHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: SvgPicture.asset(
                AppIcons.train,
                width: 20.w,
                height: 20.h,
                colorFilter: ColorFilter.mode(AppColors.primaryWhite, BlendMode.srcIn),
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Toa $selectedCoach',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                ),
                Text(
                  widget.seatClass,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppColors.textSubtitle,
                      ),
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            '${_getAvailableSeatsCount()} chỗ trống',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.primaryWhite,
                ),
          ),
        ),
      ],
    );
  }

  int _getAvailableSeatsCount() {
    return coachSeatStatuses[selectedCoach]!
        .where((s) => s == SeatStatus.available)
        .length;
  }

  Widget _buildSeatLayout() {
    final currentCoachSeats = coachSeatStatuses[selectedCoach]!;
    
    // Standard seat: 4 seats per row (2-2 layout with aisle)
    final rows = (currentCoachSeats.length / 4).ceil();
    
    return SingleChildScrollView(
      child: Column(
        children: List.generate(rows, (rowIndex) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Row number
                Container(
                  width: 30.w,
                  child: Text(
                    '${rowIndex + 1}',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: AppColors.textSubtitle,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                SizedBox(width: 8.w),
                
                // Left side (2 seats)
                _buildSeat(rowIndex * 4),
                SizedBox(width: 8.w),
                _buildSeat(rowIndex * 4 + 1),
                
                // Aisle with indicator on first row
                Expanded(
                  child: Column(
                    children: [
                      if (rowIndex == 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Lối đi',
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                    color: AppColors.primaryBlue,
                                  ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.arrow_downward_rounded,
                              size: 12.r,
                              color: AppColors.primaryBlue,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Right side (2 seats)
                if (rowIndex * 4 + 2 < currentCoachSeats.length) 
                  _buildSeat(rowIndex * 4 + 2),
                SizedBox(width: 8.w),
                if (rowIndex * 4 + 3 < currentCoachSeats.length) 
                  _buildSeat(rowIndex * 4 + 3),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBerthLayout() {
    final currentCoachSeats = coachSeatStatuses[selectedCoach]!;
    final isSoftBerth = widget.seatClass == 'Giường nằm mềm';
    final berthsPerCompartment = isSoftBerth ? 4 : 6;
    final compartments = (currentCoachSeats.length / berthsPerCompartment).ceil();
    
    return SingleChildScrollView(
      child: Column(
        children: List.generate(compartments, (compIndex) {
          return Container(
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.textSubtitle.withOpacity(0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Text(
                  'Khoang ${compIndex + 1}',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                ),
                SizedBox(height: 12.h),
                
                if (isSoftBerth)
                  // Soft berth: 2x2 layout
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildBerthSeat(compIndex * 4, 'Dưới'),
                          _buildBerthSeat(compIndex * 4 + 2, 'Dưới'),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildBerthSeat(compIndex * 4 + 1, 'Trên'),
                          _buildBerthSeat(compIndex * 4 + 3, 'Trên'),
                        ],
                      ),
                    ],
                  )
                else
                  // Hard berth: 2x3 layout
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildBerthSeat(compIndex * 6, 'Dưới'),
                          _buildBerthSeat(compIndex * 6 + 3, 'Dưới'),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildBerthSeat(compIndex * 6 + 1, 'Giữa'),
                          _buildBerthSeat(compIndex * 6 + 4, 'Giữa'),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildBerthSeat(compIndex * 6 + 2, 'Trên'),
                          _buildBerthSeat(compIndex * 6 + 5, 'Trên'),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSeat(int index) {
    final currentCoachSeats = coachSeatStatuses[selectedCoach]!;
    if (index >= currentCoachSeats.length) return SizedBox.shrink();

    final status = currentCoachSeats[index];
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

  Widget _buildBerthSeat(int index, String position) {
    final currentCoachSeats = coachSeatStatuses[selectedCoach]!;
    if (index >= currentCoachSeats.length) return SizedBox.shrink();

    final status = currentCoachSeats[index];
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
        width: 130.w,
        height: 55.h,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bed_rounded,
              size: 20.r,
              color: status == SeatStatus.selected 
                  ? AppColors.primaryWhite 
                  : AppColors.textPrimary,
            ),
            SizedBox(height: 4.h),
            Text(
              '${index + 1} - $position',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: status == SeatStatus.selected 
                        ? AppColors.primaryWhite 
                        : AppColors.textPrimary,
                  ),
            ),
          ],
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
          Expanded(
            child: Text(
              'Đã chọn: ${selectedSeats.map((s) => "Toa ${s['coach']}-${s['seat']! + 1}").join(', ')}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

