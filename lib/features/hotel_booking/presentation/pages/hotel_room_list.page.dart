import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/room.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel_booking.dart';
import 'package:tour_guide_app/features/hotel_booking/presentation/widgets/room_card.widget.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel_room_search_request.dart';
import 'package:tour_guide_app/features/hotel_booking/presentation/bloc/find_hotel/find_hotel_cubit.dart';
import 'package:tour_guide_app/features/hotel_booking/presentation/bloc/find_hotel/find_hotel_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class HotelRoomListPage extends StatefulWidget {
  final HotelRoomSearchRequest? request;
  final List<HotelRoom>? rooms;

  const HotelRoomListPage({super.key, this.request, this.rooms});

  @override
  State<HotelRoomListPage> createState() => _HotelRoomListPageState();
}

class _HotelRoomListPageState extends State<HotelRoomListPage> {
  List<HotelRoom> _rooms = [];
  final Map<int, int> _selectedRooms = {}; // roomId -> quantity
  late FindHotelCubit _findHotelCubit;

  @override
  void initState() {
    super.initState();
    _findHotelCubit = sl<FindHotelCubit>();
    if (widget.rooms != null) {
      _rooms = widget.rooms!;
    } else {
      _fetchRooms();
    }
  }

  void _fetchRooms() {
    // If request argument is null (e.g. direct navigation), use default request
    final searchRequest = widget.request ?? HotelRoomSearchRequest();
    _findHotelCubit.findHotels(searchRequest);
  }

  @override
  void dispose() {
    _findHotelCubit.close();
    super.dispose();
  }

  void _navigateToBookingInfo() {
    final selectedRoomBookings =
        _selectedRooms.entries.where((entry) => entry.value > 0).map((entry) {
          final room = _rooms.firstWhere((r) => r.id == entry.key);
          return RoomBooking(room: room, quantity: entry.value);
        }).toList();

    if (selectedRoomBookings.isEmpty) {
      CustomSnackbar.show(
        context,
        message: AppLocalizations.of(context)!.pleaseSelectAtLeastOneRoom,
        type: SnackbarType.warning,
      );
      return;
    }

    // Calculate total
    final totalCost = selectedRoomBookings.fold<double>(
      0,
      (sum, booking) => sum + booking.totalPrice,
    );

    // Use the first room's cooperation info as the hotel info if available
    // Assuming rooms belong to same hotel in this context or handle multiple hotels logic
    String hotelName = AppLocalizations.of(context)!.continentalHotel;
    String hotelAddress = AppLocalizations.of(context)!.district1Hcm;

    if (selectedRoomBookings.isNotEmpty &&
        selectedRoomBookings.first.room.cooperation != null) {
      hotelName = selectedRoomBookings.first.room.cooperation!.name;
      hotelAddress = selectedRoomBookings.first.room.cooperation!.address ?? '';
    }

    final booking = HotelBooking(
      hotelName: hotelName,
      hotelAddress: hotelAddress,
      selectedRooms: selectedRoomBookings,
      totalCost: totalCost,
      numberOfNights: 1, // Logic to be improved later
    );

    Navigator.of(
      context,
    ).pushNamed(AppRouteConstant.hotelBookingInfo, arguments: booking);
  }

  double _getTotalPrice() {
    return _selectedRooms.entries.fold<double>(0, (sum, entry) {
      final room = _rooms.firstWhere((r) => r.id == entry.key);
      return sum + (room.price * entry.value);
    });
  }

  int _getTotalRooms() {
    return _selectedRooms.values.fold(0, (sum, quantity) => sum + quantity);
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = _getTotalPrice();
    final totalRooms = _getTotalRooms();

    return BlocProvider(
      create: (context) => _findHotelCubit,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.selectRoom,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: BlocConsumer<FindHotelCubit, FindHotelState>(
          listener: (context, state) {
            if (state is FindHotelFailure) {
              CustomSnackbar.show(
                context,
                message: state.message,
                type: SnackbarType.error,
              );
            } else if (state is FindHotelSuccess) {
              setState(() {
                // Extract all rooms from all hotels
                _rooms = state.hotels.expand((hotel) => hotel.rooms).toList();
              });
            }
          },
          builder: (context, state) {
            if (state is FindHotelLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_rooms.isEmpty && state is! FindHotelLoading) {
              return Center(
                child: Text(AppLocalizations.of(context)!.noRoomsFound),
              );
            }

            return Column(
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
                                  '$totalRooms ${AppLocalizations.of(context)!.roomsLower}',
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
            );
          },
        ),
      ),
    );
  }
}
