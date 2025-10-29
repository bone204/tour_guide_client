import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/car_rental/presentation/widgets/bill_info_item.widget.dart';
import 'package:tour_guide_app/features/car_rental/presentation/widgets/payment_method_selector.widget.dart';
import 'package:tour_guide_app/features/car_rental/presentation/widgets/reward_point_selector.widget.dart';

class MotorbikeBillPage extends StatefulWidget {
  const MotorbikeBillPage({super.key});

  @override
  State<MotorbikeBillPage> createState() => _MotorbikeBillPageState();
}

class _MotorbikeBillPageState extends State<MotorbikeBillPage> {
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

    final totalAmount = 300_000.0;
    final totalAfterPoint =
        (totalAmount - travelPointToUse).clamp(0, totalAmount);

    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)?.rentalInfo ?? 'Thông tin thuê xe máy',
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
              child: Image.asset(
                AppImage.defaultCar,
                fit: BoxFit.contain,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(height: 2.h, color: AppColors.primaryGrey),
                  SizedBox(height: 8.h),
                  BillInfo(
                      label: AppLocalizations.of(context)!.customers,
                      value: "Nguyễn Văn A"),
                  BillInfo(
                      label: AppLocalizations.of(context)!.phone,
                      value: "0909123456"),
                  BillInfo(
                      label: AppLocalizations.of(context)!.owner,
                      value: "Trần Văn B"),
                  BillInfo(
                      label: AppLocalizations.of(context)!.phone,
                      value: "0987765432"),
                  SizedBox(height: 8.h),
                  Divider(height: 2.h, color: AppColors.primaryGrey),
                  SizedBox(height: 8.h),
                  BillInfo(
                      label: AppLocalizations.of(context)!.rentalDays,
                      value: "3"),
                  BillInfo(
                      label: AppLocalizations.of(context)!.pricePerDay,
                      value: Formatter.currency(100000)),
                  SizedBox(height: 8.h),
                  Divider(height: 2.h, color: AppColors.primaryGrey),
                  SizedBox(height: 16.h),

                  if (travelPoint > 0) ...[
                    RewardPointSelector(
                      travelPoint: travelPoint,
                      travelPointToUse: travelPointToUse,
                      onChanged: (value) =>
                          setState(() => travelPointToUse = value),
                    ),
                    SizedBox(height: 16.h),
                  ],

                  BillInfo(
                    label: AppLocalizations.of(context)!.subtotal,
                    value: Formatter.currency(totalAmount),
                  ),
                  if (travelPointToUse > 0)
                    BillInfo(
                      label: AppLocalizations.of(context)!.discountPoint,
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
                    AppLocalizations.of(context)!.choosePayment,
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
                    title: AppLocalizations.of(context)!.rent,
                    onPressed: () {},
                    backgroundColor: AppColors.primaryBlue,
                    textColor: AppColors.textSecondary,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

