import 'package:intl/intl.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/car_rental/presentation/widgets/bill_info_item.widget.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/room.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/features/hotel_booking/presentation/bloc/create_hotel_bill/create_hotel_bill_cubit.dart';
import 'package:tour_guide_app/features/hotel_booking/presentation/bloc/create_hotel_bill/create_hotel_bill_state.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/create_hotel_bill_request.dart';
import 'package:tour_guide_app/service_locator.dart';

class HotelBookingInfoPage extends StatefulWidget {
  final Hotel hotel;
  final List<RoomBooking> selectedRooms;
  final DateTime checkInDate;
  final DateTime checkOutDate;

  const HotelBookingInfoPage({
    super.key,
    required this.hotel,
    required this.selectedRooms,
    required this.checkInDate,
    required this.checkOutDate,
  });

  @override
  State<HotelBookingInfoPage> createState() => _HotelBookingInfoPageState();
}

class _HotelBookingInfoPageState extends State<HotelBookingInfoPage> {
  late TextEditingController _checkInController;
  late TextEditingController _checkOutController;
  late DateTime _checkInDate;
  late DateTime _checkOutDate;
  late List<RoomBooking> _selectedRooms;

  @override
  void initState() {
    super.initState();
    _checkInDate = DateTime(
      widget.checkInDate.year,
      widget.checkInDate.month,
      widget.checkInDate.day,
      14,
      0,
    );
    _checkOutDate = DateTime(
      widget.checkOutDate.year,
      widget.checkOutDate.month,
      widget.checkOutDate.day,
      12,
      0,
    );
    _selectedRooms = List.from(widget.selectedRooms);
    _checkInController = TextEditingController(
      text: DateFormat('dd/MM/yyyy - HH:mm').format(_checkInDate),
    );
    _checkOutController = TextEditingController(
      text: DateFormat('dd/MM/yyyy - HH:mm').format(_checkOutDate),
    );
  }

  @override
  void dispose() {
    _checkInController.dispose();
    _checkOutController.dispose();
    super.dispose();
  }

  Future<void> _selectCheckInDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      final newCheckIn = DateTime(
        picked.year,
        picked.month,
        picked.day,
        14,
        0,
      ); // 14:00

      if (newCheckIn.isAfter(_checkOutDate)) {
        // If check-in is after check-out, reset check-out to check-in + 1 day
        setState(() {
          _checkInDate = newCheckIn;
          _checkOutDate = DateTime(
            newCheckIn.year,
            newCheckIn.month,
            newCheckIn.day + 1,
            12,
            0,
          );
          _checkInController.text = DateFormat(
            'dd/MM/yyyy - HH:mm',
          ).format(_checkInDate);
          _checkOutController.text = DateFormat(
            'dd/MM/yyyy - HH:mm',
          ).format(_checkOutDate);
        });
      } else {
        setState(() {
          _checkInDate = newCheckIn;
          _checkInController.text = DateFormat(
            'dd/MM/yyyy - HH:mm',
          ).format(_checkInDate);
        });
      }
    }
  }

  Future<void> _selectCheckOutDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkOutDate,
      firstDate: _checkInDate.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      final newCheckOut = DateTime(
        picked.year,
        picked.month,
        picked.day,
        12,
        0,
      ); // 12:00

      if (newCheckOut.isBefore(_checkInDate)) {
        CustomSnackbar.show(
          context,
          message: AppLocalizations.of(context)!.checkOutMustBeAfterCheckIn,
          type: SnackbarType.warning,
        );
      } else {
        setState(() {
          _checkOutDate = newCheckOut;
          _checkOutController.text = DateFormat(
            'dd/MM/yyyy - HH:mm',
          ).format(_checkOutDate);
        });
      }
    }
  }

  void _updateRoomQuantity(int index, int change) {
    setState(() {
      final currentBooking = _selectedRooms[index];
      final newQuantity = currentBooking.quantity + change;

      if (newQuantity <= 0) {
        _selectedRooms.removeAt(index);
      } else {
        _selectedRooms[index] = RoomBooking(
          room: currentBooking.room,
          quantity: newQuantity,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    final numberOfNights = _checkOutDate.difference(_checkInDate).inDays;
    final actualNights = numberOfNights > 0 ? numberOfNights : 1;

    final pricePerNight = _selectedRooms.fold<double>(
      0,
      (sum, booking) => sum + booking.totalPrice,
    );
    final totalAmount = pricePerNight * actualNights;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocProvider(
        create: (context) => sl<CreateHotelBillCubit>(),
        child: Scaffold(
          appBar: CustomAppBar(
            title: AppLocalizations.of(context)!.bookingInfo,
            showBackButton: true,
            onBackPressed: () => Navigator.pop(context),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hotel image
                Container(
                  width: double.infinity,
                  height: 236.h,
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  child:
                      widget.hotel.photo != null
                          ? Image.network(
                            widget.hotel.photo!,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, url, error) => Image.asset(
                                  AppImage.defaultHotel,
                                  fit: BoxFit.cover,
                                ),
                          )
                          : Image.asset(
                            AppImage.defaultHotel,
                            fit: BoxFit.cover,
                          ),
                ),

                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hotel name
                      Text(widget.hotel.name, style: theme.titleLarge),
                      SizedBox(height: 8.h),
                      Text(
                        widget.hotel.province ??
                            AppLocalizations.of(context)!.district1Hcm,
                        style: theme.bodyMedium?.copyWith(
                          color: AppColors.textSubtitle,
                        ),
                      ),

                      SizedBox(height: 16.h),
                      Divider(height: 2.h, color: AppColors.primaryGrey),
                      SizedBox(height: 16.h),

                      // Booking details
                      Column(
                        children: [
                          CustomTextField(
                            label: AppLocalizations.of(context)!.checkIn,
                            placeholder: '',
                            controller: _checkInController,
                            readOnly: true,
                            onTap: _selectCheckInDate,
                          ),
                          SizedBox(height: 16.h),
                          CustomTextField(
                            label: AppLocalizations.of(context)!.checkOut,
                            placeholder: '',
                            controller: _checkOutController,
                            readOnly: true,
                            onTap: _selectCheckOutDate,
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 16.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.primaryBlue.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.nights_stay_rounded,
                              color: AppColors.primaryBlue,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "${AppLocalizations.of(context)!.numberOfNights}: ${numberOfNights > 0 ? numberOfNights : 1}",
                              style: theme.titleMedium?.copyWith(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16.h),
                      Divider(height: 2.h, color: AppColors.primaryGrey),
                      SizedBox(height: 8.h),

                      // Room details
                      Text(
                        AppLocalizations.of(context)!.selectedRoom,
                        style: theme.titleMedium,
                      ),
                      SizedBox(height: 8.h),
                      ..._selectedRooms.asMap().entries.map((entry) {
                        final index = entry.key;
                        final roomBooking = entry.value;

                        return Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryWhite,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: AppColors.secondaryGrey),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child:
                                    roomBooking.room.photo != null
                                        ? Image.network(
                                          roomBooking.room.photo!,
                                          width: 80.w,
                                          height: 80.w,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, url, error) =>
                                                  Image.asset(
                                                    AppImage.defaultHotel,
                                                    width: 80.w,
                                                    height: 80.w,
                                                    fit: BoxFit.cover,
                                                  ),
                                        )
                                        : Image.asset(
                                          AppImage.defaultHotel,
                                          width: 80.w,
                                          height: 80.w,
                                          fit: BoxFit.cover,
                                        ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      roomBooking.room.name,
                                      style: theme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w900,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      Formatter.currency(
                                        roomBooking.room.price,
                                      ),
                                      style: theme.bodySmall?.copyWith(
                                        color: AppColors.primaryBlue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap:
                                              () => _updateRoomQuantity(
                                                index,
                                                -1,
                                              ),
                                          child: Container(
                                            padding: EdgeInsets.all(4.w),
                                            decoration: BoxDecoration(
                                              color: AppColors.secondaryGrey
                                                  .withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(4.r),
                                            ),
                                            child: Icon(
                                              Icons.remove,
                                              size: 16.sp,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${roomBooking.quantity}',
                                          style: theme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        InkWell(
                                          onTap:
                                              () =>
                                                  _updateRoomQuantity(index, 1),
                                          child: Container(
                                            padding: EdgeInsets.all(4.w),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryBlue,
                                              borderRadius:
                                                  BorderRadius.circular(4.r),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 16.sp,
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
                      }).toList(),

                      SizedBox(height: 8.h),
                      Divider(height: 2.h, color: AppColors.primaryGrey),
                      SizedBox(height: 16.h),

                      ..._selectedRooms.map((roomBooking) {
                        final itemTotal = roomBooking.totalPrice * actualNights;
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      roomBooking.room.name,
                                      style: theme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      '${Formatter.currency(roomBooking.room.price)} x ${roomBooking.quantity} x $actualNights ${AppLocalizations.of(context)!.nightUnit}',
                                      style: theme.bodySmall?.copyWith(
                                        color: AppColors.textSubtitle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                Formatter.currency(itemTotal),
                                style: theme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      Divider(height: 2.h, color: AppColors.primaryGrey),
                      SizedBox(height: 8.h),
                      BillInfo(
                        label: AppLocalizations.of(context)!.total,
                        value: Formatter.currency(totalAmount),
                      ),
                      SizedBox(height: 16.h),
                      BlocConsumer<CreateHotelBillCubit, CreateHotelBillState>(
                        listener: (context, state) {
                          if (state is CreateHotelBillSuccess) {
                            CustomSnackbar.show(
                              context,
                              message:
                                  AppLocalizations.of(context)!.bookingSuccess,
                              type: SnackbarType.success,
                            );
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              AppRouteConstant.hotelBillList,
                              (route) =>
                                  route.settings.name ==
                                  AppRouteConstant.mainScreen,
                            );
                            Navigator.of(context).pushNamed(
                              AppRouteConstant.hotelBillDetail,
                              arguments: state.billId,
                            );
                          } else if (state is CreateHotelBillFailure) {
                            CustomSnackbar.show(
                              context,
                              message: state.message,
                              type: SnackbarType.error,
                            );
                          }
                        },
                        builder: (context, state) {
                          return PrimaryButton(
                            title: AppLocalizations.of(context)!.confirmBooking,
                            isLoading: state is CreateHotelBillLoading,
                            onPressed: () {
                              final request = CreateHotelBillRequest(
                                checkInDate: _checkInDate.toIso8601String(),
                                checkOutDate: _checkOutDate.toIso8601String(),
                                rooms:
                                    _selectedRooms
                                        .map(
                                          (e) => HotelBillRoomRequest(
                                            roomId: e.room.id,
                                            quantity: e.quantity,
                                          ),
                                        )
                                        .toList(),
                              );
                              context
                                  .read<CreateHotelBillCubit>()
                                  .createHotelBill(request);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
