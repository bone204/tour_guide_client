import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/data_source/itinerary_api_service.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/create_itinerary_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/add_stop_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/edit_stop_time_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/edit_stop_reorder_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/edit_stop_details_request.dart';
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
  Future<Either<Failure, ItineraryResponse>> getDraftItineraries(
    String? province,
  ) {
    return _apiService.getDraftItineraries(province);
  }

  @override
  Future<Either<Failure, ItineraryResponse>> getItineraries(
    ItineraryQuery query,
  ) {
    return _apiService.getItineraries(query);
  }

  @override
  Future<Either<Failure, Itinerary>> getItineraryDetail(int id) {
    return _apiService.getItineraryDetail(id);
  }

  @override
  Future<Either<Failure, SuccessResponse>> deleteItinerary(int id) {
    return _apiService.deleteItinerary(id);
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

  @override
  Future<Either<Failure, Stop>> getStopDetail(int itineraryId, int stopId) {
    return _apiService.getStopDetail(itineraryId, stopId);
  }

  @override
  Future<Either<Failure, Stop>> editStopTime(
    int itineraryId,
    int stopId,
    EditStopTimeRequest request,
  ) {
    return _apiService.editStopTime(itineraryId, stopId, request);
  }

  @override
  Future<Either<Failure, Stop>> editStopReorder(
    int itineraryId,
    int stopId,
    EditStopReorderRequest request,
  ) {
    return _apiService.editStopReorder(itineraryId, stopId, request);
  }

  @override
  Future<Either<Failure, Stop>> editStopDetails(
    int itineraryId,
    int stopId,
    EditStopDetailsRequest request,
  ) {
    return _apiService.editStopDetails(itineraryId, stopId, request);
  }

  @override
  Future<Either<Failure, Stop>> uploadStopMedia(
    int itineraryId,
    int stopId,
    List<String> imagePaths,
    List<String> videoPaths,
  ) {
    return _apiService.uploadStopMedia(
      itineraryId,
      stopId,
      imagePaths,
      videoPaths,
    );
  }

  @override
  Future<Either<Failure, Stop>> deleteStopMedia(
    int itineraryId,
    int stopId,
    List<String> images,
    List<String> videos,
  ) {
    return _apiService.deleteStopMedia(itineraryId, stopId, images, videos);
  }

  @override
  Future<Either<Failure, SuccessResponse>> deleteStop(
    int itineraryId,
    int stopId,
  ) {
    return _apiService.deleteStop(itineraryId, stopId);
  }

  @override
  Future<Either<Failure, Itinerary>> publicizeItinerary(int itineraryId) {
    return _apiService.publicizeItinerary(itineraryId);
  }

  @override
  Future<Either<Failure, SuccessResponse>> likeItinerary(int itineraryId) {
    return _apiService.likeItinerary(itineraryId);
  }

  @override
  Future<Either<Failure, SuccessResponse>> unlikeItinerary(int itineraryId) {
    return _apiService.unlikeItinerary(itineraryId);
  }
}
