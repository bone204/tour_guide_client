import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/auth/domain/repository/auth_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class VerifyCitizenIdUseCase implements UseCase<Either<Failure, SuccessResponse>, VerifyCitizenIdParams> {
  @override
  Future<Either<Failure, SuccessResponse>> call(VerifyCitizenIdParams params) async {
    return await sl<AuthRepository>().verifyCitizenId(
      citizenFrontPhoto: params.citizenFrontPhoto,
      selfiePhoto: params.selfiePhoto,
    );
  }
}

class VerifyCitizenIdParams extends Equatable {
  final File citizenFrontPhoto;
  final File selfiePhoto;

  const VerifyCitizenIdParams({
    required this.citizenFrontPhoto,
    required this.selfiePhoto,
  });

  @override
  List<Object> get props => [citizenFrontPhoto, selfiePhoto];
}
