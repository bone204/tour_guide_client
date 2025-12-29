import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/cooperations/data/models/cooperation.dart';
import 'package:tour_guide_app/features/cooperations/domain/repository/cooperation_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class FavoriteCooperationUseCase
    implements
        UseCase<Either<Failure, Cooperation>, FavoriteCooperationParams> {
  @override
  Future<Either<Failure, Cooperation>> call(
    FavoriteCooperationParams params,
  ) async {
    return await sl<CooperationRepository>().favoriteCooperation(params.id);
  }
}

class FavoriteCooperationParams extends Equatable {
  final int id;

  const FavoriteCooperationParams({required this.id});

  @override
  List<Object?> get props => [id];
}
