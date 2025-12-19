import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/room.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel_booking.dart';
import 'package:tour_guide_app/features/hotel_booking/presentation/widgets/room_card.widget.dart';

class HotelRoomListPage extends StatefulWidget {
  const HotelRoomListPage({super.key});

  @override
  State<HotelRoomListPage> createState() => _HotelRoomListPageState();
}

class _HotelRoomListPageState extends State<HotelRoomListPage> {
  final List<Room> _rooms = Room.getMockRooms();
  final Map<String, int> _selectedRooms = {}; // roomId -> quantity

  void _navigateToBookingInfo() {
    final selectedRoomBookings =
        _selectedRooms.entries.where((entry) => entry.value > 0).map((entry) {
          final room = _rooms.firstWhere((r) => r.id == entry.key);
          return RoomBooking(room: room, quantity: entry.value);
        }).toList();

    if (selectedRoomBookings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.pleaseSelectAtLeastOneRoom,
          ),
        ),
      );
      return;
    }

    // Calculate total
    final totalCost = selectedRoomBookings.fold<double>(
      0,
      (sum, booking) => sum + booking.totalPrice,
    );

    final booking = HotelBooking(
      hotelName: 'Khách sạn Continental',
      hotelAddress: 'Quận 1, TP.HCM',
      selectedRooms: selectedRoomBookings,
      totalCost: totalCost,
      numberOfNights: 1, // Mock data
    );

    Navigator.of(
      context,
    ).pushNamed(AppRouteConstant.hotelBookingInfo, arguments: booking);
  }

  double _getTotalPrice() {
    return _selectedRooms.entries.fold<double>(0, (sum, entry) {
      final room = _rooms.firstWhere((r) => r.id == entry.key);
      return sum + (room.pricePerNight * entry.value);
    });
  }

  int _getTotalRooms() {
    return _selectedRooms.values.fold(0, (sum, quantity) => sum + quantity);
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = _getTotalPrice();
    final totalRooms = _getTotalRooms();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.selectRoom,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: _rooms.length,
              itemBuilder: (context, index) {
                final room = _rooms[index];
                return RoomCard(
                  room: room,
                  selectedQuantity: _selectedRooms[room.id] ?? 0,
                  onQuantityChanged: (quantity) {
                    setState(() {
                      if (quantity > 0) {
                        _selectedRooms[room.id] = quantity;
                      } else {
                        _selectedRooms.remove(room.id);
                      }
                    });
                  },
                );
              },
            ),
          ),

          // Bottom bar
          if (totalRooms > 0)
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.primaryWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
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
                            '$totalRooms phòng',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSubtitle),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            Formatter.currency(totalPrice),
                            style: Theme.of(
                              context,
                            ).textTheme.headlineMedium?.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _navigateToBookingInfo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          minimumSize: Size(double.infinity, 50.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.continueAction,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
