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
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';

import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/service_locator.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

class RentalBillDetailPage extends StatefulWidget {
  final int id;

  const RentalBillDetailPage({super.key, required this.id});

  @override
  State<RentalBillDetailPage> createState() => _RentalBillDetailPageState();
}

class _RentalBillDetailPageState extends State<RentalBillDetailPage> {
  final RefreshController _refreshController = RefreshController();
  bool _isActionLoading = false;

  void _onRefresh(BuildContext context) {
    context.read<GetRentalBillDetailCubit>().getBillDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  sl<GetRentalBillDetailCubit>()..getBillDetail(widget.id),
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
      ],
      child: GestureDetector(
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
                },
              ),
              BlocListener<RentalWorkflowCubit, RentalWorkflowState>(
                listener: (context, state) {
                  if (state.status == RentalWorkflowStatus.success) {
                    CustomSnackbar.show(
                      context,
                      message:
                          state.successMessage ??
                          AppLocalizations.of(context)!.actionSuccess,
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
            ],
            child: BlocConsumer<
              GetRentalBillDetailCubit,
              RentalBillDetailState
            >(
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
                      bill.details.isNotEmpty
                          ? bill.details.first.vehicle
                          : null;
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
                          _buildVehicleInfoCard(context, vehicle, licensePlate),
                          SizedBox(height: 16.h),

                          // 2. Owner Info Card
                          if (vehicle?.contract != null)
                            Column(
                              children: [
                                _buildOwnerInfoCard(
                                  context,
                                  vehicle!.contract!,
                                ),
                                SizedBox(height: 16.h),
                              ],
                            ),

                          // 3. Rental Details (Status, Dates, etc.)
                          _buildRentalDetailsCard(context, bill),
                          SizedBox(height: 16.h),

                          ContactInfoForm(bill: bill),
                          SizedBox(height: 16.h),
                          // 4. Payment Details
                          _buildPaymentDetailsCard(context, bill),
                          SizedBox(height: 16.h),
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
      ),
    );
  }

  Widget _buildVehicleInfoCard(
    BuildContext context,
    RentalVehicle? vehicle,
    String licensePlate,
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
              ],
            ),
          ),
        ],
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
            _getStatusText(context, bill.status),
            valueColor: _getStatusColor(bill.status),
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Voucher", // Assuming 'Voucher' can be static or use 'exclusiveVouchers' or just 'Voucher' as key
                      // Checking arb: 'exclusiveVouchers': 'Exclusive Vouchers'. 'voucher' key??
                      // I added 'selectVoucher'. Let's use 'Voucher' string or add key 'voucher' = 'Voucher'.
                      // For now I'll use "Voucher" title case, or reuse 'exclusiveVouchers' if fitting.
                      // Better to use static "Voucher" or add specific key if strict. User didn't ask for 'Voucher' label key.
                      // Let's use 'Voucher' text for now or 'AppLocalizations.of(context)!.exclusiveVouchers' (might be too long).
                      // Actually I can just use "Voucher".
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
                      hint: Text(
                        AppLocalizations.of(context)!.selectVoucher,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      value: paymentState.selectedVoucher,
                      items:
                          voucherState is GetVouchersLoaded
                              ? voucherState.vouchers
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
                                  .toList()
                              : [],
                      onChanged: (value) {
                        context.read<RentalPaymentCubit>().selectVoucher(value);
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
                        // checked arb: "available": "Available" / "Có sẵn".
                        // Better: "useRewardPoint" ($points points)
                        // arb: "points": "points"
                        // "${AppLocalizations.of(context)!.useRewardPoint} ($points ${AppLocalizations.of(context)!.points})",
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
          if (state.payUrl!.startsWith('data:image')) {
            _showQRCodeDialog(context, state.payUrl!);
          } else {
            _launchUrl(context, state.payUrl!);
          }
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
    );
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

  String _getStatusText(BuildContext context, RentalBillStatus status) {
    switch (status) {
      case RentalBillStatus.pending:
        return AppLocalizations.of(context)!.pending;
      case RentalBillStatus.confirmed:
        return AppLocalizations.of(context)!.approved;
      case RentalBillStatus.paidPendingDelivery:
      case RentalBillStatus.paid:
        return AppLocalizations.of(context)!.paid;
      case RentalBillStatus.cancelled:
        return AppLocalizations.of(context)!.cancelled;
      case RentalBillStatus.completed:
        return AppLocalizations.of(context)!.completed;
    }
  }

  Color _getStatusColor(RentalBillStatus status) {
    switch (status) {
      case RentalBillStatus.pending:
        return Colors.orange;
      case RentalBillStatus.confirmed:
        return AppColors.primaryBlue;
      case RentalBillStatus.paidPendingDelivery:
      case RentalBillStatus.paid:
        return Colors.green;
      case RentalBillStatus.cancelled:
        return AppColors.primaryRed;
      case RentalBillStatus.completed:
        return Colors.teal;
    }
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
        return const SizedBox.shrink();
      },
    );
  }

  Future<void> _onPickup(BuildContext context, int id) async {
    setState(() => _isActionLoading = true);
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
      );
      if (photo != null && context.mounted) {
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
    setState(() => _isActionLoading = true);
    try {
      // 1. Check Permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.locationPermissionRequired,
                ),
              ),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.locationPermissionDeniedForever,
              ),
            ),
          );
        }
        return;
      }

      // 2. Get Location
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.locationError(e.toString()),
              ),
            ),
          );
        }
        return;
      }

      // 3. Pick Photos
      final ImagePicker picker = ImagePicker();
      final List<XFile> photos = await picker.pickMultiImage();

      if (photos.isNotEmpty && context.mounted) {
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
}
