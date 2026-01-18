import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/anniversary_detail.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetAnniversaryUseCase
    implements UseCase<Either<Failure, AnniversaryDetail>, int> {
  @override
  Future<Either<Failure, AnniversaryDetail>> call(int id) async {
    return await sl<ItineraryRepository>().getAnniversary(id);
  }
}
