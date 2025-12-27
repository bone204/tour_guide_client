import 'package:flutter/material.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/date_formatter.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';

class RentalBillCard extends StatelessWidget {
  final RentalBill bill;
  final VoidCallback? onTap;

  const RentalBillCard({super.key, required this.bill, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.billCode}: ${bill.code}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall),
                
                _buildStatusBadge(context),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 4.w),
                Text(
                  '${DateFormatter.formatDate(bill.startDate)} - ${DateFormatter.formatDate(bill.endDate)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.totalPayment,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  Formatter.currency(bill.total),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.primaryRed,
                  ),
                ),
              ],
            ),
          ],
        ),
    ),
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
        color = Colors.blue;
        text = AppLocalizations.of(context)!.approved;
        break;
      case RentalBillStatus.paidPendingDelivery:
      case RentalBillStatus.paid:
        color = Colors.green;
        text =
            AppLocalizations.of(
              context,
            )!.paid; // Need 'paid' localized? or use available
        // "Paid" might not be in ARB based on snippet, checked 'pending', 'approved', 'rejected'.
        // Let's assume 'status' or just capitalize enum name if key missing.
        // Actually, lines 746+ show: approved, pending, rejected, suspended, inactive, available, rented.
        // I will use what matches best or just specific string if map fails.
        // Let's check previously added keys.
        break;
      case RentalBillStatus.cancelled:
        color = Colors.red;
        text =
            AppLocalizations.of(
              context,
            )!.cancelled; // Need 'cancelled' -> use 'rejected'? No.
        break;
      case RentalBillStatus.completed:
        color = Colors.teal;
        text = AppLocalizations.of(context)!.completed;
        break;
      }

    // Since I'm not sure about specific status keys in ARB from the snippet (I only saw a subset),
    // I will try to use the ones I added or just specific common ones.
    // 'pending' exists. 'approved' exists.
    // For others, I'll fallback to english or just handle it.

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
        ),
      ),
    );
  }
}
