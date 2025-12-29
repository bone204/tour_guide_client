import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/success/success_response.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/user_return_request_params.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/repository/rental_bill_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class UserReturnRequestUseCase
    implements
        UseCase<Either<Failure, SuccessResponse>, UserReturnRequestParams> {
  @override
  Future<Either<Failure, SuccessResponse>> call(
    UserReturnRequestParams params,
  ) async {
    return sl<RentalBillRepository>().userReturnRequest(
      params.id,
      params.photos,
      params.latitude,
      params.longitude,
    );
  }
}
