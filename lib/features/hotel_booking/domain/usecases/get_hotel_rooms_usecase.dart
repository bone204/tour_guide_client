import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel_room_search_request.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/room.dart';
import 'package:tour_guide_app/features/hotel_booking/domain/repository/hotel_booking_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetHotelRoomsUseCase
    implements
        UseCase<Either<Failure, List<HotelRoom>>, HotelRoomSearchRequest> {
  final _repo = sl<HotelBookingRepository>();

  @override
  Future<Either<Failure, List<HotelRoom>>> call(
    HotelRoomSearchRequest params,
  ) async {
    return _repo.getHotelRooms(params);
  }
}
