import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/date_formatter.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/get_rental_bill_detail/get_rental_bill_detail_cubit.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/get_rental_bill_detail/rental_bill_detail_state.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/widgets/rental_bill_detail_shimmer.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/owner_rental_workflow/owner_rental_workflow_cubit.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/owner_rental_workflow/owner_rental_workflow_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';

import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';

class OwnerRentalRequestDetailPage extends StatefulWidget {
  final int id;

  const OwnerRentalRequestDetailPage({super.key, required this.id});

  @override
  State<OwnerRentalRequestDetailPage> createState() =>
      _OwnerRentalRequestDetailPageState();
}

class _OwnerRentalRequestDetailPageState
    extends State<OwnerRentalRequestDetailPage> {
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
          create:
              (context) => OwnerRentalWorkflowCubit(
                ownerDeliveringUseCase: sl(),
                ownerDeliveredUseCase: sl(),
                ownerConfirmReturnUseCase: sl(),
              ),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.rentalRequestDetail,
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
            BlocListener<OwnerRentalWorkflowCubit, OwnerRentalWorkflowState>(
              listener: (context, state) {
                if (state.status == OwnerRentalWorkflowStatus.success) {
                  CustomSnackbar.show(
                    context,
                    message:
                        state.successMessage ??
                        AppLocalizations.of(context)!.actionSuccess,
                    type: SnackbarType.success,
                  );
                  _onRefresh(context);
                } else if (state.status == OwnerRentalWorkflowStatus.failure) {
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
          child: BlocBuilder<GetRentalBillDetailCubit, RentalBillDetailState>(
            builder: (context, state) {
              if (state.status == RentalBillDetailInitStatus.loading) {
                return const RentalBillDetailShimmer();
              } else if (state.status == RentalBillDetailInitStatus.failure &&
                  state.bill == null) {
                return Center(
                  child: Text(
                    state.errorMessage ??
                        AppLocalizations.of(context)!.errorOccurred,
                  ),
                );
              } else if (state.bill != null) {
                final bill = state.bill!;
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
                        // 1. Renter Info
                        _buildVehicleInfoCard(
                          context,
                          vehicle,
                          licensePlate,
                          bill.rentalStatus,
                        ),
                        SizedBox(height: 16.h),

                        // 2. Vehicle Info
                        _buildRenterInfoCard(context, bill),
                        SizedBox(height: 16.h),

                        // 3. Rental Details (Status, Dates, etc.)
                        _buildRentalDetailsCard(context, bill),
                        SizedBox(height: 16.h),

                        // 4. Payment/Revenue Details
                        _buildPaymentDetailsCard(context, bill),
                        SizedBox(height: 16.h),
                        // 5. Workflow Actions
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

  Widget _buildRenterInfoCard(BuildContext context, RentalBill bill) {
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
            AppLocalizations.of(context)!.renterInfo,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const Divider(),
          _buildDetailRow(
            context,
            AppLocalizations.of(context)!.fullName,
            bill.contactName ?? 'Unknown',
          ),
          _buildDetailRow(
            context,
            AppLocalizations.of(context)!.phoneNumber,
            bill.contactPhone ?? 'Unknown',
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleInfoCard(
    BuildContext context,
    RentalVehicle? vehicle,
    String licensePlate,
    RentalProgressStatus status,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        vehicle != null
                            ? "${vehicle.vehicleCatalog?.brand} ${vehicle.vehicleCatalog?.model}"
                            : AppLocalizations.of(context)!.rentalVehicle,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildStatusBadge(context, status),
                  ],
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

  Widget _buildStatusBadge(BuildContext context, RentalProgressStatus status) {
    final color = _getRentalStatusColor(status);
    final text = _getRentalStatusText(context, status);

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
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.totalRevenue,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                Formatter.currency(bill.total),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
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
                fontWeight: isBold ? FontWeight.w900 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getRentalStatusText(
    BuildContext context,
    RentalProgressStatus status,
  ) {
    switch (status) {
      case RentalProgressStatus.pending:
        return AppLocalizations.of(context)!.pending;
      case RentalProgressStatus.booked:
        return AppLocalizations.of(context)!.statusBooked;
      case RentalProgressStatus.delivering:
        return AppLocalizations.of(context)!.statusDelivering;
      case RentalProgressStatus.delivered:
        return AppLocalizations.of(context)!.statusDelivered;
      case RentalProgressStatus.inProgress:
        return AppLocalizations.of(context)!.statusInProgress;
      case RentalProgressStatus.returnRequested:
        return AppLocalizations.of(context)!.statusReturnRequested;
      case RentalProgressStatus.returnConfirmed:
        return AppLocalizations.of(context)!.statusReturnConfirmed;
      case RentalProgressStatus.cancelled:
        return AppLocalizations.of(context)!.cancelled;
    }
  }

  Color _getRentalStatusColor(RentalProgressStatus status) {
    switch (status) {
      case RentalProgressStatus.pending:
        return Colors.orange;
      case RentalProgressStatus.booked:
        return AppColors.primaryBlue;
      case RentalProgressStatus.delivering:
        return Colors.blueAccent;
      case RentalProgressStatus.delivered:
        return Colors.lightGreen;
      case RentalProgressStatus.inProgress:
        return Colors.green;
      case RentalProgressStatus.returnRequested:
        return Colors.purple;
      case RentalProgressStatus.returnConfirmed:
        return Colors.indigo;
      case RentalProgressStatus.cancelled:
        return AppColors.primaryRed;
    }
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
    return BlocBuilder<OwnerRentalWorkflowCubit, OwnerRentalWorkflowState>(
      builder: (context, state) {
        final isLoading =
            _isActionLoading ||
            state.status == OwnerRentalWorkflowStatus.loading;

        if (bill.rentalStatus == RentalProgressStatus.booked) {
          return Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: PrimaryButton(
              title: AppLocalizations.of(context)!.rentalStartDelivery,
              isLoading: isLoading,
              onPressed:
                  isLoading ? null : () => _onStartDelivery(context, bill.id),
            ),
          );
        }
        if (bill.rentalStatus == RentalProgressStatus.delivering) {
          return Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: PrimaryButton(
              title: AppLocalizations.of(context)!.rentalDelivered,
              isLoading: isLoading,
              onPressed:
                  isLoading ? null : () => _onDelivered(context, bill.id),
            ),
          );
        }
        if (bill.rentalStatus == RentalProgressStatus.returnRequested) {
          return Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: PrimaryButton(
              title: AppLocalizations.of(context)!.rentalConfirmReturn,
              isLoading: isLoading,
              onPressed:
                  isLoading ? null : () => _onConfirmReturn(context, bill.id),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _onStartDelivery(BuildContext context, int id) {
    context.read<OwnerRentalWorkflowCubit>().startDelivering(id);
  }

  Future<void> _onDelivered(BuildContext context, int id) async {
    setState(() => _isActionLoading = true);
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> photos = await picker.pickMultiImage();
      if (photos.isNotEmpty && context.mounted) {
        await context.read<OwnerRentalWorkflowCubit>().confirmDelivered(
          id,
          photos.map((e) => File(e.path)).toList(),
        );
      }
    } finally {
      if (mounted) setState(() => _isActionLoading = false);
    }
  }

  Future<void> _onConfirmReturn(BuildContext context, int id) async {
    setState(() => _isActionLoading = true);
    try {
      // 1. GPS
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

      Position? position;
      try {
        position = await Geolocator.getCurrentPosition();
      } catch (e) {
        if (context.mounted) {
          CustomSnackbar.show(
            context,
            message: AppLocalizations.of(context)!.locationError(e.toString()),
            type: SnackbarType.error,
          );
        }
        return;
      }

      // 2. Photos
      final ImagePicker picker = ImagePicker();
      final List<XFile> photos = await picker.pickMultiImage();

      // 3. Confirm
      if (photos.isNotEmpty && context.mounted) {
        await context.read<OwnerRentalWorkflowCubit>().confirmReturn(
          id,
          photos.map((e) => File(e.path)).toList(),
          position.latitude,
          position.longitude,
          null,
        );
      }
    } finally {
      if (mounted) setState(() => _isActionLoading = false);
    }
  }
}
