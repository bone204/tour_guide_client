import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/province.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/province_query.dart';

abstract class ItineraryRepository {
  Future<Either<Failure, ProvinceResponse>> getProvinces(ProvinceQuery? query);
  Future<Either<Failure, Province>> getProvinceById(int id);
}
