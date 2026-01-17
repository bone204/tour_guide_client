import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/bills/book_hotel/data/models/hotel_bill.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/repository/book_hotel_repository.dart';

class HotelCheckOutUseCase {
  final BookHotelRepository repository;

  HotelCheckOutUseCase(this.repository);

  Future<Either<Failure, HotelBill>> call(int id) {
    return repository.checkOut(id);
  }
}
