import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/eatery/data/models/eatery.dart';
import 'package:tour_guide_app/features/eatery/domain/repository/eatery_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class NearbyEateryParams {
  final double latitude;
  final double longitude;
  final double? radius;

  NearbyEateryParams({
    required this.latitude,
    required this.longitude,
    this.radius,
  });
}

class GetNearbyEateriesUseCase
    implements UseCase<Either<Failure, List<Eatery>>, NearbyEateryParams> {
  @override
  Future<Either<Failure, List<Eatery>>> call(NearbyEateryParams params) async {
    return await sl<EateryRepository>().getNearbyEateries(
      latitude: params.latitude,
      longitude: params.longitude,
      radius: params.radius,
    );
  }
}
