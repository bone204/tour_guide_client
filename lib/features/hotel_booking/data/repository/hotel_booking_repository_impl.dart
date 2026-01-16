import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/hotel_booking/data/data_source/hotel_booking_api_service.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/create_hotel_bill_request.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel_room_search_request.dart';

import 'package:tour_guide_app/features/hotel_booking/domain/repository/hotel_booking_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

import 'package:tour_guide_app/features/hotel_booking/data/models/hotel.dart';

class HotelBookingRepositoryImpl extends HotelBookingRepository {
  final _apiService = sl<HotelBookingApiService>();

  @override
  Future<Either<Failure, List<Hotel>>> getHotelRooms(
    HotelRoomSearchRequest request,
  ) {
    return _apiService.getHotelRooms(request);
  }

  @override
  Future<Either<Failure, int>> createHotelBill(CreateHotelBillRequest request) {
    return _apiService.createHotelBill(request);
  }
}
