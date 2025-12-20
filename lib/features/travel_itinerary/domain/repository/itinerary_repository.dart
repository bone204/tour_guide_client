import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/create_itinerary_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/add_stop_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary_query.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/province.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/edit_stop_time_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/edit_stop_reorder_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/edit_stop_details_request.dart';

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
  Future<Either<Failure, Stop>> addStop(
    int itineraryId,
    AddStopRequest request,
  );
  Future<Either<Failure, Stop>> getStopDetail(int itineraryId, int stopId);
  Future<Either<Failure, SuccessResponse>> deleteItinerary(int id);
  Future<Either<Failure, Stop>> editStopTime(
    int itineraryId,
    int stopId,
    EditStopTimeRequest request,
  );
  Future<Either<Failure, Stop>> editStopReorder(
    int itineraryId,
    int stopId,
    EditStopReorderRequest request,
  );
  Future<Either<Failure, Stop>> editStopDetails(
    int itineraryId,
    int stopId,
    EditStopDetailsRequest request,
  );
  Future<Either<Failure, Stop>> uploadStopMedia(
    int itineraryId,
    int stopId,
    List<String> imagePaths,
    List<String> videoPaths,
  );
}
