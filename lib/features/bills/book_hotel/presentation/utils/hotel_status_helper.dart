import 'package:flutter/material.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/bills/book_hotel/data/models/hotel_bill.dart';

class HotelStatusHelper {
  static (Color, String) getStatusColorAndText(
    BuildContext context,
    HotelBill bill,
  ) {
    // Priority: Bill Status
    switch (bill.status) {
      case HotelBillStatus.pending:
        return (
          Colors.orange,
          AppLocalizations.of(context)!.rentalStatusPending, // Reuse or add key
        );
      case HotelBillStatus.confirmed:
        return (
          Colors.blue,
          AppLocalizations.of(
            context,
          )!.rentalStatusConfirmed, // Reuse or add key
        );
      case HotelBillStatus.paid:
        return (
          Colors.green,
          AppLocalizations.of(context)!.rentalStatusPaid, // Reuse or add key
        );
      case HotelBillStatus.cancelled:
        return (
          Colors.red,
          AppLocalizations.of(
            context,
          )!.rentalStatusCancelled, // Reuse or add key
        );
      case HotelBillStatus.completed:
        return (
          Colors.purple,
          AppLocalizations.of(
            context,
          )!.rentalStatusCompleted, // Reuse or add key
        );
    }
  }
}
