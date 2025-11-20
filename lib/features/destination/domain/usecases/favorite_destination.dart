import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';
import 'package:tour_guide_app/features/destination/domain/repository/destination_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class FavoriteDestinationUseCase implements UseCase<Either<Failure, Destination>, int> {
  @override
  Future<Either<Failure, Destination>> call(int id) async {
    return await sl<DestinationRepository>().favoriteDestination(id);
  }
}

