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
import 'package:tour_guide_app/features/chat_bot/domain/usecases/send_chat_message.dart';
import 'package:tour_guide_app/features/destination/data/data_source/destination_api_service.dart';
import 'package:tour_guide_app/features/destination/data/repository/destination_repository_impl.dart';
import 'package:tour_guide_app/features/destination/domain/repository/destination_repository.dart';
import 'package:tour_guide_app/features/destination/domain/usecases/create_feedback.dart';
import 'package:tour_guide_app/features/destination/domain/usecases/get_destination_by_id.dart';
import 'package:tour_guide_app/features/destination/domain/usecases/get_favorites.dart';
import 'package:tour_guide_app/features/destination/domain/usecases/favorite_destination.dart';
import 'package:tour_guide_app/features/home/domain/usecases/get_destinations.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_destination_cubit.dart';
import 'package:tour_guide_app/features/settings/data/data_source/local/settings_local_service.dart';
import 'package:tour_guide_app/features/settings/data/repository/settings_repository_impl.dart';
import 'package:tour_guide_app/features/settings/domain/repository/settings_repository.dart';
import 'package:tour_guide_app/features/settings/domain/usecases/logout.dart';
import 'package:tour_guide_app/features/chat_bot/data/data_source/chat_api_service.dart';
import 'package:tour_guide_app/features/chat_bot/data/repository/chat_repository_impl.dart';
import 'package:tour_guide_app/features/chat_bot/domain/repository/chat_repository.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/data_source/itinerary_api_service.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/add_stop_media.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/stop_media/stop_media_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/edit_stop/edit_stop_cubit.dart';

import 'package:tour_guide_app/features/travel_itinerary/data/repository/itinerary_repository_impl.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/create_itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/edit_stop_details.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/edit_stop_reorder.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/edit_stop_time.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/get_itineraries.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/get_itinerary_detail.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/get_itinerary_me.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/get_provinces.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/add_stop.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/get_stop_detail.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/create_itinerary/create_itinerary_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/my_itinerary/bloc/get_itinerary_me/get_itinerary_me_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/get_itinerary_detail/get_itinerary_detail_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/add_stop/add_stop_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/get_stop_detail/get_stop_detail_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/delete_itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/delete_itinerary/delete_itinerary_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/delete_itinerary_stop.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/delete_stop/delete_stop_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/delete_stop_media.dart';

final sl = GetIt.instance;

void setUpServiceLocator(SharedPreferences prefs) {
  sl.registerSingleton<DioClient>(DioClient(prefs));
  sl.registerSingleton<SharedPreferences>(prefs);

  // Services
  sl.registerSingleton<AuthApiService>(AuthApiServiceImpl());
  sl.registerSingleton<AuthLocalService>(AuthLocalServiceImpl());
  sl.registerSingleton<SettingsLocalService>(SettingsLocalServiceImpl());
  sl.registerSingleton<DestinationApiService>(DestinationApiServiceImpl());
  sl.registerSingleton<ChatApiService>(ChatApiServiceImpl());
  sl.registerSingleton<ItineraryApiService>(ItineraryApiServiceImpl());
  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<SettingsRepository>(SettingsRepositoryImpl());
  sl.registerSingleton<DestinationRepository>(DestinationRepositoryImpl());
  sl.registerSingleton<ChatRepository>(ChatRepositoryImpl());
  sl.registerSingleton<ItineraryRepository>(ItineraryRepositoryImpl());

  // Usecases
  sl.registerSingleton<SignInUseCase>(SignInUseCase());
  sl.registerSingleton<SignUpUseCase>(SignUpUseCase());
  sl.registerSingleton<IsLoggedInUseCase>(IsLoggedInUseCase());
  sl.registerSingleton<LogOutUseCase>(LogOutUseCase());
  sl.registerSingleton<GetDestinationByIdUseCase>(GetDestinationByIdUseCase());
  sl.registerSingleton<GetDestinationUseCase>(GetDestinationUseCase());
  sl.registerSingleton<GetFavoritesUseCase>(GetFavoritesUseCase());
  sl.registerSingleton<FavoriteDestinationUseCase>(
    FavoriteDestinationUseCase(),
  );
  sl.registerSingleton<SendChatMessageUseCase>(SendChatMessageUseCase());
  sl.registerSingleton<GetProvincesUseCase>(GetProvincesUseCase());
  sl.registerSingleton<GetItineraryMeUseCase>(GetItineraryMeUseCase());
  sl.registerSingleton<GetItinerariesUseCase>(GetItinerariesUseCase());
  sl.registerSingleton<GetItineraryDetailUseCase>(GetItineraryDetailUseCase());
  sl.registerSingleton<CreateItineraryUseCase>(CreateItineraryUseCase());
  sl.registerSingleton<AddStopUseCase>(AddStopUseCase());
  sl.registerSingleton<GetStopDetailUseCase>(GetStopDetailUseCase());
  sl.registerSingleton<DeleteItineraryUseCase>(DeleteItineraryUseCase());
  sl.registerSingleton<EditStopTimeUseCase>(EditStopTimeUseCase());
  sl.registerSingleton<EditStopReorderUseCase>(EditStopReorderUseCase());
  sl.registerSingleton<EditStopDetailsUseCase>(EditStopDetailsUseCase());
  sl.registerSingleton<CreateFeedbackUseCase>(CreateFeedbackUseCase());
  sl.registerSingleton<DeleteItineraryStopUseCase>(
    DeleteItineraryStopUseCase(sl()),
  );
  sl.registerSingleton<AddStopMediaUseCase>(AddStopMediaUseCase());
  sl.registerSingleton<DeleteStopMediaUseCase>(DeleteStopMediaUseCase());

  // Cubits
  sl.registerFactory<DeleteStopCubit>(() => DeleteStopCubit(sl()));
  sl.registerFactory<GetDestinationCubit>(() => GetDestinationCubit());
  sl.registerFactory<CreateItineraryCubit>(
    () => CreateItineraryCubit(createItineraryUseCase: sl()),
  );
  sl.registerFactory<GetItineraryMeCubit>(() => GetItineraryMeCubit(sl()));
  sl.registerFactory<GetItineraryDetailCubit>(
    () => GetItineraryDetailCubit(sl()),
  );
  sl.registerFactory<AddStopCubit>(() => AddStopCubit(sl()));
  sl.registerFactory<GetStopDetailCubit>(() => GetStopDetailCubit(sl()));
  sl.registerFactory<DeleteItineraryCubit>(() => DeleteItineraryCubit(sl()));
  sl.registerFactory<EditStopCubit>(() => EditStopCubit(sl(), sl(), sl()));
  sl.registerFactory<StopMediaCubit>(() => StopMediaCubit(sl(), sl(), sl()));
}
