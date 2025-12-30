import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/date_formatter.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';

class RentalBillCard extends StatelessWidget {
  final RentalBill bill;
  final VoidCallback? onTap;

  const RentalBillCard({super.key, required this.bill, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Get primary vehicle info (assuming first device in list for card display)
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
            // Header: Image + Name + License Plate + Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    vehicle?.vehicleCatalog?.photo ?? AppImage.defaultCar,
                    width: 70.w,
                    height: 70.w,
                    fit: BoxFit.contain,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          width: 70.w,
                          height: 70.w,
                          color: AppColors.primaryGrey.withOpacity(0.2),
                          child: const Icon(Icons.broken_image),
                        ),
                  ),
                ),
                SizedBox(width: 12.w),
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
                              style: Theme.of(context).textTheme.titleSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          _buildStatusBadge(context),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        vehicle?.licensePlate ??
                            bill.details.firstOrNull?.licensePlate ??
                            '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSubtitle,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '${AppLocalizations.of(context)!.billCode}: ${bill.code}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSubtitle,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            const Divider(height: 1, color: AppColors.primaryGrey),
            SizedBox(height: 12.h),
            // Info Row
            _buildInfoRow(
              context,
              icon: AppIcons.clock,
              label: AppLocalizations.of(context)!.duration,
              value: bill.durationPackage ?? '',
            ),
            SizedBox(height: 8.h),
            _buildInfoRow(
              context,
              icon: AppIcons.calendar,
              label: AppLocalizations.of(context)!.startDate,
              value: DateFormatter.formatDateTime(bill.startDate),
            ),
            SizedBox(height: 8.h),
            _buildInfoRow(
              context,
              icon: AppIcons.calendar,
              label: AppLocalizations.of(context)!.endDate,
              value: DateFormatter.formatDateTime(bill.endDate),
            ),
            SizedBox(height: 12.h),
            const Divider(height: 1, color: AppColors.primaryGrey),
            SizedBox(height: 12.h),
            // Total Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.totalPayment,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  Formatter.currency(bill.total),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryRed,
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
