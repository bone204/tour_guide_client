import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/eatery/data/models/eatery.dart';

abstract class EateryRepository {
  Future<Either<Failure, List<Eatery>>> getEateries({
    String? province,
    String? keyword,
  });
  Future<Either<Failure, Eatery>> getRandomEatery(String province);
  Future<Either<Failure, Eatery>> getEateryDetail(int id);
}
