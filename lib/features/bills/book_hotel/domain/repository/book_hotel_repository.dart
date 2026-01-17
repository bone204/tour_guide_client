import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/bills/book_hotel/data/models/hotel_bill.dart';

abstract class BookHotelRepository {
  Future<Either<Failure, List<HotelBill>>> getMyBills({
    HotelBillStatus? status,
  });
  Future<Either<Failure, HotelBill>> getBillDetail(int id);
  Future<Either<Failure, HotelBill>> updateBill(
    int id, {
    String? contactName,
    String? contactPhone,
    String? notes,
    String? voucherCode,
    double? travelPointsUsed,
  });
  Future<Either<Failure, HotelBill>> confirm(int id, String paymentMethod);
  Future<Either<Failure, HotelBill>> pay(int id);
  Future<Either<Failure, HotelBill>> cancel(int id, {String? reason});
  Future<Either<Failure, HotelBill>> checkIn(int id);
  Future<Either<Failure, HotelBill>> checkOut(int id);
}
