import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/room.dart';
import 'package:tour_guide_app/features/hotel_booking/domain/repository/hotel_booking_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetHotelRoomDetailParams {
  final int id;
  final String? checkInDate;
  final String? checkOutDate;

  GetHotelRoomDetailParams({
    required this.id,
    this.checkInDate,
    this.checkOutDate,
  });
}

class GetHotelRoomDetailUseCase
    implements UseCase<Either<Failure, HotelRoom>, GetHotelRoomDetailParams> {
  final _repo = sl<HotelBookingRepository>();

  @override
  Future<Either<Failure, HotelRoom>> call(
    GetHotelRoomDetailParams params,
  ) async {
    return _repo.getHotelRoomDetail(
      params.id,
      checkInDate: params.checkInDate,
      checkOutDate: params.checkOutDate,
    );
  }
}
