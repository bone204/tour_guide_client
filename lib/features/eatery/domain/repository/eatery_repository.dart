import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/eatery/data/models/eatery.dart';

abstract class EateryRepository {
  Future<Either<Failure, List<Eatery>>> getEateries({
    String? province,
    String? keyword,
  });
  Future<Either<Failure, List<Eatery>>> getNearbyEateries({
    required double latitude,
    required double longitude,
    double? radius,
  });
  Future<Either<Failure, Eatery>> getRandomEatery({
    String? province,
    List<int>? eateryIds,
  });
  Future<Either<Failure, Eatery>> getEateryDetail(int id);
}
