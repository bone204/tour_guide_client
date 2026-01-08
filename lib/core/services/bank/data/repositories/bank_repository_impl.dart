import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/services/bank/data/data_sources/bank_api_service.dart';
import 'package:tour_guide_app/core/services/bank/data/models/bank.dart';
import 'package:tour_guide_app/core/services/bank/domain/repositories/bank_repository.dart';

class BankRepositoryImpl implements BankRepository {
  final BankApiService _apiService;

  BankRepositoryImpl(this._apiService);

  @override
  Future<Either<Failure, List<Bank>>> getBanks() async {
    return await _apiService.getBanks();
  }
}
