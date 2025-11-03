import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/features/auth/data/data_sources/local/auth_local_service.dart';
import 'package:tour_guide_app/features/auth/data/data_sources/remote/auth_api_service.dart';
import 'package:tour_guide_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:tour_guide_app/features/auth/domain/repository/auth_repository.dart';
import 'package:tour_guide_app/features/auth/domain/usecases/is_logged_in.dart';
import 'package:tour_guide_app/features/auth/domain/usecases/sign_in.dart';
import 'package:tour_guide_app/features/auth/domain/usecases/sign_up.dart';
import 'package:tour_guide_app/features/destination/data/data_source/destination_api_service.dart';
import 'package:tour_guide_app/features/destination/data/repository/destination_repository_impl.dart';
import 'package:tour_guide_app/features/destination/domain/repository/destination_repository.dart';
import 'package:tour_guide_app/features/destination/domain/usecases/get_destination_by_id.dart';
import 'package:tour_guide_app/features/home/domain/usecases/get_destinations.dart';
import 'package:tour_guide_app/features/settings/data/data_source/local/settings_local_service.dart';
import 'package:tour_guide_app/features/settings/data/repository/settings_repository_impl.dart';
import 'package:tour_guide_app/features/settings/domain/repository/settings_repository.dart';
import 'package:tour_guide_app/features/settings/domain/usecases/logout.dart';

final sl = GetIt.instance;

void setUpServiceLocator(SharedPreferences prefs) {
  sl.registerSingleton<DioClient>(DioClient(prefs));
  sl.registerSingleton<SharedPreferences>(prefs);

  // Services
  sl.registerSingleton<AuthApiService>(AuthApiServiceImpl());
  sl.registerSingleton<AuthLocalService>(AuthLocalServiceImpl());
  sl.registerSingleton<SettingsLocalService>(SettingsLocalServiceImpl());
  sl.registerSingleton<DestinationApiService>(DestinationApiServiceImpl());
  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<SettingsRepository>(SettingsRepositoryImpl());
  sl.registerSingleton<DestinationRepository>(DestinationRepositoryImpl());

  // Usecases
  sl.registerSingleton<SignInUseCase>(SignInUseCase());
  sl.registerSingleton<SignUpUseCase>(SignUpUseCase());
  sl.registerSingleton<IsLoggedInUseCase>(IsLoggedInUseCase());
  sl.registerSingleton<LogOutUseCase>(LogOutUseCase());
  sl.registerSingleton<GetDestinationByIdUseCase>(GetDestinationByIdUseCase());
  sl.registerSingleton<GetDestinationUseCase>(GetDestinationUseCase());
}
