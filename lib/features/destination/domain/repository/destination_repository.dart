import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_query.dart';
import 'package:tour_guide_app/features/destination/data/models/destination_response.dart';
import 'package:tour_guide_app/features/destination/data/models/feedback_request.dart';

abstract class DestinationRepository {
  Future<Either<Failure, DestinationResponse>> getDestinations(DestinationQuery destinationQuery);
  Future<Either<Failure, DestinationResponse>> getRecommendDestinations(DestinationQuery destinationQuery);
  Future<Either<Failure, Destination>> getDestinationById(int id);
  Future<Either<Failure, DestinationResponse>> getFavorites();
  Future<Either<Failure, Destination>> favoriteDestination(int id);
  Future<Either<Failure, SuccessResponse>> createFeedback(AddFeedbackRequest params);
}