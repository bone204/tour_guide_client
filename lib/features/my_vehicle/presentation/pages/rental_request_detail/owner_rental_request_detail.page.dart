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
                          bill,
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

                        // 5. Tracking Images
                        _buildTrackingImagesCard(context, bill),

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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
          Divider(),
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
    final source = await _showImageSourceActionSheet(context);
    if (source == null) return;

    setState(() => _isActionLoading = true);
    try {
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
