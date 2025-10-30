import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/car_rental/presentation/widgets/bill_info_item.widget.dart';
import 'package:tour_guide_app/features/car_rental/presentation/widgets/payment_method_selector.widget.dart';
import 'package:tour_guide_app/features/car_rental/presentation/widgets/reward_point_selector.widget.dart';

class RestaurantBookingInfoPage extends StatefulWidget {
  const RestaurantBookingInfoPage({super.key});

  @override
  State<RestaurantBookingInfoPage> createState() => _RestaurantBookingInfoPageState();
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

    final depositAmount = 100_000.0;
    final totalAfterPoint =
        (depositAmount - travelPointToUse).clamp(0, depositAmount);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'Thông tin đặt bàn',
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
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nhà hàng Sài Gòn',
                    style: theme.titleLarge,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Món Việt • Quận 1, TP.HCM',
                    style: theme.bodyMedium?.copyWith(color: AppColors.textSubtitle),
                  ),
                  SizedBox(height: 16.h),
                  Divider(height: 2.h, color: AppColors.primaryGrey),
                  SizedBox(height: 8.h),
                  
                  BillInfo(
                    label: 'Khách hàng',
                    value: "Nguyễn Văn A"
                  ),
                  BillInfo(
                    label: 'Số điện thoại',
                    value: "0909123456"
                  ),
                  BillInfo(
                    label: 'Email',
                    value: "nguyenvana@gmail.com"
                  ),
                  
                  SizedBox(height: 8.h),
                  Divider(height: 2.h, color: AppColors.primaryGrey),
                  SizedBox(height: 8.h),
                  
                  BillInfo(
                    label: 'Bàn',
                    value: "Bàn 01"
                  ),
                  BillInfo(
                    label: 'Số người',
                    value: "2 người"
                  ),
                  BillInfo(
                    label: 'Vị trí',
                    value: "Tầng 1 - Gần cửa sổ"
                  ),
                  BillInfo(
                    label: 'Thời gian',
                    value: "18:00 - 30/10/2025"
                  ),
                  
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
                    label: 'Tiền đặt cọc',
                    value: Formatter.currency(depositAmount),
                  ),
                  if (travelPointToUse > 0)
                    BillInfo(
                      label: 'Giảm giá (điểm)',
                      value: "-${Formatter.currency(travelPointToUse)}",
                    ),
                  SizedBox(height: 8.h),
                  Divider(height: 2.h, color: AppColors.primaryGrey),
                  SizedBox(height: 8.h),
                  BillInfo(
                    label: 'Tổng thanh toán',
                    value: Formatter.currency(totalAfterPoint),
                  ),

                  SizedBox(height: 24.h),

                  Text(
                    'Phương thức thanh toán',
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
                    title: 'Xác nhận đặt bàn',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Đặt bàn thành công!'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      );
                    },
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

