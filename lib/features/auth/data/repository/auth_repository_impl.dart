import 'package:tour_guide_app/features/auth/data/data_sources/local/auth_local_service.dart';
import 'package:tour_guide_app/features/auth/domain/repository/auth_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  final _localService = sl<AuthLocalService>();

  @override
  Future<bool> isLoggedIn() async {
    return await _localService.isLoggedIn();
  }
}
