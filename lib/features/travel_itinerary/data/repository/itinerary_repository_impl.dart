import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/data_source/itinerary_api_service.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/province.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class ItineraryRepositoryImpl extends ItineraryRepository {
  final _apiService = sl<ItineraryApiService>();

  @override
  Future<Either<Failure, ProvinceResponse>> getProvinces(String? search) {
    return _apiService.getProvinces(search);
  }
}
