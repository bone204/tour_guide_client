import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';

enum SeatStatus { available, selected, booked }

class FlightSeatLayoutWidget extends StatefulWidget {
  final String seatClass;
  final Function(List<Map<String, dynamic>>) onSeatsChanged;
  final int maxSeats;

  const FlightSeatLayoutWidget({
    Key? key,
    required this.seatClass,
    required this.onSeatsChanged,
    this.maxSeats = 5,
  }) : super(key: key);

  @override
  State<FlightSeatLayoutWidget> createState() => _FlightSeatLayoutWidgetState();
}

class _FlightSeatLayoutWidgetState extends State<FlightSeatLayoutWidget> {
  List<Map<String, dynamic>> selectedSeats = []; // {row, column, seatLabel}
  late List<List<SeatStatus>> seatStatuses;

  @override
  void initState() {
    super.initState();
    _initializeSeatStatuses();
  }

  void _initializeSeatStatuses() {
    final config = _getSeatConfiguration();
    final totalRows = config['rows'] as int;
    final seatsPerRow = config['seatsPerRow'] as int;

    // Random booked seats for demo
    final bookedSeats = [
      {'row': 2, 'col': 0},
      {'row': 2, 'col': 5},
      {'row': 5, 'col': 2},
      {'row': 5, 'col': 3},
      {'row': 8, 'col': 1},
      {'row': 8, 'col': 4},
      {'row': 10, 'col': 0},
      {'row': 10, 'col': 5},
      {'row': 15, 'col': 2},
    ];

    seatStatuses = List.generate(totalRows, (row) {
      return List.generate(seatsPerRow, (col) {
        // Check if this seat is booked
        if (bookedSeats.any((s) => s['row'] == row && s['col'] == col)) {
          return SeatStatus.booked;
        }
        return SeatStatus.available;
      });
    });
  }

  Map<String, dynamic> _getSeatConfiguration() {
    switch (widget.seatClass) {
      case 'Phổ thông':
        return {
          'rows': 30,
          'seatsPerRow': 6, // 3-3 layout
          'aisleAfter': [2], // Aisle after column 2 (index 2)
        };
      case 'Phổ thông đặc biệt':
        return {
          'rows': 10,
          'seatsPerRow': 6, // 3-3 layout
          'aisleAfter': [2],
        };
      case 'Thương gia':
        return {
          'rows': 5,
          'seatsPerRow': 4, // 2-2 layout
          'aisleAfter': [1], // Aisle after column 1
        };
      case 'Hạng nhất':
        return {
          'rows': 3,
          'seatsPerRow': 4, // 1-2-1 layout
          'aisleAfter': [0, 2],
        };
      default:
        return {
          'rows': 30,
          'seatsPerRow': 6,
          'aisleAfter': [2],
        };
    }
  }

  String _getSeatLabel(int row, int col) {
    final columns = ['A', 'B', 'C', 'D', 'E', 'F'];
    return '${row + 1}${columns[col]}';
  }

  void _toggleSeat(int row, int col) {
    if (seatStatuses[row][col] == SeatStatus.booked) return;

    setState(() {
      final seatLabel = _getSeatLabel(row, col);
      final seatIdentifier = {
        'row': row,
        'column': col,
        'seatLabel': seatLabel,
      };
      final alreadySelected = selectedSeats.any(
        (s) => s['row'] == row && s['column'] == col,
      );

      if (alreadySelected) {
        seatStatuses[row][col] = SeatStatus.available;
        selectedSeats.removeWhere((s) => s['row'] == row && s['column'] == col);
      } else if (selectedSeats.length < widget.maxSeats) {
        seatStatuses[row][col] = SeatStatus.selected;
        selectedSeats.add(seatIdentifier);
      } else {
        CustomSnackbar.show(
          context,
          message: AppLocalizations.of(
            context,
          )!.maxSeatsSelected(widget.maxSeats),
          type: SnackbarType.warning,
        );
      }
    });

    widget.onSeatsChanged(selectedSeats);
  }

  @override
  Widget build(BuildContext context) {
    final config = _getSeatConfiguration();
    final aisleAfter = config['aisleAfter'] as List<int>;

    return Column(
      children: [
        // Legend
        _buildLegend(),

        SizedBox(height: 20.h),

        // Plane Front Icon
        _buildPlaneHeader(),

        SizedBox(height: 12.h),

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
              // Column Labels
              _buildColumnLabels(config['seatsPerRow'] as int, aisleAfter),

              SizedBox(height: 8.h),

              // Seats
              Column(
                children: List.generate(seatStatuses.length, (row) {
                  return _buildSeatRow(row, aisleAfter);
                }),
              ),
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
          child: Icon(
            Icons.airline_seat_recline_normal_rounded,
            size: 14.r,
            color:
                color == AppColors.primaryBlue
                    ? AppColors.primaryWhite
                    : AppColors.textSubtitle,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(color: AppColors.textSubtitle),
        ),
      ],
    );
  }

  Widget _buildPlaneHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBlue,
            AppColors.primaryBlue.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
          bottomLeft: Radius.circular(8.r),
          bottomRight: Radius.circular(8.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.flight_rounded, color: AppColors.primaryWhite, size: 24.r),
          SizedBox(width: 8.w),
          Text(
            'Đầu máy bay',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.primaryWhite),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnLabels(int seatsPerRow, List<int> aisleAfter) {
    final columns = ['A', 'B', 'C', 'D', 'E', 'F'];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Row number space
          SizedBox(width: 35.w),

          // Column labels with aisles
          ...List.generate(seatsPerRow, (col) {
            return [
              if (col > 0 && aisleAfter.contains(col - 1))
                SizedBox(width: 20.w), // Aisle space
              Container(
                width: 40.w,
                alignment: Alignment.center,
                child: Text(
                  columns[col],
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ];
          }).expand((x) => x).toList(),
        ],
      ),
    );
  }

  Widget _buildSeatRow(int row, List<int> aisleAfter) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Row number
          Container(
            width: 35.w,
            child: Text(
              '${row + 1}',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppColors.textSubtitle,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Seats with aisles
          ...List.generate(seatStatuses[row].length, (col) {
            return [
              if (col > 0 && aisleAfter.contains(col - 1))
                SizedBox(width: 20.w), // Aisle space
              _buildSeat(row, col),
            ];
          }).expand((x) => x).toList(),
        ],
      ),
    );
  }

  Widget _buildSeat(int row, int col) {
    final status = seatStatuses[row][col];
    Color backgroundColor;
    Color iconColor;

    switch (status) {
      case SeatStatus.selected:
        backgroundColor = AppColors.primaryBlue;
        iconColor = AppColors.primaryWhite;
        break;
      case SeatStatus.booked:
        backgroundColor = AppColors.textSubtitle.withOpacity(0.4);
        iconColor = AppColors.textSubtitle;
        break;
      default:
        backgroundColor = AppColors.textSubtitle.withOpacity(0.1);
        iconColor = AppColors.textSubtitle;
    }

    return GestureDetector(
      onTap: () => _toggleSeat(row, col),
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Center(
          child: Icon(
            Icons.airline_seat_recline_normal_rounded,
            size: 20.r,
            color: iconColor,
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
            Icons.airline_seat_recline_normal_rounded,
            color: AppColors.primaryWhite,
            size: 20.r,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'Đã chọn: ${selectedSeats.map((s) => s['seatLabel']).join(', ')}',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
