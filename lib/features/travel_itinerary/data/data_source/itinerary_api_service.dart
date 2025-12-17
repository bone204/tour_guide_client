import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/create_itinerary_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/add_stop_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/province.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/service_locator.dart';

abstract class ItineraryApiService {
  Future<Either<Failure, ItineraryResponse>> getItineraryMe();
  Future<Either<Failure, ItineraryResponse>> getItineraries(
    Map<String, dynamic> query,
  );
  Future<Either<Failure, Itinerary>> getItineraryDetail(int id);
  Future<Either<Failure, SuccessResponse>> deleteItinerary(int id);
  Future<Either<Failure, Itinerary>> createItinerary(
    CreateItineraryRequest request,
  );
  Future<Either<Failure, ProvinceResponse>> getProvinces(String? search);
  Future<Either<Failure, Stop>> addStop(
    int itineraryId,
    AddStopRequest request,
  );
  Future<Either<Failure, Stop>> getStopDetail(int itineraryId, int stopId);
}

class ItineraryApiServiceImpl extends ItineraryApiService {
  @override
  Future<Either<Failure, ItineraryResponse>> getItineraryMe() async {
    try {
      final response = await sl<DioClient>().get("${ApiUrls.itinerary}/me");
      final itineraryResponse = ItineraryResponse.fromJson(response.data);
      return Right(itineraryResponse);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItineraryResponse>> getItineraries(
    Map<String, dynamic> query,
  ) async {
    try {
      final response = await sl<DioClient>().get(
        ApiUrls.itinerary,
        queryParameters: query,
      );
      final itineraryResponse = ItineraryResponse.fromJson(response.data);
      return Right(itineraryResponse);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Itinerary>> getItineraryDetail(int id) async {
    try {
      final response = await sl<DioClient>().get('${ApiUrls.itinerary}/$id');
      final itinerary = Itinerary.fromJson(response.data);
      return Right(itinerary);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SuccessResponse>> deleteItinerary(int id) async {
    try {
      final response = await sl<DioClient>().delete('${ApiUrls.itinerary}/$id');
      final successResponse = SuccessResponse.fromJson(response.data);
      return Right(successResponse);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Itinerary>> createItinerary(
    CreateItineraryRequest request,
  ) async {
    try {
      final response = await sl<DioClient>().post(
        ApiUrls.itinerary,
        data: request.toJson(),
      );
      final itinerary = Itinerary.fromJson(response.data);
      return Right(itinerary);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Stop>> addStop(
    int itineraryId,
    AddStopRequest request,
  ) async {
    try {
      final response = await sl<DioClient>().post(
        '${ApiUrls.itinerary}/$itineraryId/stops',
        data: [request.toJson()],
      );
      final data = response.data;
      final stop =
          data is List ? Stop.fromJson(data.first) : Stop.fromJson(data);
      return Right(stop);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProvinceResponse>> getProvinces(String? search) async {
    try {
      final response = await sl<DioClient>().get(
        ApiUrls.provinces,
        queryParameters: search != null ? {'search': search} : null,
      );
      final provinceResponse = ProvinceResponse.fromJson(response.data);
      return Right(provinceResponse);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Stop>> getStopDetail(
    int itineraryId,
    int stopId,
  ) async {
    try {
      final response = await sl<DioClient>().get(
        '${ApiUrls.itinerary}/$itineraryId/stops/$stopId',
      );
      final stop = Stop.fromJson(response.data);
      return Right(stop);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
