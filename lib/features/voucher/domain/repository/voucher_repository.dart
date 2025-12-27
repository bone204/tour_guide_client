import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/voucher/data/models/voucher.dart';

abstract class VoucherRepository {
  Future<Either<Failure, List<Voucher>>> getVouchers();
  Future<Either<Failure, Voucher>> getVoucherDetail(int id);
}
