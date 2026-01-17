import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/cooperations/data/data_source/cooperation_api_service.dart';
import 'package:tour_guide_app/features/cooperations/data/models/cooperation.dart';
import 'package:tour_guide_app/features/cooperations/data/models/cooperation_response.dart';
import 'package:tour_guide_app/features/cooperations/domain/repository/cooperation_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class CooperationRepositoryImpl extends CooperationRepository {
  final _apiService = sl<CooperationApiService>();

  @override
  Future<Either<Failure, CooperationResponse>> getCooperations({
    String? type,
    String? city,
    String? province,
    bool? active,
  }) async {
    return await _apiService.getCooperations(
      type: type,
      city: city,
      province: province,
      active: active,
    );
  }

  @override
  Future<Either<Failure, Cooperation>> getCooperationById(int id) async {
    return await _apiService.getCooperationById(id);
  }

  @override
  Future<Either<Failure, CooperationResponse>> getFavorites() async {
    return await _apiService.getFavorites();
  }

  @override
  Future<Either<Failure, Cooperation>> favoriteCooperation(int id) async {
    return await _apiService.favoriteCooperation(id);
  }

  @override
  Future<Either<Failure, SuccessResponse>> deleteFavoriteCooperation(
    int id,
  ) async {
    return await _apiService.deleteFavoriteCooperation(id);
  }
}
