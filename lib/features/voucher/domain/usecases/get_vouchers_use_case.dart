import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/features/voucher/data/models/voucher.dart';
import 'package:tour_guide_app/features/voucher/domain/repository/voucher_repository.dart';

class GetVouchersUseCase
    implements UseCase<Either<Failure, List<Voucher>>, NoParams> {
  final VoucherRepository repository;

  GetVouchersUseCase(this.repository);

  @override
  Future<Either<Failure, List<Voucher>>> call(NoParams params) async {
    return await repository.getVouchers();
  }
}
