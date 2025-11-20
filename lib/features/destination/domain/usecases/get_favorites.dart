import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_response.dart';
import 'package:tour_guide_app/features/destination/domain/repository/destination_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetFavoritesUseCase implements UseCase<Either<Failure, DestinationResponse>, NoParams> {
  @override
  Future<Either<Failure, DestinationResponse>> call(NoParams params) async {
    return await sl<DestinationRepository>().getFavorites();
  }
}

