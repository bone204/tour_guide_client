import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/pay_visa_request.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/repository/rental_bill_repository.dart';

class PayVisaUseCase
    implements UseCase<Either<Failure, SuccessResponse>, PayVisaRequest> {
  final RentalBillRepository repository;

  PayVisaUseCase(this.repository);

  @override
  Future<Either<Failure, SuccessResponse>> call(PayVisaRequest params) async {
    return await repository.payVisa(params);
  }
}
