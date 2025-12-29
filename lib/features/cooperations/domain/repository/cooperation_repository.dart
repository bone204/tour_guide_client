import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/cooperations/data/models/cooperation.dart';
import 'package:tour_guide_app/features/cooperations/data/models/cooperation_response.dart';

abstract class CooperationRepository {
  Future<Either<Failure, CooperationResponse>> getCooperations({
    String? type,
    String? city,
    String? province,
    bool? active,
  });
  Future<Either<Failure, Cooperation>> getCooperationById(int id);
  Future<Either<Failure, CooperationResponse>> getFavorites();
  Future<Either<Failure, Cooperation>> favoriteCooperation(int id);
  Future<Either<Failure, Cooperation>> unfavoriteCooperation(int id);
}
