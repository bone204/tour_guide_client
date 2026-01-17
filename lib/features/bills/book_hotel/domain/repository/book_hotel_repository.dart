import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/bills/book_hotel/data/models/hotel_bill.dart';

import 'package:tour_guide_app/features/bills/book_hotel/data/models/update_hotel_bill_request.dart';
import 'package:tour_guide_app/features/bills/book_hotel/data/models/hotel_bill_pay_response.dart';

abstract class BookHotelRepository {
  Future<Either<Failure, List<HotelBill>>> getMyBills({
    HotelBillStatus? status,
  });
  Future<Either<Failure, HotelBill>> getBillDetail(int id);
  Future<Either<Failure, HotelBill>> updateBill(UpdateHotelBillRequest params);
  Future<Either<Failure, HotelBill>> confirm(int id, String paymentMethod);
  Future<Either<Failure, HotelBillPayResponse>> pay(int id);
  Future<Either<Failure, HotelBill>> cancel(int id, {String? reason});
  Future<Either<Failure, HotelBill>> checkIn(int id);
  Future<Either<Failure, HotelBill>> checkOut(int id);
}
