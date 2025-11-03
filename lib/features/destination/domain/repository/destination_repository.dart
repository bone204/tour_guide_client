import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_query.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_response.dart';

abstract class DestinationRepository {
  Future<Either<Failure, DestinationResponse>> getDestinations(DestinationQuery destinationQuery);
  Future<Either<Failure, Destination>> getDestinationById(int id);
}