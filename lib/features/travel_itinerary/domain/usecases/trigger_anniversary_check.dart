import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/anniversary_check_response.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class TriggerAnniversaryCheckUseCase
    implements UseCase<Either<Failure, AnniversaryCheckResponse>, NoParams> {
  @override
  Future<Either<Failure, AnniversaryCheckResponse>> call(
    NoParams params,
  ) async {
    return await sl<ItineraryRepository>().triggerAnniversaryCheck();
  }
}
