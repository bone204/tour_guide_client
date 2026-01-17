import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/bills/book_hotel/data/data_source/book_hotel_api_service.dart';
import 'package:tour_guide_app/features/bills/book_hotel/data/models/hotel_bill.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/repository/book_hotel_repository.dart';

class BookHotelRepositoryImpl implements BookHotelRepository {
  final BookHotelApiService apiService;

  BookHotelRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, List<HotelBill>>> getMyBills({
    HotelBillStatus? status,
  }) {
    return apiService.getMyBills(status: status);
  }

  @override
  Future<Either<Failure, HotelBill>> getBillDetail(int id) {
    return apiService.getBillDetail(id);
  }

  @override
  Future<Either<Failure, HotelBill>> updateBill(
    int id, {
    String? contactName,
    String? contactPhone,
    String? notes,
    String? voucherCode,
    double? travelPointsUsed,
  }) {
    return apiService.updateBill(
      id,
      contactName: contactName,
      contactPhone: contactPhone,
      notes: notes,
      voucherCode: voucherCode,
      travelPointsUsed: travelPointsUsed,
    );
  }

  @override
  Future<Either<Failure, HotelBill>> confirm(int id, String paymentMethod) {
    return apiService.confirm(id, paymentMethod);
  }

  @override
  Future<Either<Failure, HotelBill>> pay(int id) {
    return apiService.pay(id);
  }

  @override
  Future<Either<Failure, HotelBill>> cancel(int id, {String? reason}) {
    return apiService.cancel(id, reason: reason);
  }

  @override
  Future<Either<Failure, HotelBill>> checkIn(int id) {
    return apiService.checkIn(id);
  }

  @override
  Future<Either<Failure, HotelBill>> checkOut(int id) {
    return apiService.checkOut(id);
  }
}
