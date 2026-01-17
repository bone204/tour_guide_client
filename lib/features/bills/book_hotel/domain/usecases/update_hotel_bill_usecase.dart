import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/bills/book_hotel/data/models/hotel_bill.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/repository/book_hotel_repository.dart';

class UpdateHotelBillUseCase {
  final BookHotelRepository repository;

  UpdateHotelBillUseCase(this.repository);

  Future<Either<Failure, HotelBill>> call(
    int id, {
    String? contactName,
    String? contactPhone,
    String? notes,
    String? voucherCode,
    double? travelPointsUsed,
  }) async {
    return await repository.updateBill(
      id,
      contactName: contactName,
      contactPhone: contactPhone,
      notes: notes,
      voucherCode: voucherCode,
      travelPointsUsed: travelPointsUsed,
    );
  }
}
