import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/create_itinerary_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary_query.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/province.dart';

abstract class ItineraryRepository {
  Future<Either<Failure, ItineraryResponse>> getItineraryMe();
  Future<Either<Failure, ItineraryResponse>> getItineraries(
    ItineraryQuery query,
  );
  Future<Either<Failure, Itinerary>> getItineraryDetail(int id);
  Future<Either<Failure, Itinerary>> createItinerary(
    CreateItineraryRequest request,
  );
  Future<Either<Failure, ProvinceResponse>> getProvinces(String? search);
}
