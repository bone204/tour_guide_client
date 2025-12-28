import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/eatery/data/data_source/eatery_api_service.dart';
import 'package:tour_guide_app/features/eatery/data/models/eatery.dart';
import 'package:tour_guide_app/features/eatery/domain/repository/eatery_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class EateryRepositoryImpl implements EateryRepository {
  final _apiService = sl<EateryApiService>();

  @override
  Future<Either<Failure, List<Eatery>>> getEateries({
    String? province,
    String? keyword,
  }) {
    return _apiService.getEateries(province: province, keyword: keyword);
  }

  @override
  Future<Either<Failure, Eatery>> getRandomEatery(String province) {
    return _apiService.getRandomEatery(province);
  }

  @override
  Future<Either<Failure, Eatery>> getEateryDetail(int id) {
    return _apiService.getEateryDetail(id);
  }
}
