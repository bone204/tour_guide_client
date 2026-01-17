import 'dart:async';
import 'dart:convert';
import 'package:tour_guide_app/core/events/app_events.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/constants/app_default_image.constant.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/button/secondary_button.dart';
import 'package:tour_guide_app/core/utils/date_formatter.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/bills/book_hotel/data/models/hotel_bill.dart';
import 'package:tour_guide_app/features/bills/book_hotel/presentation/bloc/get_hotel_bill_detail/get_hotel_bill_detail_cubit.dart';
import 'package:tour_guide_app/features/bills/book_hotel/presentation/utils/hotel_status_helper.dart';
import 'package:tour_guide_app/features/bills/book_hotel/presentation/bloc/hotel_payment/hotel_payment_cubit.dart';
import 'package:tour_guide_app/features/bills/book_hotel/presentation/bloc/cancel_hotel_bill/cancel_hotel_bill_cubit.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tour_guide_app/common/widgets/dialog/custom_dialog.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/features/bills/book_hotel/presentation/widgets/hotel_bill_detail_shimmer.dart';
import 'package:tour_guide_app/features/bills/book_hotel/presentation/widgets/contact_info_form.dart';

class HotelBillDetailPage extends StatelessWidget {
  final int id;

  const HotelBillDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<GetHotelBillDetailCubit>()..getBillDetail(id),
        ),
        BlocProvider(create: (context) => sl<HotelPaymentCubit>()),
        BlocProvider(create: (context) => sl<CancelHotelBillCubit>()),
      ],
      child: _HotelBillContent(id: id),
    );
  }
}

class _HotelBillContent extends StatefulWidget {
  final int id;
  const _HotelBillContent({required this.id});

  @override
  State<_HotelBillContent> createState() => _HotelBillContentState();
}

class _HotelBillContentState extends State<_HotelBillContent> {
  final RefreshController _refreshController = RefreshController();

  Timer? _paymentPollingTimer;

  @override
  void dispose() {
    _paymentPollingTimer?.cancel();
    super.dispose();
  }

  void _onRefresh(BuildContext context) {
    context.read<GetHotelBillDetailCubit>().getBillDetail(widget.id);
  }

  void _showQRCodeDialog(BuildContext context, String base64Image) {
    final String base64Str = base64Image.split(',').last;
    final bytes = base64Decode(base64Str);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Center(
              child: Text(AppLocalizations.of(context)!.paymentQRCode),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryGrey),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.memory(
                      bytes,
                      width: 250.w,
                      height: 250.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(AppLocalizations.of(context)!.scanToPay),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.close),
              ),
            ],
          ),
    ).then((_) {
      if (context.mounted) {
        _onRefresh(context);
      }
    });
  }

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        CustomSnackbar.show(
          context,
          message:
              AppLocalizations.of(
                context,
              )!.paymentGatewayError, // Using localized error if available, matching rental
          type: SnackbarType.error,
        );
      }
    }
  }

  void _startPaymentPolling() {
    _paymentPollingTimer?.cancel();
    _paymentPollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        context.read<GetHotelBillDetailCubit>().refreshBillDetail(widget.id);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.hotelBooking,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<GetHotelBillDetailCubit, HotelBillDetailState>(
              listener: (context, state) {
                if (state.status == HotelBillDetailInitStatus.success ||
                    state.status == HotelBillDetailInitStatus.failure) {
                  _refreshController.refreshCompleted();
                }

                if (state.status == HotelBillDetailInitStatus.success &&
                    state.bill?.status == HotelBillStatus.paid) {
                  if (_paymentPollingTimer != null &&
                      _paymentPollingTimer!.isActive) {
                    _paymentPollingTimer?.cancel();
                    CustomSnackbar.show(
                      context,
                      message: AppLocalizations.of(context)!.paymentSuccess,
                      type: SnackbarType.success,
                    );
                    eventBus.fire(HotelBillUpdatedEvent(billId: widget.id));
                  }
                }

                // Initialize payment cubit with bill data
                if (state.status == HotelBillDetailInitStatus.success &&
                    state.bill != null) {
                  context.read<HotelPaymentCubit>().init(state.bill!);
                }
              },
            ),

            BlocListener<HotelPaymentCubit, HotelPaymentState>(
              listenWhen:
                  (previous, current) => previous.status != current.status,
              listener: (context, state) {
                if (state.status == HotelPaymentStatus.success) {
                  if (state.payUrl != null) {
                    if (state.payUrl!.startsWith('data:image')) {
                      _showQRCodeDialog(context, state.payUrl!);
                    } else {
                      _launchUrl(context, state.payUrl!);
                    }
                  }
                  _onRefresh(context);
                  _startPaymentPolling();
                } else if (state.status == HotelPaymentStatus.failure) {
                  _paymentPollingTimer?.cancel();
                  CustomSnackbar.show(
                    context,
                    message:
                        state.errorMessage ??
                        AppLocalizations.of(context)!.paymentFailed,
                    type: SnackbarType.error,
                  );
                }
              },
            ),
            BlocListener<CancelHotelBillCubit, CancelHotelBillState>(
              listener: (context, state) {
                if (state is CancelHotelBillSuccess) {
                  Navigator.pop(context); // Close dialog
                  CustomSnackbar.show(
                    context,
                    message: AppLocalizations.of(context)!.cancelSuccess,
                    type: SnackbarType.success,
                  );
                  eventBus.fire(HotelBillCancelledEvent(billId: widget.id));
                  _onRefresh(context);
                } else if (state is CancelHotelBillFailure) {
                  Navigator.pop(context); // Close dialog
                  CustomSnackbar.show(
                    context,
                    message: state.message,
                    type: SnackbarType.error,
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<GetHotelBillDetailCubit, HotelBillDetailState>(
            builder: (context, state) {
              if (state.status == HotelBillDetailInitStatus.loading) {
                return const HotelBillDetailShimmer();
              } else if (state.status == HotelBillDetailInitStatus.failure &&
                  state.bill == null) {
                return Center(
                  child: Text(
                    state.errorMessage ?? AppLocalizations.of(context)!.error,
                  ),
                );
              } else if (state.bill != null) {
                final bill = state.bill!;
                return SmartRefresher(
                  controller: _refreshController,
                  onRefresh: () => _onRefresh(context),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        _buildHotelInfoCard(context, bill),
                        SizedBox(height: 16.h),
                        _buildBookingDetailsCard(context, bill),
                        SizedBox(height: 16.h),
                        ContactInfoForm(bill: bill),
                        SizedBox(height: 16.h),
                        if (bill.status != HotelBillStatus.cancelled)
                          _buildPaymentDetailsCard(context, bill),
                        SizedBox(height: 32.h),
                        _buildWorkflowActions(context, bill),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHotelInfoCard(BuildContext context, HotelBill bill) {
    String imageUrl = AppImage.defaultHotel;
    String title = AppLocalizations.of(context)!.hotelBooking;
    if (bill.details.isNotEmpty) {
      final detail = bill.details.first;
      if (detail.room?.cooperation?.photo != null &&
          detail.room!.cooperation!.photo!.isNotEmpty) {
        imageUrl = detail.room!.cooperation!.photo!;
      } else if (detail.room?.photo != null && detail.room!.photo!.isNotEmpty) {
        imageUrl = detail.room!.photo!;
      }
      title = detail.room?.cooperation?.name ?? detail.roomName;
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGrey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child:
                imageUrl.startsWith('http')
                    ? Image.network(
                      imageUrl,
                      width: 80.w,
                      height: 80.w,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => Image.asset(
                            AppImage.defaultHotel,
                            width: 80.w,
                            height: 80.w,
                            fit: BoxFit.cover,
                          ),
                    )
                    : Image.asset(
                      imageUrl,
                      width: 80.w,
                      height: 80.w,
                      fit: BoxFit.cover,
                    ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 8.h),
                _buildStatusBadge(context, bill),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, HotelBill bill) {
    final (color, text) = HotelStatusHelper.getStatusColorAndText(
      context,
      bill,
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 10.sp,
        ),
      ),
    );
  }

  Widget _buildBookingDetailsCard(BuildContext context, HotelBill bill) {
    final (statusColor, statusText) = HotelStatusHelper.getStatusColorAndText(
      context,
      bill,
    );

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGrey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.bookingInfo,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const Divider(),
          _buildDetailRow(
            context,
            AppLocalizations.of(context)!.billCode,
            bill.code,
          ),
          _buildDetailRow(
            context,
            AppLocalizations.of(context)!.status,
            statusText,
            valueColor: statusColor,
            isBold: true,
          ),
          _buildDetailRow(
            context,
            AppLocalizations.of(context)!.checkIn,
            DateFormatter.formatDateTime(bill.checkInDate),
          ),
          _buildDetailRow(
            context,
            AppLocalizations.of(context)!.checkOut,
            DateFormatter.formatDateTime(bill.checkOutDate),
          ),
          _buildDetailRow(
            context,
            AppLocalizations.of(context)!.nights,
            '${bill.nights} ${AppLocalizations.of(context)!.nights.toLowerCase()}',
          ),
          if (bill.details.isNotEmpty) ...[
            SizedBox(height: 8.h),
            const Divider(),
            SizedBox(height: 8.h),
            Text(
              AppLocalizations.of(context)!.roomList,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: 8.h),
            ...bill.details.map(
              (detail) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGrey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail.roomName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.pricePerNight,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            Formatter.currency(detail.pricePerNight),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.total,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            Formatter.currency(detail.total),
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentDetailsCard(BuildContext context, HotelBill bill) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGrey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.payment,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          if (bill.status == HotelBillStatus.paid) ...[
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.totalPayment,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  Formatter.currency(bill.total),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryRed,
                  ),
                ),
              ],
            ),
          ],
          if (bill.status == HotelBillStatus.pending) ...[
            const Divider(),
            _buildPaymentForm(context, bill),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentForm(BuildContext context, HotelBill bill) {
    return BlocBuilder<HotelPaymentCubit, HotelPaymentState>(
      builder: (context, state) {
        final hasContactInfo =
            state.contactName != null &&
            state.contactName!.isNotEmpty &&
            state.contactPhone != null &&
            state.contactPhone!.isNotEmpty &&
            state.paymentMethod != null;

        return Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.paymentMethod,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(height: 6.h),
                DropdownButtonFormField2<PaymentMethod>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: AppColors.secondaryGrey,
                        width: 1.w,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: AppColors.secondaryGrey,
                        width: 1.w,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: AppColors.primaryGrey,
                        width: 1.w,
                      ),
                    ),
                  ),
                  hint: Text(
                    AppLocalizations.of(context)!.choosePayment,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  value: state.paymentMethod,
                  items:
                      PaymentMethod.values
                          .map(
                            (item) => DropdownMenuItem<PaymentMethod>(
                              value: item,
                              child: Text(
                                item.name.toUpperCase(),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          )
                          .toList(),

                  onChanged: (value) {
                    if (value != null) {
                      context.read<HotelPaymentCubit>().selectPaymentMethod(
                        value,
                      );
                    }
                  },
                  buttonStyleData: ButtonStyleData(
                    padding: EdgeInsets.only(right: 8.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  iconStyleData: IconStyleData(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.primaryBlack,
                      size: 24.w,
                    ),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  menuItemStyleData: MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.totalPayment,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  Formatter.currency(bill.total),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryRed,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            PrimaryButton(
              title: AppLocalizations.of(context)!.payNow,
              isLoading: state.status == HotelPaymentStatus.loading,
              onPressed:
                  !hasContactInfo
                      ? null
                      : () => _handlePayment(context, bill, state),
            ),
          ],
        );
      },
    );
  }

  void _handlePayment(
    BuildContext context,
    HotelBill bill,
    HotelPaymentState state,
  ) {
    if (state.paymentMethod == null) return;

    // Trigger payment flow
    context.read<HotelPaymentCubit>().pay(bill.id);

    // If QR, show dialog (omitted for now as specific requirement was just "logic like rental")
    // For now we assume simle payment or direct success update
    // Start polling if needed
  }

  void _showCancelDialog(BuildContext context) {
    final reasonController = TextEditingController();
    final cancelCubit = context.read<CancelHotelBillCubit>();

    showDialog(
      context: context,
      builder:
          (dialogContext) => CustomDialog(
            title: AppLocalizations.of(dialogContext)!.cancel,
            contentWidget: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(dialogContext)!.confirmCancelBill,
                  textAlign: TextAlign.center,
                  style: Theme.of(dialogContext).textTheme.bodyMedium,
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: reasonController,
                  placeholder: AppLocalizations.of(dialogContext)!.reason(''),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              PrimaryButton(
                title: AppLocalizations.of(dialogContext)!.confirm,
                onPressed: () {
                  if (reasonController.text.isNotEmpty) {
                    cancelCubit.cancelBill(widget.id, reasonController.text);
                    Navigator.pop(dialogContext);
                  }
                },
              ),
              SecondaryButton(
                title: AppLocalizations.of(dialogContext)!.close,
                onPressed: () => Navigator.pop(dialogContext),
                borderColor: AppColors.secondaryGrey,
                textColor: AppColors.primaryBlack,
              ),
            ],
          ),
    );
  }

  Widget _buildWorkflowActions(BuildContext context, HotelBill bill) {
    if (bill.status == HotelBillStatus.pending) {
      return BlocBuilder<CancelHotelBillCubit, CancelHotelBillState>(
        builder: (context, state) {
          final isLoading = state is CancelHotelBillLoading;
          return PrimaryButton(
            title: AppLocalizations.of(context)!.cancelBill,
            backgroundColor: AppColors.primaryRed,
            textColor: AppColors.primaryWhite,
            isLoading: isLoading,
            onPressed: isLoading ? null : () => _showCancelDialog(context),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(color: AppColors.textSubtitle),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: valueColor ?? AppColors.primaryBlack,
            ),
          ),
        ],
      ),
    );
  }
}
