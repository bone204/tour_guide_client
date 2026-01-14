import 'dart:async';
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
import 'package:flutter/cupertino.dart';
import 'package:tour_guide_app/core/events/app_events.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/utils/rental_status_helper.dart';

import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/common/pages/tracking_map.page.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:tour_guide_app/common/constants/app_default_image.constant.dart';

import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/owner_cancel_bill/owner_cancel_bill_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/owner_cancel_bill/owner_cancel_bill_state.dart';
import 'package:tour_guide_app/common/widgets/dialog/custom_dialog.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';

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
  LatLng? _currentPosition;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _initLocation();
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
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _initLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
        });
      }
    } catch (_) {
      // Ignore errors for preview
    }
  }

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
        BlocProvider(create: (context) => sl<OwnerCancelBillCubit>()),
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
                  eventBus.fire(RentalRequestUpdatedEvent(billId: widget.id));

                  String message = AppLocalizations.of(context)!.actionSuccess;
                  if (state.action ==
                      OwnerRentalWorkflowAction.startDelivering) {
                    message =
                        AppLocalizations.of(
                          context,
                        )!.rentalStartDeliverySuccess;
                  } else if (state.action ==
                      OwnerRentalWorkflowAction.confirmDelivered) {
                    message =
                        AppLocalizations.of(context)!.rentalDeliveredSuccess;
                  } else if (state.action ==
                      OwnerRentalWorkflowAction.confirmReturn) {
                    message =
                        AppLocalizations.of(
                          context,
                        )!.rentalConfirmReturnSuccess;
                  }

                  CustomSnackbar.show(
                    context,
                    message: message,
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
            BlocListener<OwnerCancelBillCubit, OwnerCancelBillState>(
              listener: (context, state) {
                if (state is OwnerCancelBillSuccess) {
                  Navigator.pop(context); // Close dialog if open
                  CustomSnackbar.show(
                    context,
                    message: AppLocalizations.of(context)!.cancelSuccess,
                    type: SnackbarType.success,
                  );
                  _onRefresh(context);
                  eventBus.fire(RentalBillUpdatedEvent(billId: widget.id));
                } else if (state is OwnerCancelBillFailure) {
                  Navigator.pop(context); // Close dialog if open
                  CustomSnackbar.show(
                    context,
                    message: state.message,
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
                return Center(child: Text(state.errorMessage ?? 'Error'));
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
                        // 1. Vehicle Info
                        _buildVehicleInfoCard(
                          context,
                          vehicle,
                          licensePlate,
                          bill,
                        ),
                        SizedBox(height: 16.h),

                        // 2. Renter Info
                        _buildRenterInfoCard(context, bill),
                        SizedBox(height: 16.h),

                        // 3. Rental Details
                        _buildRentalDetailsCard(context, bill),
                        SizedBox(height: 16.h),

                        // 4. Payment Info
                        _buildPaymentDetailsCard(context, bill),

                        // 5. Tracking Images
                        _buildTrackingImagesCard(context, bill),

                        // 6. Tracking Map
                        _buildTrackingMapSection(context, bill),

                        SizedBox(height: 32.h),

                        // 7. Workflow Actions
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
            bill.contactName ?? bill.user?.fullName ?? '-',
          ),
          _buildDetailRow(
            context,
            AppLocalizations.of(context)!.phoneNumber,
            bill.contactPhone ?? bill.user?.phone ?? '-',
          ),
          if (bill.notes != null && bill.notes!.isNotEmpty)
            _buildDetailRow(
              context,
              AppLocalizations.of(context)!.notes,
              bill.notes!,
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
                AppLocalizations.of(context)!.totalPayment,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                Formatter.currency(bill.total),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: AppColors.primaryRed),
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
              ),
            ),
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

  Widget _buildWorkflowActions(BuildContext context, RentalBill bill) {
    return BlocBuilder<OwnerRentalWorkflowCubit, OwnerRentalWorkflowState>(
      builder: (context, state) {
        final isWorkflowLoading =
            _isActionLoading ||
            state.status == OwnerRentalWorkflowStatus.loading;

        if (bill.rentalStatus == RentalProgressStatus.booked) {
          return Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: Column(
              children: [
                PrimaryButton(
                  title: AppLocalizations.of(context)!.rentalStartDelivery,
                  isLoading: isWorkflowLoading,
                  onPressed:
                      isWorkflowLoading
                          ? null
                          : () => _onStartDelivery(context, bill.id),
                ),
                SizedBox(height: 12.h),
                _buildCancelButton(context, bill, isWorkflowLoading),
              ],
            ),
          );
        }
        if (bill.rentalStatus == RentalProgressStatus.delivering) {
          return Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: PrimaryButton(
              title: AppLocalizations.of(context)!.rentalDelivered,
              isLoading: isWorkflowLoading,
              onPressed:
                  isWorkflowLoading
                      ? null
                      : () => _onDelivered(context, bill.id),
            ),
          );
        }
        if (bill.rentalStatus == RentalProgressStatus.returnRequested) {
          return Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: PrimaryButton(
              title: AppLocalizations.of(context)!.rentalConfirmReturn,
              isLoading: isWorkflowLoading,
              onPressed:
                  isWorkflowLoading
                      ? null
                      : () => _onConfirmReturn(context, bill.id),
            ),
          );
        }

        if (bill.status == RentalBillStatus.pending) {
          return _buildCancelButton(context, bill, isWorkflowLoading);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCancelButton(
    BuildContext context,
    RentalBill bill,
    bool isExternalLoading,
  ) {
    return BlocBuilder<OwnerCancelBillCubit, OwnerCancelBillState>(
      builder: (context, state) {
        final isCancelLoading = state is OwnerCancelBillLoading;
        final isDisabled = isExternalLoading || isCancelLoading;

        return SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            title: AppLocalizations.of(context)!.cancel,
            backgroundColor: AppColors.primaryRed,
            isLoading: isCancelLoading,
            onPressed:
                isDisabled ? null : () => _onCancelBill(context, bill.id),
          ),
        );
      },
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
                  context.read<OwnerCancelBillCubit>().cancelBill(id, reason);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrackingMapSection(BuildContext context, RentalBill bill) {
    if (bill.rentalStatus != RentalProgressStatus.delivering) {
      return const SizedBox.shrink();
    }

    if (_currentPosition == null) {
      return Container(
        margin: EdgeInsets.only(top: 16.h),
        height: 180.h,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      margin: EdgeInsets.only(top: 16.h),
      height: 180.h,
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
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: IgnorePointer(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: _currentPosition!,
                  initialZoom: 15.0,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate: MapType.normal.urlTemplate,
                    userAgentPackageName: 'tour_guide_app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentPosition!,
                        width: 60,
                        height: 60,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16.r),
                onTap: () => _navigateToTrackingMap(context, bill),
              ),
            ),
          ),
          Positioned(
            top: 12.h,
            right: 12.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.fullscreen,
                    size: 16.sp,
                    color: AppColors.primaryBlue,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    AppLocalizations.of(context)!.map,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToTrackingMap(BuildContext context, RentalBill bill) {
    final vehicle = bill.details.isNotEmpty ? bill.details.first.vehicle : null;
    final contract = vehicle?.contract;

    final double? startLat = contract?.businessLatitude;
    final double? startLong = contract?.businessLongitude;
    final double? endLat = bill.pickupLatitude;
    final double? endLong = bill.pickupLongitude;

    if (startLat == null || startLong == null) {
      CustomSnackbar.show(
        context,
        message: 'Missing owner location',
        type: SnackbarType.warning,
      );
      return;
    }

    if (endLat == null || endLong == null) {
      CustomSnackbar.show(
        context,
        message: 'Missing pickup location',
        type: SnackbarType.warning,
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => TrackingMapPage(
              startLocation: LatLng(startLat, startLong),
              endLocation: LatLng(endLat, endLong),
              startAddress: contract?.businessAddress,
              endAddress: bill.location,
            ),
      ),
    );
  }

  void _onStartDelivery(BuildContext context, int id) {
    context.read<OwnerRentalWorkflowCubit>().startDelivering(id);
  }

  Future<void> _onDelivered(BuildContext context, int id) async {
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

    if (!context.mounted) return;

    final source = await _showImageSourceActionSheet(context);
    if (source == null) return;

    setState(() => _isActionLoading = true);
    try {
      final position = await Geolocator.getCurrentPosition();

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
        await context.read<OwnerRentalWorkflowCubit>().confirmDelivered(
          id,
          photos.map((e) => File(e.path)).toList(),
          position.latitude,
          position.longitude,
        );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.show(
          context,
          message: e.toString(),
          type: SnackbarType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isActionLoading = false);
    }
  }

  Future<void> _onConfirmReturn(BuildContext context, int id) async {
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
        // handle
      }

      // 2. Photos
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

      // 3. Confirm
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
