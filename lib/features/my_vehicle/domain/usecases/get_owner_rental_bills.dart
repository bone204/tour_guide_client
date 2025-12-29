import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/repository/my_vehicle_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class GetOwnerRentalBillsUseCase
    implements UseCase<Either<Failure, List<RentalBill>>, String?> {
  @override
  Future<Either<Failure, List<RentalBill>>> call(String? params) async {
    return await sl<MyVehicleRepository>().getOwnerRentalBills(params);
  }
}
