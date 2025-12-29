import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/cooperations/data/models/cooperation_response.dart';
import 'package:tour_guide_app/features/cooperations/domain/repository/cooperation_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetCooperationsUseCase
    implements
        UseCase<Either<Failure, CooperationResponse>, GetCooperationsParams> {
  @override
  Future<Either<Failure, CooperationResponse>> call(
    GetCooperationsParams params,
  ) async {
    return await sl<CooperationRepository>().getCooperations(
      type: params.type,
      city: params.city,
      province: params.province,
      active: params.active,
    );
  }
}

class GetCooperationsParams extends Equatable {
  final String? type;
  final String? city;
  final String? province;
  final bool? active;

  const GetCooperationsParams({
    this.type,
    this.city,
    this.province,
    this.active,
  });

  @override
  List<Object?> get props => [type, city, province, active];
}
