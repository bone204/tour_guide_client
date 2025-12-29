import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/cooperations/data/models/cooperation_response.dart';
import 'package:tour_guide_app/features/cooperations/domain/repository/cooperation_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetFavoriteCooperationsUseCase
    implements UseCase<Either<Failure, CooperationResponse>, NoParams> {
  @override
  Future<Either<Failure, CooperationResponse>> call(NoParams params) async {
    return await sl<CooperationRepository>().getFavorites();
  }
}
