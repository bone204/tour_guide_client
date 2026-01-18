import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';
import 'package:tour_guide_app/features/destination_ticket/data/models/create_destination_bill_request.dart';
import 'package:tour_guide_app/features/destination_ticket/presentation/bloc/ticket_booking/ticket_booking_cubit.dart';
import 'package:tour_guide_app/features/destination_ticket/presentation/bloc/ticket_booking/ticket_booking_state.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/car_rental/presentation/widgets/payment_method_selector.widget.dart';
import 'package:tour_guide_app/service_locator.dart';

class TicketBookingPage extends StatefulWidget {
  final Destination destination;

  const TicketBookingPage({super.key, required this.destination});

  @override
  State<TicketBookingPage> createState() => _TicketBookingPageState();
}

class _TicketBookingPageState extends State<TicketBookingPage> {
  late TicketBookingCubit _cubit;
  int _quantity = 1;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  DateTime _visitDate = DateTime.now();
  String _selectedPaymentMethod = 'wallet';

  final List<Map<String, String>> _paymentOptions = [
    {'id': 'wallet', 'image': AppImage.coin}, // Using coin for wallet
    {'id': 'momo', 'image': AppImage.momo},
    {'id': 'zalopay', 'image': AppImage.zalopay},
    {'id': 'visa', 'image': AppImage.visa},
    {'id': 'mastercard', 'image': AppImage.mastercard},
  ];

  @override
  void initState() {
    super.initState();
    _cubit = sl<TicketBookingCubit>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  double get _totalAmount => (widget.destination.ticketPrice ?? 0) * _quantity;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _visitDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _visitDate) {
      setState(() {
        _visitDate = picked;
      });
    }
  }

  void _handleBooking() {
    final request = CreateDestinationBillRequest(
      destinationId: widget.destination.id,
      ticketQuantity: _quantity,
      contactName: _nameController.text,
      contactPhone: _phoneController.text,
      contactEmail: _emailController.text,
      visitDate: DateFormat('yyyy-MM-dd').format(_visitDate),
      paymentMethod: _selectedPaymentMethod,
    );
    _cubit.createBooking(request);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: "Đặt vé",
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: BlocConsumer<TicketBookingCubit, TicketBookingState>(
          listener: (context, state) {
            if (state is TicketBookingSuccess) {
              CustomSnackbar.show(
                context,
                message: "Đặt vé thành công!",
                type: SnackbarType.success,
              );
              Navigator.pop(context);
            }
            if (state is TicketBookingFailure) {
              CustomSnackbar.show(
                context,
                message: state.message,
                type: SnackbarType.error,
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDestinationInfo(),
                  SizedBox(height: 24.h),
                  _buildQuantitySelector(),
                  SizedBox(height: 24.h),
                  _buildContactForm(),
                  SizedBox(height: 24.h),
                  _buildVisitDatePicker(),
                  SizedBox(height: 24.h),
                  _buildPaymentMethodSelector(),
                  SizedBox(height: 32.h),
                  _buildSummaryAndButton(state is TicketBookingLoading),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDestinationInfo() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  (widget.destination.photos != null &&
                          widget.destination.photos!.isNotEmpty)
                      ? widget.destination.photos!.first
                      : "https://via.placeholder.com/80",
                  width: 80.w,
                  height: 80.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80.w,
                    height: 80.w,
                    color: AppColors.primaryGrey.withOpacity(0.3),
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.destination.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.destination.province ?? '',
                      style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "${Formatter.currency(widget.destination.ticketPrice ?? 0)} / vé",
                      style: TextStyle(
                        color: AppColors.primaryOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.destination.openTime != null &&
              widget.destination.closeTime != null) ...[
            SizedBox(height: 12.h),
            const Divider(),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16.sp,
                  color: AppColors.primaryBlue,
                ),
                SizedBox(width: 8.w),
                Text(
                  "Giờ hoạt động: ",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "${widget.destination.openTime} - ${widget.destination.closeTime}",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Phương thức thanh toán",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        PaymentMethodSelector(
          bankOptions: _paymentOptions,
          selectedBank: _selectedPaymentMethod,
          onSelect: (method) {
            setState(() {
              _selectedPaymentMethod = method;
            });
          },
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Số lượng vé",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            IconButton(
              onPressed: _quantity > 1
                  ? () => setState(() => _quantity--)
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text(
              "$_quantity",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () => setState(() => _quantity++),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Thông tin liên hệ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: "Họ và tên",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 12.h),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: "Số điện thoại",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildVisitDatePicker() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Ngày tham quan"),
            Text(DateFormat('dd/MM/yyyy').format(_visitDate)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryAndButton(bool isLoading) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Tổng cộng",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "${_totalAmount.toInt()} đ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryOrange,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: isLoading ? null : _handleBooking,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Thanh toán ngay",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
