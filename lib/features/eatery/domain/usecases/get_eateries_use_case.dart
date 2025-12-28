import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/eatery/data/models/eatery.dart';
import 'package:tour_guide_app/features/eatery/domain/repository/eatery_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetEateriesParams extends Equatable {
  final String? province;
  final String? keyword;

  const GetEateriesParams({this.province, this.keyword});

  @override
  List<Object?> get props => [province, keyword];
}

class GetEateriesUseCase
    implements UseCase<Either<Failure, List<Eatery>>, GetEateriesParams> {
  @override
  Future<Either<Failure, List<Eatery>>> call(GetEateriesParams params) async {
    return await sl<EateryRepository>().getEateries(
      province: params.province,
      keyword: params.keyword,
    );
  }
}
