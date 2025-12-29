import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/owner_confirm_return_params.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/repository/my_vehicle_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class OwnerConfirmReturnUseCase
    implements
        UseCase<Either<Failure, SuccessResponse>, OwnerConfirmReturnParams> {
  @override
  Future<Either<Failure, SuccessResponse>> call(
    OwnerConfirmReturnParams params,
  ) async {
    return sl<MyVehicleRepository>().ownerConfirmReturn(
      params.id,
      params.photos,
      params.latitude,
      params.longitude,
      params.overtimeFeeAccepted,
    );
  }
}
