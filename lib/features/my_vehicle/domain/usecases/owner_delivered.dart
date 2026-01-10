import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/owner_delivered_params.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/repository/my_vehicle_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class OwnerDeliveredUseCase
    implements UseCase<Either<Failure, SuccessResponse>, OwnerDeliveredParams> {
  @override
  Future<Either<Failure, SuccessResponse>> call(
    OwnerDeliveredParams params,
  ) async {
    return sl<MyVehicleRepository>().ownerDelivered(
      params.id,
      params.photos,
      params.latitude,
      params.longitude,
    );
  }
}
