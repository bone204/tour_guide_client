import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/province.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetProvinceByIdUseCase implements UseCase<Either<Failure, Province>, int> {
  @override
  Future<Either<Failure, Province>> call(int id) async {
    return await sl<ItineraryRepository>().getProvinceById(id);
  }
}
