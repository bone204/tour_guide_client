import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/cooperations/data/models/cooperation.dart';
import 'package:tour_guide_app/features/cooperations/domain/repository/cooperation_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class UnfavoriteCooperationUseCase
    implements
        UseCase<Either<Failure, Cooperation>, UnfavoriteCooperationParams> {
  @override
  Future<Either<Failure, Cooperation>> call(
    UnfavoriteCooperationParams params,
  ) async {
    return await sl<CooperationRepository>().unfavoriteCooperation(params.id);
  }
}

class UnfavoriteCooperationParams extends Equatable {
  final int id;

  const UnfavoriteCooperationParams({required this.id});

  @override
  List<Object?> get props => [id];
}
