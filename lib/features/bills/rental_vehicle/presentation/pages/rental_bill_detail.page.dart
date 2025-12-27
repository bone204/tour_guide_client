import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/constants/app_default_image.constant.dart';
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

class RentalBillDetailPage extends StatelessWidget {
  final int id;

  const RentalBillDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GetRentalBillDetailCubit>()..getBillDetail(id),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.rentalBillDetail,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: BlocBuilder<GetRentalBillDetailCubit, RentalBillDetailState>(
          builder: (context, state) {
            if (state.status == RentalBillDetailInitStatus.loading) {
              return const RentalBillDetailShimmer();
            } else if (state.status == RentalBillDetailInitStatus.failure) {
              return Center(child: Text(state.errorMessage ?? 'Error'));
            } else if (state.status == RentalBillDetailInitStatus.success &&
                state.bill != null) {
              final bill = state.bill!;
              // Assume single vehicle flow as per user request
              final RentalVehicle? vehicle =
                  bill.details.isNotEmpty ? bill.details.first.vehicle : null;
              final String licensePlate =
                  bill.details.isNotEmpty
                      ? bill.details.first.licensePlate
                      : '';

              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    // 1. Vehicle Info Card
                    _buildVehicleInfoCard(context, vehicle, licensePlate),
                    SizedBox(height: 16.h),

                    // 2. Rental Details (Status, Dates, etc.)
                    _buildRentalDetailsCard(context, bill),
                    SizedBox(height: 16.h),

                    // 3. Payment Details
                    _buildPaymentDetailsCard(context, bill),
                    SizedBox(height: 16.h),

                    // 4. Contact/Notes if any
                    if ((bill.notes != null && bill.notes!.isNotEmpty) ||
                        bill.contactName != null)
                      _buildAdditionalInfoCard(context, bill),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
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
              fit: BoxFit.cover,
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
            bill.rentalType == RentalBillType.hourly
                ? DateFormatter.formatDateTime(bill.startDate)
                : DateFormatter.formatDate(bill.startDate),
          ),
          _buildDetailRow(
            context,
            AppLocalizations.of(context)!.endDate,
            bill.rentalType == RentalBillType.hourly
                ? DateFormatter.formatDateTime(bill.endDate)
                : DateFormatter.formatDate(bill.endDate),
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

  Widget _buildAdditionalInfoCard(BuildContext context, RentalBill bill) {
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
          if (bill.notes != null && bill.notes!.isNotEmpty) ...[
            Text(
              AppLocalizations.of(context)!.notes,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 4.h),
            Text(bill.notes!, style: Theme.of(context).textTheme.bodyMedium),
            if (bill.contactName != null) SizedBox(height: 12.h),
          ],
          if (bill.contactName != null) ...[
            Text(
              AppLocalizations.of(context)!.contactInfo,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 4.h),
            Text(
              '${bill.contactName} - ${bill.contactPhone}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
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
}
