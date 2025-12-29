import 'package:flutter/material.dart';
import 'package:tour_guide_app/common/constants/app_default_image.constant.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/date_formatter.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';

class OwnerRentalRequestCard extends StatelessWidget {
  final RentalBill bill;
  final VoidCallback? onTap;

  const OwnerRentalRequestCard({super.key, required this.bill, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Get primary vehicle info
    RentalVehicle? vehicle;
    if (bill.details.isNotEmpty) {
      vehicle = bill.details.first.vehicle;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGrey.withOpacity(0.25),
              blurRadius: 8.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Renter Info Header
            Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: AppColors.primaryGrey.withOpacity(0.2),
                  backgroundImage: const NetworkImage(AppImage.defaultAvatar),
                  // TODO: Use actual user avatar if available in future
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bill.contactName ?? 'Unknown Renter',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      if (bill.contactPhone != null)
                        Text(
                          bill.contactPhone!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSubtitle),
                        ),
                    ],
                  ),
                ),
                _buildStatusBadge(context),
              ],
            ),
            SizedBox(height: 12.h),
            const Divider(height: 1, color: AppColors.primaryGrey),
            SizedBox(height: 12.h),

            // Vehicle Info
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    vehicle?.vehicleCatalog?.photo ?? AppImage.defaultCar,
                    width: 50.w,
                    height: 50.w,
                    fit: BoxFit.contain,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          width: 50.w,
                          height: 50.w,
                          color: AppColors.primaryGrey.withOpacity(0.2),
                          child: const Icon(Icons.broken_image, size: 20),
                        ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle != null
                            ? "${vehicle.vehicleCatalog?.brand} ${vehicle.vehicleCatalog?.model}"
                            : AppLocalizations.of(context)!.rentalVehicle,
                        style: Theme.of(
                          context,
                        ).textTheme.titleSmall?.copyWith(fontSize: 14.sp),
                      ),
                      Text(
                        vehicle?.licensePlate ??
                            bill.details.firstOrNull?.licensePlate ??
                            '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSubtitle,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Dates and Price
            _buildInfoRow(
              context,
              icon: AppIcons.calendar,
              label: AppLocalizations.of(context)!.startDate,
              value:
                  bill.rentalType == RentalBillType.hourly
                      ? DateFormatter.formatDateTime(bill.startDate)
                      : DateFormatter.formatDate(bill.startDate),
            ),
            SizedBox(height: 8.h),
            _buildInfoRow(
              context,
              icon: AppIcons.calendar,
              label: AppLocalizations.of(context)!.endDate,
              value:
                  bill.rentalType == RentalBillType.hourly
                      ? DateFormatter.formatDateTime(bill.endDate)
                      : DateFormatter.formatDate(bill.endDate),
            ),

            SizedBox(height: 12.h),
            const Divider(height: 1, color: AppColors.primaryGrey),
            SizedBox(height: 12.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.totalRevenue, 
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  Formatter.currency(bill.total),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: 16.sp,
          height: 16.sp,
          color: AppColors.textSubtitle,
        ),
        SizedBox(width: 8.w),
        Text(
          "$label: ",
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(color: AppColors.textSubtitle),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color color;
    String text;

    switch (bill.status) {
      case RentalBillStatus.pending:
        color = Colors.orange;
        text = AppLocalizations.of(context)!.pending;
        break;
      case RentalBillStatus.confirmed:
        color = AppColors.primaryBlue;
        text = AppLocalizations.of(context)!.approved;
        break;
      case RentalBillStatus.paidPendingDelivery:
      case RentalBillStatus.paid:
        color = Colors.green;
        text = AppLocalizations.of(context)!.paid;
        break;
      case RentalBillStatus.cancelled:
        color = AppColors.primaryRed;
        text = AppLocalizations.of(context)!.cancelled;
        break;
      case RentalBillStatus.completed:
        color = Colors.teal;
        text = AppLocalizations.of(context)!.completed;
        break;
    }

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
}
