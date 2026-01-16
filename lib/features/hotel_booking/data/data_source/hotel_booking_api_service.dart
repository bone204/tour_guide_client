import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/create_hotel_bill_request.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel_room_search_request.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel.dart';

import 'package:tour_guide_app/service_locator.dart';

abstract class HotelBookingApiService {
  Future<Either<Failure, List<Hotel>>> getHotelRooms(
    HotelRoomSearchRequest request,
  );
  Future<Either<Failure, int>> createHotelBill(CreateHotelBillRequest request);
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
  Future<Either<Failure, int>> createHotelBill(
    CreateHotelBillRequest request,
  ) async {
    try {
      final response = await sl<DioClient>().post(
        ApiUrls.hotelBills,
        data: request.toJson(),
      );
      return Right(response.data['id']);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.response?.data['message'] ??
              'An error occurred while creating hotel bill',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
