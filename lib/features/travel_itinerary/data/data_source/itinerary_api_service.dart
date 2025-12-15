import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/province.dart';
import 'package:tour_guide_app/service_locator.dart';

abstract class ItineraryApiService {
  Future<Either<Failure, ProvinceResponse>> getProvinces(
    String? search,
  );
}

class ItineraryApiServiceImpl extends ItineraryApiService {
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
}
