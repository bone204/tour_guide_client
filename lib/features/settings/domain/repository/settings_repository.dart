import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';

abstract class SettingsRepository {
  Future<Either<Failure, void>> logOut();
}
