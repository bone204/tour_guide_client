import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/settings/domain/repository/settings_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class LogOutUseCase implements UseCase<void, NoParams> {
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await sl<SettingsRepository>().logOut();
  }
}