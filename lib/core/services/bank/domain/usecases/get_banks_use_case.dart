import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/core/services/bank/data/models/bank.dart';
import 'package:tour_guide_app/core/services/bank/domain/repositories/bank_repository.dart';

class GetBanksUseCase
    implements UseCase<Either<Failure, List<Bank>>, NoParams> {
  final BankRepository _repository;

  GetBanksUseCase(this._repository);

  @override
  Future<Either<Failure, List<Bank>>> call(NoParams params) async {
    return await _repository.getBanks();
  }
}
