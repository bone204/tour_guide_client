import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/cooperations/data/models/cooperation.dart';
import 'package:tour_guide_app/features/cooperations/domain/repository/cooperation_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetCooperationDetailUseCase
    implements
        UseCase<Either<Failure, Cooperation>, GetCooperationDetailParams> {
  @override
  Future<Either<Failure, Cooperation>> call(
    GetCooperationDetailParams params,
  ) async {
    return await sl<CooperationRepository>().getCooperationById(params.id);
  }
}

class GetCooperationDetailParams extends Equatable {
  final int id;

  const GetCooperationDetailParams({required this.id});

  @override
  List<Object?> get props => [id];
}
