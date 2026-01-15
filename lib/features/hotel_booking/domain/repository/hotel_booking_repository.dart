import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel_room_search_request.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/room.dart';

abstract class HotelBookingRepository {
  Future<Either<Failure, List<HotelRoom>>> getHotelRooms(
    HotelRoomSearchRequest request,
  );
  Future<Either<Failure, HotelRoom>> getHotelRoomDetail(
    int id, {
    String? checkInDate,
    String? checkOutDate,
  });
}
