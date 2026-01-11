import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/repository/my_vehicle_repository.dart';

class OwnerCancelBillUseCase {
  final MyVehicleRepository repository;

  OwnerCancelBillUseCase(this.repository);

  Future<Either<Failure, SuccessResponse>> call(int id, String reason) {
    return repository.ownerCancelBill(id, reason);
  }
}
