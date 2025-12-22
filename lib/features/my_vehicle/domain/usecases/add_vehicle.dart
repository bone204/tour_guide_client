import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/add_vehicle_request.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/repository/my_vehicle_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class AddVehicleUseCase
    implements UseCase<Either<Failure, SuccessResponse>, AddVehicleRequest> {
  @override
  Future<Either<Failure, SuccessResponse>> call(
    AddVehicleRequest params,
  ) async {
    return await sl<MyVehicleRepository>().addVehicle(params);
  }
}
