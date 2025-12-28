import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/eatery/data/models/eatery.dart';
import 'package:tour_guide_app/features/eatery/domain/repository/eatery_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetEateryDetailUseCase implements UseCase<Either<Failure, Eatery>, int> {
  @override
  Future<Either<Failure, Eatery>> call(int id) async {
    return await sl<EateryRepository>().getEateryDetail(id);
  }
}
