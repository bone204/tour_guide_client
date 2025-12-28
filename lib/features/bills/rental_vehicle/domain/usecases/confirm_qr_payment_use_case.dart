import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/confirm_qr_payment_request.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/repository/rental_bill_repository.dart';

class ConfirmQrPaymentUseCase
    implements
        UseCase<Either<Failure, SuccessResponse>, ConfirmQrPaymentRequest> {
  final RentalBillRepository repository;

  ConfirmQrPaymentUseCase(this.repository);

  @override
  Future<Either<Failure, SuccessResponse>> call(
    ConfirmQrPaymentRequest params,
  ) async {
    return await repository.confirmQrPayment(params);
  }
}
