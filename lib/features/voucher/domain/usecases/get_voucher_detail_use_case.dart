import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/voucher/data/models/voucher.dart';
import 'package:tour_guide_app/features/voucher/domain/repository/voucher_repository.dart';

class GetVoucherDetailUseCase
    implements UseCase<Either<Failure, Voucher>, int> {
  final VoucherRepository repository;

  GetVoucherDetailUseCase(this.repository);

  @override
  Future<Either<Failure, Voucher>> call(int id) async {
    return await repository.getVoucherDetail(id);
  }
}
