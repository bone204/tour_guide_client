import 'package:flutter/material.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';

class RentalStatusHelper {
  static (Color, String) getStatusColorAndText(
    BuildContext context,
    RentalBill bill,
  ) {
    Color color;
    String text;

    // Priority 1: Terminal Bill States
    if (bill.status == RentalBillStatus.cancelled) {
      color = AppColors.primaryRed;
      text = AppLocalizations.of(context)!.cancelled;
      return (color, text);
    } else if (bill.status == RentalBillStatus.completed) {
      color = Colors.teal;
      text = AppLocalizations.of(context)!.completed;
      return (color, text);
    }

    // Priority 2: Active Workflow States (RentalProgressStatus)
    // We check rentalStatus if it's NOT pending, implying the workflow has started.
    // However, sometimes rentalStatus is pending but billStatus is paid.
    // Let's follow the logic: if rentalStatus has advanced beyond pending/booked, distinct colors.

    switch (bill.rentalStatus) {
      case RentalProgressStatus.delivering:
        color = Colors.indigo;
        text = AppLocalizations.of(context)!.statusDelivering;
        return (color, text);
      case RentalProgressStatus.delivered:
        color = Colors.lightGreen;
        text = AppLocalizations.of(context)!.statusDelivered;
        return (color, text);
      case RentalProgressStatus.inProgress:
        color = Colors.green;
        text = AppLocalizations.of(context)!.statusInProgress;
        return (color, text);
      case RentalProgressStatus.returnRequested:
        color = Colors.purple;
        text = AppLocalizations.of(context)!.statusReturnRequested;
        return (color, text);
      case RentalProgressStatus.returnConfirmed:
        color = Colors.teal;
        text = AppLocalizations.of(context)!.statusReturnConfirmed;
        return (color, text);
      case RentalProgressStatus.cancelled:
        color = AppColors.primaryRed;
        text = AppLocalizations.of(context)!.cancelled;
        return (color, text);
      case RentalProgressStatus.pending:
      case RentalProgressStatus.booked:
        // Fall through to Bill Status to decide (e.g. Paid vs Pending)
        break;
    }

    // Priority 3: Initial/Payment Bill States
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
        color = Colors.indigo; // Waiting for delivery
        text = AppLocalizations.of(context)!.paid;
        break;
      case RentalBillStatus.paid:
        color = Colors.green;
        text = AppLocalizations.of(context)!.paid;
        break;
      default:
        color = Colors.grey;
        text = 'Unknown';
    }

    return (color, text);
  }

  // Helper for just color if needed (e.g. valid checks)
  static Color getStatusColorOnly(RentalProgressStatus status) {
    switch (status) {
      case RentalProgressStatus.pending:
        return Colors.orange;
      case RentalProgressStatus.booked:
        return AppColors.primaryBlue;
      case RentalProgressStatus.delivering:
        return Colors.indigo;
      case RentalProgressStatus.delivered:
        return Colors.lightGreen;
      case RentalProgressStatus.inProgress:
        return Colors.green;
      case RentalProgressStatus.returnRequested:
        return Colors.purple;
      case RentalProgressStatus.returnConfirmed:
        return Colors.teal;
      case RentalProgressStatus.cancelled:
        return AppColors.primaryRed;
    }
  }
}
