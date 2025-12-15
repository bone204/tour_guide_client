import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/province.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetProvincesUseCase implements UseCase<Either<Failure, ProvinceResponse>, String> {
  @override
  Future<Either<Failure, ProvinceResponse>> call(String? search) async {
    return await sl<ItineraryRepository>().getProvinces(search);
  }
}
