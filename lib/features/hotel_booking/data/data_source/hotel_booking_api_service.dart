import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel_room_search_request.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/room.dart';
import 'package:tour_guide_app/service_locator.dart';

abstract class HotelBookingApiService {
  Future<Either<Failure, List<Hotel>>> getHotelRooms(
    HotelRoomSearchRequest request,
  );
  Future<Either<Failure, HotelRoom>> getHotelRoomDetail(
    int id, {
    String? checkInDate,
    String? checkOutDate,
  });
}

class HotelBookingApiServiceImpl extends HotelBookingApiService {
  @override
  Future<Either<Failure, List<Hotel>>> getHotelRooms(
    HotelRoomSearchRequest request,
  ) async {
    try {
      final response = await sl<DioClient>().get(
        "${ApiUrls.hotelRooms}/search",
        queryParameters: request.toJson(),
      );
      final List<dynamic> data = response.data;
      final hotels = data.map((json) => Hotel.fromJson(json)).toList();
      return Right(hotels);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.response?.data['message'] ?? 'An error occurred during search',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, HotelRoom>> getHotelRoomDetail(
    int id, {
    String? checkInDate,
    String? checkOutDate,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (checkInDate != null) queryParameters['checkInDate'] = checkInDate;
      if (checkOutDate != null) queryParameters['checkOutDate'] = checkOutDate;

      final response = await sl<DioClient>().get(
        "${ApiUrls.hotelRooms}/$id",
        queryParameters: queryParameters,
      );
      final room = HotelRoom.fromJson(response.data);
      return Right(room);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.response?.data['message'] ??
              'An error occurred while fetching details',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
