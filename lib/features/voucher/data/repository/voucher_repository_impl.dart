import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/voucher/data/data_source/voucher_api_service.dart';
import 'package:tour_guide_app/features/voucher/data/models/voucher.dart';
import 'package:tour_guide_app/features/voucher/domain/repository/voucher_repository.dart';

class VoucherRepositoryImpl implements VoucherRepository {
  final VoucherApiService apiService;

  VoucherRepositoryImpl({required this.apiService});

  @override
  Future<Either<Failure, List<Voucher>>> getVouchers() async {
    return await apiService.getVouchers();
  }

  @override
  Future<Either<Failure, Voucher>> getVoucherDetail(int id) async {
    return await apiService.getVoucherDetail(id);
  }
}
