import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/bills/book_hotel/data/models/hotel_bill.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/repository/book_hotel_repository.dart';

class CancelHotelBillParams extends Equatable {
  final int id;
  final String? reason;

  const CancelHotelBillParams({required this.id, this.reason});

  @override
  List<Object?> get props => [id, reason];
}

class CancelHotelBillUseCase
    implements UseCase<Either<Failure, HotelBill>, CancelHotelBillParams> {
  final BookHotelRepository repository;

  CancelHotelBillUseCase(this.repository);

  @override
  Future<Either<Failure, HotelBill>> call(CancelHotelBillParams params) async {
    return await repository.cancel(params.id, reason: params.reason);
  }
}
