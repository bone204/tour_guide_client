import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel_room_search_request.dart';
import 'package:tour_guide_app/features/hotel_booking/domain/repository/hotel_booking_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

import 'package:tour_guide_app/features/hotel_booking/data/models/hotel.dart';

class GetHotelRoomsUseCase
    implements UseCase<Either<Failure, List<Hotel>>, HotelRoomSearchRequest> {
  final _repo = sl<HotelBookingRepository>();

  @override
  Future<Either<Failure, List<Hotel>>> call(
    HotelRoomSearchRequest params,
  ) async {
    return _repo.getHotelRooms(params);
  }
}
