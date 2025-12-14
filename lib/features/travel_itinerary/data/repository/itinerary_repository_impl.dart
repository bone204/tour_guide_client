import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/data_source/itinerary_api_service.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/province.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/province_query.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class ItineraryRepositoryImpl extends ItineraryRepository {
  final _apiService = sl<ItineraryApiServiceImpl>();

  @override
  Future<Either<Failure, ProvinceResponse>> getProvinces(ProvinceQuery? query) {
    return _apiService.getProvinces(query);
  }

  @override
  Future<Either<Failure, Province>> getProvinceById(int id) {
    return _apiService.getProvinceById(id);
  } 
}
