import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_query.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_response.dart';
import 'package:tour_guide_app/features/destination/domain/repository/destination_repository.dart';
import 'package:tour_guide_app/service_locator.dart';


class GetDestinationUseCase implements UseCase<Either<Failure, DestinationResponse>, DestinationQuery> {
  @override
  Future<Either<Failure, DestinationResponse>> call(DestinationQuery params) async {
    return await sl<DestinationRepository>().getDestinations(params);
  }
}
