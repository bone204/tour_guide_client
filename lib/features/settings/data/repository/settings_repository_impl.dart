import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/settings/data/data_source/local/settings_local_service.dart';
import 'package:tour_guide_app/features/settings/domain/repository/settings_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  @override
  Future<Either<Failure, void>> logOut() async {
    try {
      await sl<SettingsLocalService>().logOut();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to clear local token'));
    }
  }
}
