import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/eatery/data/models/eatery.dart';
import 'package:tour_guide_app/features/eatery/domain/repository/eatery_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetRandomEateryUseCase
    implements UseCase<Either<Failure, Eatery>, String> {
  @override
  Future<Either<Failure, Eatery>> call(String province) async {
    return await sl<EateryRepository>().getRandomEatery(province);
  }
}
