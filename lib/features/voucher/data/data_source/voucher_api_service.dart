import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/features/voucher/data/models/voucher.dart';
import 'package:tour_guide_app/service_locator.dart';

abstract class VoucherApiService {
  Future<Either<Failure, List<Voucher>>> getVouchers();
  Future<Either<Failure, Voucher>> getVoucherDetail(int id);
}

class VoucherApiServiceImpl extends VoucherApiService {
  @override
  Future<Either<Failure, List<Voucher>>> getVouchers() async {
    try {
      final response = await sl<DioClient>().get(ApiUrls.vouchers);
      final List<dynamic> data = response.data;
      final vouchers = data.map((json) => Voucher.fromJson(json)).toList();
      return Right(vouchers);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Voucher>> getVoucherDetail(int id) async {
    try {
      final response = await sl<DioClient>().get('${ApiUrls.vouchers}/$id');
      final voucher = Voucher.fromJson(response.data);
      return Right(voucher);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Unknown error',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
