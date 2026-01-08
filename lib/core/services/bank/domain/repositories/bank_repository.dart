import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/services/bank/data/models/bank.dart';

abstract class BankRepository {
  Future<Either<Failure, List<Bank>>> getBanks();
}
