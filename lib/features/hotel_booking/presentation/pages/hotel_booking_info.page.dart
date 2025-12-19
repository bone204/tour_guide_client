import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/car_rental/presentation/widgets/bill_info_item.widget.dart';
import 'package:tour_guide_app/features/car_rental/presentation/widgets/payment_method_selector.widget.dart';
import 'package:tour_guide_app/features/car_rental/presentation/widgets/reward_point_selector.widget.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel_booking.dart';

class HotelBookingInfoPage extends StatefulWidget {
  final HotelBooking hotelBooking;

  const HotelBookingInfoPage({super.key, required this.hotelBooking});

  @override
  State<HotelBookingInfoPage> createState() => _HotelBookingInfoPageState();
}

class _HotelBookingInfoPageState extends State<HotelBookingInfoPage> {
  String? selectedBank;
  int travelPoint = 5000;
  int travelPointToUse = 0;

  final List<Map<String, String>> bankOptions = [
    {'id': 'visa', 'image': AppImage.visa},
    {'id': 'mastercard', 'image': AppImage.mastercard},
    {'id': 'paypal', 'image': AppImage.paypal},
    {'id': 'momo', 'image': AppImage.momo},
    {'id': 'zalopay', 'image': AppImage.zalopay},
    {'id': 'shopee', 'image': AppImage.shopee},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final booking = widget.hotelBooking;

    final totalAmount = booking.totalCost;
    final totalAfterPoint = (totalAmount - travelPointToUse).clamp(
      0,
      totalAmount,
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
              child: Image.asset(AppImage.defaultCar, fit: BoxFit.cover),
            ),

            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel name
                  Text(
                    booking.hotelName ?? AppLocalizations.of(context)!.hotel,
                    style: theme.titleLarge,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    booking.hotelAddress ?? 'TP.HCM',
                    style: theme.bodyMedium?.copyWith(
                      color: AppColors.textSubtitle,
                    ),
                  ),

                  SizedBox(height: 16.h),
                  Divider(height: 2.h, color: AppColors.primaryGrey),
                  SizedBox(height: 8.h),

                  // Guest info (mock data)
                  BillInfo(
                    label: AppLocalizations.of(context)!.customer,
                    value: "Nguyễn Văn A",
                  ),
                  BillInfo(
                    label: AppLocalizations.of(context)!.phoneNumber,
                    value: "0909123456",
                  ),
                  BillInfo(
                    label: AppLocalizations.of(context)!.email,
                    value: "nguyenvana@gmail.com",
                  ),

                  SizedBox(height: 8.h),
                  Divider(height: 2.h, color: AppColors.primaryGrey),
                  SizedBox(height: 8.h),

                  // Booking details
                  BillInfo(
                    label: AppLocalizations.of(context)!.checkIn,
                    value: "14:00 - 01/11/2025",
                  ),
                  BillInfo(
                    label: AppLocalizations.of(context)!.checkOut,
                    value: "12:00 - 03/11/2025",
                  ),
                  BillInfo(
                    label: AppLocalizations.of(context)!.numberOfNights,
                    value: "${booking.numberOfNights ?? 2}",
                  ),

                  SizedBox(height: 8.h),
                  Divider(height: 2.h, color: AppColors.primaryGrey),
                  SizedBox(height: 8.h),

                  // Room details
                  Text(
                    AppLocalizations.of(context)!.selectedRoom,
                    style: theme.titleMedium,
                  ),
                  SizedBox(height: 8.h),
                  ...booking.selectedRooms.map((roomBooking) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${roomBooking.room.name} x${roomBooking.quantity}',
                              style: theme.bodyMedium,
                            ),
                          ),
                          Text(
                            Formatter.currency(roomBooking.totalPrice),
                            style: theme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  SizedBox(height: 8.h),
                  Divider(height: 2.h, color: AppColors.primaryGrey),
                  SizedBox(height: 16.h),

                  // Reward points
                  if (travelPoint > 0) ...[
                    RewardPointSelector(
                      travelPoint: travelPoint,
                      travelPointToUse: travelPointToUse,
                      onChanged:
                          (value) => setState(() => travelPointToUse = value),
                    ),
                    SizedBox(height: 16.h),
                  ],

                  // Price summary
                  BillInfo(
                    label: AppLocalizations.of(context)!.totalRoomPrice,
                    value: Formatter.currency(totalAmount),
                  ),
                  if (travelPointToUse > 0)
                    BillInfo(
                      label: AppLocalizations.of(context)!.discountPointsLabel,
                      value: "-${Formatter.currency(travelPointToUse)}",
                    ),
                  SizedBox(height: 8.h),
                  Divider(height: 2.h, color: AppColors.primaryGrey),
                  SizedBox(height: 8.h),
                  BillInfo(
                    label: AppLocalizations.of(context)!.totalPayment,
                    value: Formatter.currency(totalAfterPoint),
                  ),

                  SizedBox(height: 24.h),

                  // Payment method
                  Text(
                    AppLocalizations.of(context)!.payment,
                    style: theme.titleMedium,
                  ),
                  SizedBox(height: 16.h),
                  PaymentMethodSelector(
                    bankOptions: bankOptions,
                    selectedBank: selectedBank,
                    onSelect: (id) => setState(() => selectedBank = id),
                  ),

                  SizedBox(height: 24.h),

                  // Confirm button
                  PrimaryButton(
                    title: AppLocalizations.of(context)!.confirmBooking,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.bookingSuccess,
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      );
                    },
                    backgroundColor: AppColors.primaryBlue,
                    textColor: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
