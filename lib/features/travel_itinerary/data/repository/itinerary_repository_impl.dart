import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/data_source/itinerary_api_service.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/create_itinerary_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/add_stop_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary_query.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/province.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class ItineraryRepositoryImpl extends ItineraryRepository {
  final _apiService = sl<ItineraryApiService>();

  @override
  Future<Either<Failure, ItineraryResponse>> getItineraryMe() {
    return _apiService.getItineraryMe();
  }

  @override
  Future<Either<Failure, ItineraryResponse>> getItineraries(
    ItineraryQuery query,
  ) {
    return _apiService.getItineraries(query.toQuery());
  }

  @override
  Future<Either<Failure, Itinerary>> getItineraryDetail(int id) {
    return _apiService.getItineraryDetail(id);
  }

  @override
  Future<Either<Failure, Itinerary>> createItinerary(
    CreateItineraryRequest request,
  ) {
    return _apiService.createItinerary(request);
  }

  @override
  Future<Either<Failure, ProvinceResponse>> getProvinces(String? search) {
    return _apiService.getProvinces(search);
  }

  @override
  Future<Either<Failure, Stop>> addStop(
    int itineraryId,
    AddStopRequest request,
  ) {
    return _apiService.addStop(itineraryId, request);
  }
}
