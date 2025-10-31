import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/fast_delivery/data/models/delivery_order.dart';
import 'package:tour_guide_app/features/car_rental/presentation/widgets/payment_method_selector.widget.dart';

class FastDeliveryBillPage extends StatefulWidget {
  final DeliveryOrder deliveryOrder;

  const FastDeliveryBillPage({
    super.key,
    required this.deliveryOrder,
  });

  @override
  State<FastDeliveryBillPage> createState() => _FastDeliveryBillPageState();
}

class _FastDeliveryBillPageState extends State<FastDeliveryBillPage> {
  String? selectedPaymentMethod = 'momo';
  
  final List<Map<String, String>> paymentOptions = [
    {'id': 'momo', 'image': AppImage.momo},
    {'id': 'zalopay', 'image': AppImage.zalopay},
    {'id': 'visa', 'image': AppImage.visa},
    {'id': 'mastercard', 'image': AppImage.mastercard},
  ];

  void _confirmPayment() {
    // Show success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: AppColors.primaryGreen,
                size: 64.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Đặt đơn thành công!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Đơn hàng của bạn đã được xác nhận',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSubtitle,
              ),
            ),
          ],
        ),
        actions: [
          PrimaryButton(
            title: 'Về trang chủ',
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            backgroundColor: AppColors.primaryBlue,
            textColor: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.deliveryOrder;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'Xác nhận đơn hàng',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Receiver Info
                  _buildReceiverInfo(order),

                  SizedBox(height: 20.h),

                  // Service Info
                  _buildServiceInfo(order),

                  SizedBox(height: 20.h),

                  // Package Images (if any)
                  if (order.packageImages.isNotEmpty) ...[
                    _buildPackageImages(order.packageImages),
                    SizedBox(height: 20.h),
                  ],

                  // Price Breakdown
                  _buildPriceBreakdown(order),

                  SizedBox(height: 28.h),

                  // Payment Method
                  Text(
                    'Phương thức thanh toán',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                  ),
                  SizedBox(height: 12.h),
                  PaymentMethodSelector(
                    bankOptions: paymentOptions,
                    selectedBank: selectedPaymentMethod,
                    onSelect: (method) {
                      setState(() => selectedPaymentMethod = method);
                    },
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar
          _buildBottomBar(order.totalCost),
        ],
      ),
    );
  }


  Widget _buildReceiverInfo(DeliveryOrder order) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thông tin người nhận',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
          SizedBox(height: 16.h),
          
          // Receiver Name
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: SvgPicture.asset(
                  AppIcons.user,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryWhite,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Họ và tên',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: AppColors.textSubtitle,
                          ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      order.receiverName ?? 'N/A',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Receiver Phone
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: SvgPicture.asset(
                  AppIcons.contact,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryWhite,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Số điện thoại',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: AppColors.textSubtitle,
                          ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      order.receiverPhone ?? 'N/A',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          if (order.specialRequirements != null && order.specialRequirements!.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.note_outlined,
                    size: 24.r,
                    color: AppColors.primaryWhite,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Yêu cầu đặc biệt',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: AppColors.textSubtitle,
                            ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        order.specialRequirements!,
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildServiceInfo(DeliveryOrder order) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thông tin dịch vụ',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
          SizedBox(height: 16.h),
          
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: SvgPicture.asset(
                  AppIcons.delivery,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryWhite,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hãng giao hàng',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: AppColors.textSubtitle,
                          ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      order.shippingProviderName ?? 'N/A',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: SvgPicture.asset(
                  AppIcons.car,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryWhite,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loại xe',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: AppColors.textSubtitle,
                          ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      order.vehicleTypeName ?? 'N/A',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPackageImages(List<String> images) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hình ảnh kiện hàng',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 80.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 12.w),
                  width: 80.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppColors.secondaryGrey,
                      width: 2.w,
                    ),
                    image: DecorationImage(
                      image: FileImage(File(images[index])),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown(DeliveryOrder order) {
    final vehiclePrice = order.vehicleBasePrice ?? 0;
    final distancePrice = order.distance * 5000;
    final total = order.totalCost;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chi tiết giá',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
          SizedBox(height: 12.h),
          _buildPriceRow('Phí xe cơ bản', vehiclePrice),
          SizedBox(height: 8.h),
          _buildPriceRow('Phí theo km (${order.distance.toStringAsFixed(1)} km)', distancePrice),
          SizedBox(height: 12.h),
          Divider(color: AppColors.textSubtitle.withOpacity(0.2), thickness: 2),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng cộng',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
              Text(
                Formatter.currency(total),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primaryBlue,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: AppColors.textSubtitle,
              ),
        ),
        Text(
          Formatter.currency(price),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
              ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(double totalPrice) {
    return Container(
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
                    'Tổng thanh toán',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSubtitle,
                        ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    Formatter.currency(totalPrice),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.primaryBlue,

                        ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: PrimaryButton(
                onPressed: _confirmPayment,
                title: 'Thanh toán',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
