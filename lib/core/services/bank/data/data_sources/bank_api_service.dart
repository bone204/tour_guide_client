import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/services/bank/data/models/bank.dart';

abstract class BankApiService {
  Future<Either<Failure, List<Bank>>> getBanks();
}

class BankApiServiceImpl implements BankApiService {
  final Dio _dio;

  BankApiServiceImpl() : _dio = Dio();

  @override
  Future<Either<Failure, List<Bank>>> getBanks() async {
    try {
      final response = await _dio.get('https://api.vietqr.io/v2/banks');

      if (response.statusCode == 200) {
        final bankResponse = BankResponse.fromJson(response.data);
        return Right(bankResponse.data);
      } else {
        return Left(ServerFailure(message: 'Failed to load banks'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Unknown Dio error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
