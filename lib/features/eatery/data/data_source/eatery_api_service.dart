import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/features/eatery/data/models/eatery.dart';
import 'package:tour_guide_app/service_locator.dart';

abstract class EateryApiService {
  Future<Either<Failure, List<Eatery>>> getEateries({
    String? province,
    String? keyword,
  });
  Future<Either<Failure, Eatery>> getRandomEatery(String province);
  Future<Either<Failure, Eatery>> getEateryDetail(int id);
}

class EateryApiServiceImpl implements EateryApiService {
  @override
  Future<Either<Failure, List<Eatery>>> getEateries({
    String? province,
    String? keyword,
  }) async {
    try {
      final response = await sl<DioClient>().get(
        '/eateries',
        queryParameters: {
          if (province != null) 'province': province,
          if (keyword != null) 'keyword': keyword,
        },
      );
      final result =
          (response.data as List)
              .map((e) => Eatery.fromJson(e as Map<String, dynamic>))
              .toList();
      return Right(result);
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
  Future<Either<Failure, Eatery>> getRandomEatery(String province) async {
    try {
      final response = await sl<DioClient>().get(
        '/eateries/random',
        queryParameters: {'province': province},
      );
      final result = Eatery.fromJson(response.data as Map<String, dynamic>);
      return Right(result);
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
  Future<Either<Failure, Eatery>> getEateryDetail(int id) async {
    try {
      final response = await sl<DioClient>().get('/eateries/$id');
      final result = Eatery.fromJson(response.data as Map<String, dynamic>);
      return Right(result);
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
