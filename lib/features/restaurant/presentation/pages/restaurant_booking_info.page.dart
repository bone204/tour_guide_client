import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/car_rental/presentation/widgets/bill_info_item.widget.dart';
import 'package:tour_guide_app/features/car_rental/presentation/widgets/payment_method_selector.widget.dart';
import 'package:tour_guide_app/features/car_rental/presentation/widgets/reward_point_selector.widget.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/features/cooperations/data/models/cooperation.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_table.dart';

class RestaurantBookingInfoPage extends StatefulWidget {
  final Cooperation restaurant;
  final RestaurantTable table;

  const RestaurantBookingInfoPage({
    super.key,
    required this.restaurant,
    required this.table,
  });

  @override
  State<RestaurantBookingInfoPage> createState() =>
      _RestaurantBookingInfoPageState();
}

class _RestaurantBookingInfoPageState extends State<RestaurantBookingInfoPage> {
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

    // Use table price or default deposit
    final double depositAmount =
        widget.table.priceRange != null
            ? widget.table.priceRange!.toDouble()
            : 100000.0;

    final totalAfterPoint = (depositAmount - travelPointToUse).clamp(
      0,
      depositAmount,
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.tableBookingInfo,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 236.h,
              color: AppColors.primaryBlue.withOpacity(0.1),
              child: Image.network(
                widget.restaurant.photo ?? "",
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        Image.asset(AppImage.defaultFood, fit: BoxFit.cover),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.restaurant.name, style: theme.titleLarge),
                  SizedBox(height: 4.h),
                  Text(
                    '${widget.restaurant.address ?? ""} • ${widget.restaurant.province ?? ""}',
                    style: theme.bodyMedium?.copyWith(
                      color: AppColors.textSubtitle,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Divider(height: 2.h, color: AppColors.primaryGrey),
                  SizedBox(height: 8.h),

                  BillInfo(
                    label: AppLocalizations.of(context)!.customer,
                    value: "User Name", // TODO: Get from Auth Profile
                  ),
                  BillInfo(
                    label: AppLocalizations.of(context)!.phoneNumber,
                    value: "0909123456", // TODO: Get from Auth Profile
                  ),

                  // Email removed to save space or add if needed
                  SizedBox(height: 8.h),
                  Divider(height: 2.h, color: AppColors.primaryGrey),
                  SizedBox(height: 8.h),

                  BillInfo(
                    label: AppLocalizations.of(context)!.table,
                    value: widget.table.name,
                  ),
                  BillInfo(
                    label: AppLocalizations.of(context)!.numberOfPeople,
                    value:
                        "${widget.table.guests} ${AppLocalizations.of(context)!.people}",
                  ),
                  if (widget.table.description != null)
                    BillInfo(
                      label: AppLocalizations.of(context)!.description,
                      value: widget.table.description!,
                    ),
                  BillInfo(
                    label: AppLocalizations.of(context)!.time,
                    value:
                        "18:00 - 30/10/2025", // TODO: Pass selected time from previous screen
                  ),

                  SizedBox(height: 8.h),
                  Divider(height: 2.h, color: AppColors.primaryGrey),
                  SizedBox(height: 16.h),

                  if (travelPoint > 0) ...[
                    RewardPointSelector(
                      travelPoint: travelPoint,
                      travelPointToUse: travelPointToUse,
                      onChanged:
                          (value) => setState(() => travelPointToUse = value),
                    ),
                    SizedBox(height: 16.h),
                  ],

                  BillInfo(
                    label: AppLocalizations.of(context)!.deposit,
                    value: Formatter.currency(depositAmount),
                  ),
                  if (travelPointToUse > 0)
                    BillInfo(
                      label:
                          AppLocalizations.of(
                            context,
                          )!.discountPoint, // Fixed key, check arb
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
                  PrimaryButton(
                    title: AppLocalizations.of(context)!.confirmTableBooking,
                    onPressed: () {
                      CustomSnackbar.show(
                        context,
                        message:
                            AppLocalizations.of(context)!.tableBookingSuccess,
                        type: SnackbarType.success,
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
