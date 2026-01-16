import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/create_hotel_bill_request.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel_room_search_request.dart';

import 'package:tour_guide_app/features/hotel_booking/data/models/hotel.dart';

abstract class HotelBookingRepository {
  Future<Either<Failure, List<Hotel>>> getHotelRooms(
    HotelRoomSearchRequest request,
  );

  Future<Either<Failure, int>> createHotelBill(CreateHotelBillRequest request);
}
