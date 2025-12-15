import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/province.dart';

abstract class ItineraryRepository {
  Future<Either<Failure, ProvinceResponse>> getProvinces(String? search);
}
