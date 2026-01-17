import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/constants/app_default_image.constant.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/widgets/contact_info_form.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/core/utils/date_formatter.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/get_rental_bill_detail/get_rental_bill_detail_cubit.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/get_rental_bill_detail/rental_bill_detail_state.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/widgets/rental_bill_detail_shimmer.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/utils/rental_status_helper.dart';
import 'package:dropdown_button2/dropdown_button2.dart'; // Add this
import 'package:tour_guide_app/features/home/presentation/bloc/get_vouchers/get_vouchers_cubit.dart'; // Add this
import 'package:tour_guide_app/features/home/presentation/bloc/get_vouchers/get_vouchers_state.dart'; // Add this
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_cubit.dart'; // Add this
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_state.dart'; // Add this
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/rental_payment/rental_payment_cubit.dart'; // Add this
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/rental_payment/rental_payment_state.dart'; // Add this
import 'package:tour_guide_app/features/voucher/data/models/voucher.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/rental_workflow/rental_workflow_cubit.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/rental_workflow/rental_workflow_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tour_guide_app/core/events/app_events.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';

import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/service_locator.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tour_guide_app/common/pages/selfie_camera.page.dart';

import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/cancel_rental_bill/cancel_rental_bill_cubit.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/cancel_rental_bill/cancel_rental_bill_state.dart';
import 'package:tour_guide_app/common/widgets/dialog/custom_dialog.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';

class RentalBillDetailPage extends StatelessWidget {
  final int id;

  const RentalBillDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => sl<GetRentalBillDetailCubit>()..getBillDetail(id),
        ),
        BlocProvider(
          create: (context) => sl<GetVouchersCubit>()..getVouchers(),
        ),
        BlocProvider(
          create: (context) => sl<GetMyProfileCubit>()..getMyProfile(),
        ),
        BlocProvider(
          create:
              (context) => RentalPaymentCubit(
                updateRentalBillUseCase: sl(),
                payRentalBillUseCase: sl(),
                confirmQrPaymentUseCase: sl(),
              ),
        ),
        BlocProvider(
          create:
              (context) => RentalWorkflowCubit(
                userPickupUseCase: sl(),
                userReturnRequestUseCase: sl(),
              ),
        ),
        BlocProvider(create: (context) => sl<CancelRentalBillCubit>()),
      ],
      child: _RentalBillContent(id: id),
    );
  }
}

class _RentalBillContent extends StatefulWidget {
  final int id;
  const _RentalBillContent({required this.id});

  @override
  State<_RentalBillContent> createState() => _RentalBillContentState();
}

class _RentalBillContentState extends State<_RentalBillContent> {
  final RefreshController _refreshController = RefreshController();
  bool _isActionLoading = false;
  StreamSubscription? _subscription;
  Timer? _paymentPollingTimer;

  @override
  void initState() {
    super.initState();
    _subscription = eventBus.on<RentalSocketNotificationReceivedEvent>().listen(
      (event) {
        if (mounted) {
          _onRefresh(context);
        }
      },
    );
  }

  @override
  void dispose() {
    _paymentPollingTimer?.cancel();
    _subscription?.cancel();
    super.dispose();
  }

  void _onRefresh(BuildContext context) {
    context.read<GetRentalBillDetailCubit>().getBillDetail(widget.id);
  }

  void _startPaymentPolling() {
    _paymentPollingTimer?.cancel();
    // Poll every 5 seconds
    _paymentPollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        context.read<GetRentalBillDetailCubit>().refreshBillDetail(widget.id);
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
          title: AppLocalizations.of(context)!.rentalBillDetail,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<GetRentalBillDetailCubit, RentalBillDetailState>(
              listener: (context, state) {
                if (state.status == RentalBillDetailInitStatus.success ||
                    state.status == RentalBillDetailInitStatus.failure) {
                  _refreshController.refreshCompleted();
                }

                if (state.status == RentalBillDetailInitStatus.success &&
                    state.bill?.status == RentalBillStatus.paid) {
                  if (_paymentPollingTimer != null &&
                      _paymentPollingTimer!.isActive) {
                    _paymentPollingTimer?.cancel();
                    CustomSnackbar.show(
                      context,
                      message: AppLocalizations.of(context)!.paymentSuccess,
                      type: SnackbarType.success,
                    );
                    // If we are showing a dialog (like QR code), we might want to pop it.
                    // However, managing dialog state is tricky. User can close it.
                    eventBus.fire(RentalBillUpdatedEvent(billId: widget.id));
                  }
                }
              },
            ),
            BlocListener<RentalWorkflowCubit, RentalWorkflowState>(
              listener: (context, state) {
                if (state.status == RentalWorkflowStatus.success) {
                  eventBus.fire(RentalBillUpdatedEvent(billId: widget.id));

                  String message = AppLocalizations.of(context)!.actionSuccess;
                  if (state.action == RentalWorkflowAction.pickup) {
                    message = AppLocalizations.of(context)!.rentalPickupSuccess;
                  } else if (state.action ==
                      RentalWorkflowAction.returnRequest) {
                    message =
                        AppLocalizations.of(
                          context,
                        )!.rentalReturnRequestSuccess;
                  }

                  CustomSnackbar.show(
                    context,
                    message: message,
                    type: SnackbarType.success,
                  );
                  _onRefresh(context);
                } else if (state.status == RentalWorkflowStatus.failure) {
                  CustomSnackbar.show(
                    context,
                    message:
                        state.errorMessage ??
                        AppLocalizations.of(context)!.errorOccurred,
                    type: SnackbarType.error,
                  );
                }
              },
            ),
            BlocListener<CancelRentalBillCubit, CancelRentalBillState>(
              listener: (context, state) {
                if (state is CancelRentalBillSuccess) {
                  Navigator.pop(context); // Close dialog
                  CustomSnackbar.show(
                    context,
                    message: AppLocalizations.of(context)!.cancelSuccess,
                    type: SnackbarType.success,
                  );
                  _onRefresh(context);
                  eventBus.fire(RentalBillUpdatedEvent(billId: widget.id));
                } else if (state is CancelRentalBillFailure) {
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
          child: BlocConsumer<GetRentalBillDetailCubit, RentalBillDetailState>(
            listener: (context, state) {
              if (state.status == RentalBillDetailInitStatus.success &&
                  state.bill != null) {
                context.read<RentalPaymentCubit>().init(state.bill!);
              }
            },
            builder: (context, state) {
              if (state.status == RentalBillDetailInitStatus.loading) {
                return const RentalBillDetailShimmer();
              } else if (state.status == RentalBillDetailInitStatus.failure &&
                  state.bill == null) {
                return Center(child: Text(state.errorMessage ?? 'Error'));
              } else if (state.bill != null) {
                final bill = state.bill!;
                // Assume single vehicle flow as per user request
                final RentalVehicle? vehicle =
                    bill.details.isNotEmpty ? bill.details.first.vehicle : null;
                final String licensePlate =
                    bill.details.isNotEmpty
                        ? bill.details.first.licensePlate
                        : '';

                return SmartRefresher(
                  controller: _refreshController,
                  onRefresh: () => _onRefresh(context),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        // 1. Vehicle Info Card
                        _buildVehicleInfoCard(
                          context,
                          vehicle,
                          licensePlate,
                          bill,
                        ),
                        SizedBox(height: 16.h),

                        // 2. Owner Info Card
                        if (vehicle?.contract != null)
                          Column(
                            children: [
                              _buildOwnerInfoCard(context, vehicle!.contract!),
                              SizedBox(height: 16.h),
                            ],
                          ),

                        // 3. Rental Details (Status, Dates, etc.)
                        _buildRentalDetailsCard(context, bill),
                        SizedBox(height: 16.h),

                        ContactInfoForm(bill: bill),
                        SizedBox(height: 16.h),
                        // 4. Payment Details
                        if (bill.status != RentalBillStatus.cancelled)
                          _buildPaymentDetailsCard(context, bill),

                        // 5. Tracking Images
                        _buildTrackingImagesCard(context, bill),

                        SizedBox(height: 32.h),
                        // 5. Workflow Actions
                        _buildWorkflowActions(context, bill),

                        // 4. Contact/Notes if any
                        // 4. Contact Info Update
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

  Widget _buildVehicleInfoCard(
    BuildContext context,
    RentalVehicle? vehicle,
    String licensePlate,
    RentalBill bill,
  ) {
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
            child: Image.network(
              vehicle?.vehicleCatalog?.photo ?? AppImage.defaultCar,
              width: 80.w,
              height: 80.w,
              fit: BoxFit.contain,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    width: 80.w,
                    height: 80.w,
                    color: AppColors.primaryGrey.withOpacity(0.2),
                    child: const Icon(Icons.broken_image),
                  ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle != null
                      ? "${vehicle.vehicleCatalog?.brand} ${vehicle.vehicleCatalog?.model}"
                      : AppLocalizations.of(context)!.rentalVehicle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGrey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(
                          color: AppColors.primaryBlack.withOpacity(0.1),
                        ),
                      ),
                      child: Text(
                        licensePlate,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlack,
                        ),
                      ),
                    ),
                    const Spacer(),
                    _buildStatusBadge(context, bill),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, RentalBill bill) {
    final (color, text) = RentalStatusHelper.getStatusColorAndText(
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

  Widget _buildOwnerInfoCard(BuildContext context, Contract contract) {
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
            AppLocalizations.of(context)!.ownerInfo,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const Divider(),
          _buildDetailRow(
            context,
            AppLocalizations.of(context)!.fullName,
            contract.fullName,
          ),
          _buildDetailRow(
            context,
            AppLocalizations.of(context)!.phoneNumber,
            contract.phoneNumber,
          ),
          if (contract.businessAddress.isNotEmpty)
            _buildDetailRow(
              context,
              AppLocalizations.of(context)!.address,
              contract.businessAddress,
            ),
        ],
      ),
    );
  }

  Widget _buildRentalDetailsCard(BuildContext context, RentalBill bill) {
    final (statusColor, statusText) = RentalStatusHelper.getStatusColorAndText(
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
            AppLocalizations.of(context)!.rentalInfo,
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
            AppLocalizations.of(context)!.duration,
            bill.durationPackage ?? '',
          ),
          _buildDetailRow(
            context,
            AppLocalizations.of(context)!.startDate,
            DateFormatter.formatDateTime(bill.startDate),
          ),
          _buildDetailRow(
            context,
            AppLocalizations.of(context)!.endDate,
            DateFormatter.formatDateTime(bill.endDate),
          ),
          if (bill.location != null)
            _buildDetailRow(
              context,
              AppLocalizations.of(context)!.pickupLocation,
              bill.location!,
            ),
        ],
      ),
    );
  }

  Widget _buildTrackingImagesCard(BuildContext context, RentalBill bill) {
    final sections = <(String, List<String>)>[];

    if (bill.deliveryPhotos.isNotEmpty) {
      sections.add((
        AppLocalizations.of(context)!.deliveryPhotos,
        bill.deliveryPhotos,
      ));
    }
    if (bill.pickupSelfiePhoto != null) {
      sections.add((
        AppLocalizations.of(context)!.pickupPhotos,
        [bill.pickupSelfiePhoto!],
      ));
    }
    if (bill.returnPhotosUser.isNotEmpty) {
      sections.add((
        "${AppLocalizations.of(context)!.returnPhotos} (${AppLocalizations.of(context)!.customer})",
        bill.returnPhotosUser,
      ));
    }
    if (bill.returnPhotosOwner.isNotEmpty) {
      sections.add((
        "${AppLocalizations.of(context)!.returnPhotos} (${AppLocalizations.of(context)!.owner})",
        bill.returnPhotosOwner,
      ));
    }

    if (sections.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: 16.h),
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
            AppLocalizations.of(context)!.trackingPhotos,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const Divider(),
          SizedBox(height: 16.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.85,
            ),
            itemCount: sections.length,
            itemBuilder: (context, index) {
              final section = sections[index];
              return _buildGridImageItem(context, section.$1, section.$2);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGridImageItem(
    BuildContext context,
    String title,
    List<String> images,
  ) {
    // If multiple images, we show the first one big, or a mini grid?
    // User emphasized "1 image each", so we optimize for 1 image.
    // If multiple, maybe show a stack or just the first one with indicator.
    final firstImage = images.first;
    final count = images.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSubtitle,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: GestureDetector(
            onTap: () => _showFullScreenImage(context, firstImage),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    firstImage,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          color: AppColors.primaryGrey.withOpacity(0.2),
                          child: const Icon(Icons.broken_image),
                        ),
                  ),
                ),
                if (count > 1)
                  Positioned(
                    right: 4,
                    bottom: 4,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        '+${count - 1}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            child: Stack(
              alignment: Alignment.center,
              children: [
                InteractiveViewer(
                  minScale: 0.1,
                  maxScale: 5.0,
                  child: Image.network(imageUrl),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildPaymentDetailsCard(BuildContext context, RentalBill bill) {
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
          if (bill.status == RentalBillStatus.paid) ...[
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
          if (bill.status == RentalBillStatus.pending) ...[
            const Divider(),
            _buildPaymentForm(context),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentForm(BuildContext context) {
    return BlocBuilder<RentalPaymentCubit, RentalPaymentState>(
      builder: (context, paymentState) {
        return Column(
          children: [
            // 1. Payment Method Dropdown
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
                        width:
                            1.w, // Changed to 1.w to look cleaner or match 2.w if preferred
                      ),
                    ),
                  ),
                  hint: Text(
                    AppLocalizations.of(context)!.choosePayment,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  value: paymentState.paymentMethod,
                  items:
                      PaymentMethod.values
                          .map(
                            (item) => DropdownMenuItem<PaymentMethod>(
                              value: item,
                              child: Text(
                                item.name.toUpperCase(),
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          )
                          .toList(),
                  validator: (value) {
                    if (value == null) {
                      return AppLocalizations.of(context)!.fieldRequired(
                        AppLocalizations.of(context)!.paymentMethod,
                      );
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value != null) {
                      context.read<RentalPaymentCubit>().selectPaymentMethod(
                        value,
                      );
                    }
                  },
                  onSaved: (value) {},
                  buttonStyleData: ButtonStyleData(
                    height: 48.h,
                    padding: EdgeInsets.only(right: 8.w),
                  ),
                  iconStyleData: IconStyleData(
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.black54,
                    ),
                    iconSize: 24.sp,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.white,
                    ),
                  ),
                  menuItemStyleData: MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // 2. Voucher Dropdown
            BlocBuilder<GetVouchersCubit, GetVouchersState>(
              builder: (context, voucherState) {
                var vouchers = <Voucher>[];
                if (voucherState is GetVouchersLoaded) {
                  vouchers = voucherState.vouchers;
                }

                // Safely determine current value
                Voucher? dropdownValue = paymentState.selectedVoucher;
                if (dropdownValue != null &&
                    !vouchers.contains(dropdownValue)) {
                  dropdownValue = null;
                }

                String hintText = AppLocalizations.of(context)!.selectVoucher;
                if (voucherState is GetVouchersLoading) {
                  hintText = AppLocalizations.of(context)!.loading;
                } else if (vouchers.isEmpty) {
                  hintText = AppLocalizations.of(context)!.noVouchersAvailable;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Voucher",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(height: 6.h),
                    DropdownButtonFormField2<Voucher>(
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
                      hint: Text(hintText, style: TextStyle(fontSize: 14.sp)),
                      value: dropdownValue,
                      items:
                          vouchers
                              .map(
                                (item) => DropdownMenuItem<Voucher>(
                                  value: item,
                                  child: Text(
                                    "${item.code} - ${item.description ?? ''}",
                                    style: TextStyle(fontSize: 14.sp),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged:
                          vouchers.isEmpty
                              ? null
                              : (value) {
                                context
                                    .read<RentalPaymentCubit>()
                                    .selectVoucher(value);
                              },
                      buttonStyleData: ButtonStyleData(
                        height: 48.h,
                        padding: EdgeInsets.only(right: 8.w),
                      ),
                      iconStyleData: IconStyleData(
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.black54,
                        ),
                        iconSize: 24.sp,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Colors.white,
                        ),
                      ),
                      menuItemStyleData: MenuItemStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 16.h),

            // 3. Travel Points
            BlocBuilder<GetMyProfileCubit, GetMyProfileState>(
              builder: (context, profileState) {
                int points = 0;
                if (profileState is GetMyProfileSuccess) {
                  points = profileState.user.travelPoint;
                }
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${AppLocalizations.of(context)!.useRewardPoint} ($points ${AppLocalizations.of(context)!.available})", // Using 'available' key if exists?
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Switch(
                      value: paymentState.useTravelPoints,
                      onChanged: (value) {
                        context
                            .read<RentalPaymentCubit>()
                            .toggleUseTravelPoints(value, points);
                      },
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 16.h),
            // 4. Final Price
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.finalPrice,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  Formatter.currency(paymentState.finalPrice),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
            if (paymentState.voucherDiscount > 0)
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.voucherDiscount,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      "- ${Formatter.currency(paymentState.voucherDiscount)}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ],
                ),
              ),
            if (paymentState.pointDiscount > 0)
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.pointDiscount,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      "- ${Formatter.currency(paymentState.pointDiscount)}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 24.h),
            _buildPayButton(context, paymentState),
          ],
        );
      },
    );
  }

  Widget _buildPayButton(BuildContext context, RentalPaymentState state) {
    final bool isInfoComplete =
        state.contactName != null &&
        state.contactName!.isNotEmpty &&
        state.contactPhone != null &&
        state.contactPhone!.isNotEmpty &&
        state.paymentMethod != null;

    return BlocConsumer<RentalPaymentCubit, RentalPaymentState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == RentalPaymentStatus.success &&
            state.payUrl != null) {
          // Fire event to update list
          eventBus.fire(RentalBillUpdatedEvent(billId: widget.id));

          if (state.payUrl!.startsWith('data:image')) {
            _showQRCodeDialog(context, state.payUrl!);
          } else {
            _launchUrl(context, state.payUrl!);
          }
          _startPaymentPolling();
        } else if (state.status == RentalPaymentStatus.failure) {
          CustomSnackbar.show(
            context,
            message:
                state.errorMessage ??
                AppLocalizations.of(context)!.paymentFailed,
            type: SnackbarType.error,
          );
        }
      },
      builder: (context, state) {
        return PrimaryButton(
          title:
              AppLocalizations.of(
                context,
              )!.payNow, // Ensure "payNow" key exists
          isLoading: state.status == RentalPaymentStatus.loading,
          onPressed:
              isInfoComplete
                  ? () => context.read<RentalPaymentCubit>().payBill()
                  : null,
        );
      },
    );
  }

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        CustomSnackbar.show(
          context,
          message: AppLocalizations.of(context)!.paymentGatewayError,
          type: SnackbarType.error,
        );
      }
    }
  }

  void _showQRCodeDialog(BuildContext context, String base64Image) {
    // Extract base64 part
    final String base64Str = base64Image.split(',').last;
    final bytes = base64Decode(base64Str);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Center(
              child: Text(
                AppLocalizations.of(context)!.paymentQRCode,
                style: Theme.of(context).textTheme.titleLarge,
              ),
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
                Text(
                  AppLocalizations.of(context)!.scanToPay,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(color: AppColors.textSubtitle),
          ),
          SizedBox(width: 16.w),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: valueColor ?? AppColors.primaryBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkflowActions(BuildContext context, RentalBill bill) {
    return BlocBuilder<RentalWorkflowCubit, RentalWorkflowState>(
      builder: (context, state) {
        final isLoading =
            _isActionLoading || state.status == RentalWorkflowStatus.loading;

        if (bill.rentalStatus == RentalProgressStatus.delivered) {
          return Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: PrimaryButton(
              title: AppLocalizations.of(context)!.rentalCheckIn,
              isLoading: isLoading,
              onPressed: isLoading ? null : () => _onPickup(context, bill.id),
            ),
          );
        }
        if (bill.rentalStatus == RentalProgressStatus.inProgress) {
          return Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: PrimaryButton(
              title: AppLocalizations.of(context)!.rentalCheckOut,
              isLoading: isLoading,
              onPressed: isLoading ? null : () => _onReturn(context, bill.id),
            ),
          );
        }
        if (bill.status == RentalBillStatus.pending) {
          return _buildCancelButton(context, bill, isLoading);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Future<void> _onPickup(BuildContext context, int id) async {
    final XFile? photo = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelfieCameraPage()),
    );

    if (photo == null) return;

    setState(() => _isActionLoading = true);
    try {
      if (context.mounted) {
        await context.read<RentalWorkflowCubit>().pickupVehicle(
          id,
          File(photo.path),
        );
      }
    } finally {
      if (mounted) setState(() => _isActionLoading = false);
    }
  }

  Future<void> _onReturn(BuildContext context, int id) async {
    // 1. Check/Request GPS
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        CustomSnackbar.show(
          context,
          message:
              AppLocalizations.of(context)!.locationPermissionDeniedForever,
          type: SnackbarType.error,
        );
      }
      return;
    }

    final source = await _showImageSourceActionSheet(context);
    if (source == null) return;

    setState(() => _isActionLoading = true);
    try {
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition();
      } catch (e) {
        // Handle error? For now proceed or return
      }

      final ImagePicker picker = ImagePicker();
      List<XFile> photos = [];

      if (source == ImageSource.camera) {
        final XFile? photo = await picker.pickImage(source: ImageSource.camera);
        if (photo != null) {
          photos.add(photo);
        }
      } else {
        photos = await picker.pickMultiImage();
      }

      if (photos.isNotEmpty && context.mounted) {
        if (position == null) {
          try {
            position = await Geolocator.getCurrentPosition();
          } catch (e) {
            if (context.mounted) {
              CustomSnackbar.show(
                context,
                message: AppLocalizations.of(
                  context,
                )!.locationError(e.toString()),
                type: SnackbarType.error,
              );
            }
            return;
          }
        }

        await context.read<RentalWorkflowCubit>().returnRequest(
          id,
          photos.map((e) => File(e.path)).toList(),
          position.latitude,
          position.longitude,
        );
      }
    } finally {
      if (mounted) setState(() => _isActionLoading = false);
    }
  }

  Widget _buildCancelButton(
    BuildContext context,
    RentalBill bill,
    bool isLoading,
  ) {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButton(
        title: AppLocalizations.of(context)!.cancel,
        backgroundColor: AppColors.primaryRed,
        isLoading: isLoading,
        onPressed: isLoading ? null : () => _onCancelBill(context, bill.id),
      ),
    );
  }

  void _onCancelBill(BuildContext context, int id) {
    final reasonController = TextEditingController();
    showAppDialog(
      context: context,
      title: AppLocalizations.of(context)!.cancelBill,
      contentWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.confirmCancelBill,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            controller: reasonController,
            placeholder: AppLocalizations.of(context)!.reason(''),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                title: AppLocalizations.of(context)!.cancel,
                backgroundColor: AppColors.primaryGrey.withOpacity(0.2),
                textColor: AppColors.primaryBlack,
                onPressed: () => Navigator.pop(context),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: PrimaryButton(
                title: AppLocalizations.of(context)!.confirm,
                backgroundColor: AppColors.primaryRed,
                onPressed: () {
                  final reason = reasonController.text.trim();
                  if (reason.length < 10) {
                    CustomSnackbar.show(
                      context,
                      message:
                          AppLocalizations.of(context)!.cancelReasonTooShort,
                      type: SnackbarType.error,
                      onTop: true,
                    );
                    return;
                  }
                  Navigator.pop(context);
                  context.read<CancelRentalBillCubit>().cancelBill(id, reason);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<ImageSource?> _showImageSourceActionSheet(BuildContext context) async {
    if (Platform.isIOS) {
      return showCupertinoModalPopup<ImageSource>(
        context: context,
        builder:
            (context) => CupertinoActionSheet(
              title: Text(AppLocalizations.of(context)!.selectImageSource),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                  child: Text(AppLocalizations.of(context)!.camera),
                ),
                CupertinoActionSheetAction(
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                  child: Text(AppLocalizations.of(context)!.gallery),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.pop(context),
                isDestructiveAction: true,
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
            ),
      );
    } else {
      return showModalBottomSheet<ImageSource>(
        context: context,
        builder:
            (context) => SafeArea(
              child: Wrap(
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: Text(AppLocalizations.of(context)!.camera),
                    onTap: () => Navigator.pop(context, ImageSource.camera),
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: Text(AppLocalizations.of(context)!.gallery),
                    onTap: () => Navigator.pop(context, ImageSource.gallery),
                  ),
                ],
              ),
            ),
      );
    }
  }
}
