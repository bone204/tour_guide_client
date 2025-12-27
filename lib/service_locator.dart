import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/core/services/feedback/data/data_sources/feedback_api_service.dart';
import 'package:tour_guide_app/core/services/feedback/data/repositories/feedback_repository_impl.dart';
import 'package:tour_guide_app/features/auth/data/data_sources/local/auth_local_service.dart';
import 'package:tour_guide_app/features/auth/data/data_sources/remote/auth_api_service.dart';
import 'package:tour_guide_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:tour_guide_app/features/auth/domain/repository/auth_repository.dart';
import 'package:tour_guide_app/features/auth/domain/usecases/is_logged_in.dart';
import 'package:tour_guide_app/features/auth/domain/usecases/phone_start.dart';
import 'package:tour_guide_app/features/auth/domain/usecases/sign_in.dart';
import 'package:tour_guide_app/features/auth/domain/usecases/sign_up.dart';
import 'package:tour_guide_app/features/auth/domain/usecases/email_start.dart';
import 'package:tour_guide_app/features/auth/domain/usecases/verify_email.dart';
import 'package:tour_guide_app/features/auth/domain/usecases/verify_phone.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/get_my_rental_bills/get_my_rental_bills_cubit.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/get_rental_bill_detail/get_rental_bill_detail_cubit.dart';
import 'package:tour_guide_app/features/chat_bot/domain/usecases/send_chat_message.dart';
import 'package:tour_guide_app/features/destination/data/data_source/destination_api_service.dart';
import 'package:tour_guide_app/features/destination/data/repository/destination_repository_impl.dart';
import 'package:tour_guide_app/features/destination/domain/repository/destination_repository.dart';
import 'package:tour_guide_app/features/destination/domain/usecases/get_destination_by_id.dart';
import 'package:tour_guide_app/features/destination/domain/usecases/get_favorites.dart';
import 'package:tour_guide_app/features/destination/domain/usecases/favorite_destination.dart';
import 'package:tour_guide_app/features/destination/domain/usecases/get_destinations.dart';
import 'package:tour_guide_app/features/destination/domain/usecases/get_recommend_destinations.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_destinations/get_destination_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/disable_vehicle.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/enable_vehicle.dart';
import 'package:tour_guide_app/features/profile/data/data_source/profile_api_service.dart';
import 'package:tour_guide_app/features/profile/data/repository/profile_repository_impl.dart';
import 'package:tour_guide_app/features/profile/domain/repository/profile_repository.dart';
import 'package:tour_guide_app/features/profile/domain/usecases/get_my_profile.dart';
import 'package:tour_guide_app/features/motorbike_rental/data/data_source/motorbike_rental_api_service.dart';
import 'package:tour_guide_app/features/motorbike_rental/data/repository/motorbike_rental_repository_impl.dart';
import 'package:tour_guide_app/features/motorbike_rental/domain/repository/motorbike_rental_repository.dart';
import 'package:tour_guide_app/features/motorbike_rental/domain/usecases/search_motorbikes_use_case.dart';

import 'package:tour_guide_app/features/settings/data/data_source/local/settings_local_service.dart';
import 'package:tour_guide_app/features/settings/data/repository/settings_repository_impl.dart';
import 'package:tour_guide_app/features/settings/domain/repository/settings_repository.dart';
import 'package:tour_guide_app/features/settings/domain/usecases/logout.dart';
import 'package:tour_guide_app/features/chat_bot/data/data_source/chat_api_service.dart';
import 'package:tour_guide_app/features/chat_bot/data/repository/chat_repository_impl.dart';
import 'package:tour_guide_app/features/chat_bot/domain/repository/chat_repository.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/data_source/itinerary_api_service.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/get_draft_itineraries.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/create_feedback.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/get_feedback.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/check_content.dart';
import 'package:tour_guide_app/core/services/feedback/domain/repositories/feedback_repository.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/comment/comment_cubit.dart';
import 'package:tour_guide_app/features/destination/presentation/bloc/comment/destination_comment_cubit.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/create_feedback_reply.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/get_feedback_replies.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/reply/reply_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/use_itinerary.dart'; // Add this
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/use_itinerary/use_itinerary_cubit.dart'; // Add this

import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/like_itinerary_usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/unlike_itinerary_usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/stop_media/stop_media_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/edit_stop/edit_stop_cubit.dart';

import 'package:tour_guide_app/features/travel_itinerary/data/repository/itinerary_repository_impl.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/repository/itinerary_repository.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/create_itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/like_itinerary/like_itinerary_cubit.dart';
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
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/add_stop_media.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/delete_stop_media.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/publicize_itinerary.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_contracts/get_contracts_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/vehicle_detail/vehicle_detail_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/contract_detail/contract_detail_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/create_contract/create_contract_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_my_vehicles/get_my_vehicles_cubit.dart';
import 'package:tour_guide_app/features/auth/presentation/bloc/verify_email/verify_email_cubit.dart';
import 'package:tour_guide_app/features/auth/presentation/bloc/verify_phone/verify_phone_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/get_draft_itineraries/get_draft_itineraries_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/publicize_itinerary/publicize_itinerary_cubit.dart';
import 'features/travel_itinerary/presentation/itinerary_explore/bloc/itinerary_explore_detail/itinerary_explore_detail_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/data/data_source/my_vehicle_api_service.dart';
import 'package:tour_guide_app/features/my_vehicle/data/repository/my_vehicle_repository_impl.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/repository/my_vehicle_repository.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/add_contract.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/add_vehicle.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/get_my_contracts.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/get_my_contract_detail.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/get_my_vehicles.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/get_vehicle_detail.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_cubit.dart';
import 'package:tour_guide_app/features/profile/domain/usecases/update_initial_profile.dart';
import 'package:tour_guide_app/features/profile/domain/usecases/update_verification_info.dart';
import 'package:tour_guide_app/features/profile/domain/usecases/update_avatar.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/edit_profile/edit_profile_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/get_vehicle_catalogs.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/add_vehicle/add_vehicle_cubit.dart';
import 'package:tour_guide_app/features/auth/domain/usecases/update_hobbies.dart';
import 'package:tour_guide_app/features/auth/presentation/bloc/update_hobbies/update_hobbies_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/enable_disable_vehicle/enable_disable_vehicle_cubit.dart';
import 'package:tour_guide_app/features/motorbike_rental/presentation/bloc/search_motorbike/search_motorbike_cubit.dart';
import 'package:tour_guide_app/features/motorbike_rental/presentation/bloc/create_rental_bill/create_rental_bill_cubit.dart';
import 'package:tour_guide_app/features/motorbike_rental/presentation/bloc/motorbike_detail/motorbike_detail_cubit.dart';
import 'package:tour_guide_app/features/motorbike_rental/domain/usecases/get_motorbike_detail_use_case.dart';
import 'package:tour_guide_app/features/motorbike_rental/domain/usecases/create_rental_bill_use_case.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/data_source/rental_bill_api_service.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/repository/rental_bill_repository_impl.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/repository/rental_bill_repository.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/usecases/get_my_rental_bills_use_case.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/usecases/get_rental_bill_detail_use_case.dart';

import 'package:tour_guide_app/features/voucher/data/data_source/voucher_api_service.dart';
import 'package:tour_guide_app/features/voucher/data/repository/voucher_repository_impl.dart';
import 'package:tour_guide_app/features/voucher/domain/repository/voucher_repository.dart';
import 'package:tour_guide_app/features/voucher/domain/usecases/get_voucher_detail_use_case.dart';
import 'package:tour_guide_app/features/voucher/domain/usecases/get_vouchers_use_case.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_vouchers/get_vouchers_cubit.dart';

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
  sl.registerSingleton<MyVehicleApiService>(MyVehicleApiServiceImpl());
  sl.registerSingleton<ProfileApiService>(ProfileApiServiceImpl());
  sl.registerSingleton<FeedbackApiService>(FeedbackApiServiceImpl());
  sl.registerSingleton<MotorbikeRentalApiService>(
    MotorbikeRentalApiServiceImpl(),
  );
  sl.registerSingleton<RentalBillApiService>(RentalBillApiServiceImpl());
  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<SettingsRepository>(SettingsRepositoryImpl());
  sl.registerSingleton<DestinationRepository>(DestinationRepositoryImpl());
  sl.registerSingleton<ChatRepository>(ChatRepositoryImpl());
  sl.registerSingleton<ItineraryRepository>(ItineraryRepositoryImpl());
  sl.registerSingleton<MyVehicleRepository>(MyVehicleRepositoryImpl());
  sl.registerSingleton<ProfileRepository>(ProfileRepositoryImpl());
  sl.registerSingleton<FeedbackRepository>(FeedbackRepositoryImpl());
  sl.registerSingleton<MotorbikeRentalRepository>(
    MotorbikeRentalRepositoryImpl(),
  );
  sl.registerSingleton<RentalBillRepository>(RentalBillRepositoryImpl());

  // Usecases
  sl.registerSingleton<SignInUseCase>(SignInUseCase());
  sl.registerSingleton<SignUpUseCase>(SignUpUseCase());
  sl.registerSingleton<IsLoggedInUseCase>(IsLoggedInUseCase());
  sl.registerSingleton<LogOutUseCase>(LogOutUseCase());
  sl.registerSingleton<EmailStartUseCase>(EmailStartUseCase());
  sl.registerSingleton<VerifyEmailUseCase>(VerifyEmailUseCase());
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
  sl.registerSingleton<GetDraftItinerariesUseCase>(
    GetDraftItinerariesUseCase(),
  );
  sl.registerSingleton<GetItineraryDetailUseCase>(GetItineraryDetailUseCase());
  sl.registerSingleton<CreateItineraryUseCase>(CreateItineraryUseCase());
  sl.registerSingleton<AddStopUseCase>(AddStopUseCase());
  sl.registerSingleton<GetStopDetailUseCase>(GetStopDetailUseCase());
  sl.registerSingleton<DeleteItineraryUseCase>(DeleteItineraryUseCase());
  sl.registerSingleton<EditStopTimeUseCase>(EditStopTimeUseCase());
  sl.registerSingleton<EditStopReorderUseCase>(EditStopReorderUseCase());
  sl.registerSingleton<EditStopDetailsUseCase>(EditStopDetailsUseCase());
  sl.registerSingleton<CreateFeedbackUseCase>(CreateFeedbackUseCase());
  sl.registerSingleton<GetFeedbackUseCase>(GetFeedbackUseCase());
  sl.registerSingleton<CheckContentUseCase>(CheckContentUseCase());
  sl.registerLazySingleton(() => SearchMotorbikesUseCase());
  sl.registerLazySingleton(() => GetMotorbikeDetailUseCase());
  sl.registerLazySingleton(() => CreateRentalBillUseCase());
  sl.registerSingleton<DeleteItineraryStopUseCase>(
    DeleteItineraryStopUseCase(sl()),
  );
  sl.registerSingleton<GetMyProfileUseCase>(GetMyProfileUseCase());
  sl.registerLazySingleton<DeleteStopMediaUseCase>(
    () => DeleteStopMediaUseCase(),
  );
  sl.registerLazySingleton<AddStopMediaUseCase>(() => AddStopMediaUseCase());
  sl.registerSingleton<PublicizeItineraryUseCase>(
    PublicizeItineraryUseCase(sl()),
  );

  sl.registerSingleton<UseItineraryUseCase>(UseItineraryUseCase()); // Add this

  // Like Itinerary
  sl.registerSingleton<LikeItineraryUseCase>(LikeItineraryUseCase());
  sl.registerSingleton<UnlikeItineraryUseCase>(UnlikeItineraryUseCase());

  sl.registerFactory<LikeItineraryCubit>(() => LikeItineraryCubit());
  sl.registerFactory<UseItineraryCubit>(
    () => UseItineraryCubit(sl()),
  ); // Add this
  sl.registerFactory<PublicizeItineraryCubit>(
    () => PublicizeItineraryCubit(sl()),
  );
  sl.registerFactory<ItineraryExploreDetailCubit>(
    () => ItineraryExploreDetailCubit(sl()),
  );
  sl.registerSingleton<UpdateInitialProfileUseCase>(
    UpdateInitialProfileUseCase(),
  );
  sl.registerSingleton<UpdateVerificationInfoUseCase>(
    UpdateVerificationInfoUseCase(),
  );
  sl.registerSingleton<UpdateAvatarUseCase>(UpdateAvatarUseCase());
  sl.registerSingleton<PhoneStartUseCase>(PhoneStartUseCase());
  sl.registerSingleton<VerifyPhoneUseCase>(VerifyPhoneUseCase());
  sl.registerSingleton<UpdateHobbiesUseCase>(UpdateHobbiesUseCase());
  sl.registerSingleton<GetRecommendDestinationsUseCase>(
    GetRecommendDestinationsUseCase(),
  );
  sl.registerSingleton<EnableVehicleUseCase>(EnableVehicleUseCase());
  sl.registerSingleton<DisableVehicleUseCase>(DisableVehicleUseCase());

  // My Vehicle
  sl.registerSingleton<AddContractUseCase>(AddContractUseCase());
  sl.registerSingleton<GetMyContractsUseCase>(GetMyContractsUseCase());
  sl.registerSingleton<GetMyContractDetailUseCase>(
    GetMyContractDetailUseCase(),
  );
  // Rental Vehicles
  sl.registerSingleton<AddVehicleUseCase>(AddVehicleUseCase());
  sl.registerLazySingleton(() => GetMyVehiclesUseCase());
  sl.registerSingleton<GetVehicleDetailUseCase>(GetVehicleDetailUseCase());
  sl.registerSingleton<GetVehicleCatalogsUseCase>(
    GetVehicleCatalogsUseCase(sl()),
  );
  sl.registerSingleton<GetMyRentalBillsUseCase>(GetMyRentalBillsUseCase());
  sl.registerSingleton<GetRentalBillDetailUseCase>(
    GetRentalBillDetailUseCase(),
  );

  // Cubits
  sl.registerFactory<DeleteStopCubit>(() => DeleteStopCubit(sl()));
  sl.registerFactory(() => GetContractsCubit(sl()));
  sl.registerFactory(() => GetMyVehiclesCubit(sl()));
  sl.registerFactory(
    () => ContractDetailCubit(getMyContractDetailUseCase: sl()),
  );
  sl.registerFactory(() => VehicleDetailCubit(getVehicleDetailUseCase: sl()));
  sl.registerFactory(
    () => AddVehicleCubit(
      addVehicleUseCase: sl(),
      getMyContractsUseCase: sl(),
      getVehicleCatalogsUseCase: sl(),
    ),
  );
  sl.registerFactory<GetDestinationCubit>(() => GetDestinationCubit());
  sl.registerFactory<CreateItineraryCubit>(
    () => CreateItineraryCubit(createItineraryUseCase: sl()),
  );
  sl.registerFactory<GetItineraryMeCubit>(() => GetItineraryMeCubit(sl()));
  sl.registerFactory<GetDraftItinerariesCubit>(
    () => GetDraftItinerariesCubit(sl()),
  );
  sl.registerFactory<GetItineraryDetailCubit>(
    () => GetItineraryDetailCubit(sl()),
  );
  sl.registerFactory<AddStopCubit>(() => AddStopCubit(sl()));
  sl.registerFactory<GetStopDetailCubit>(() => GetStopDetailCubit(sl()));
  sl.registerFactory<DeleteItineraryCubit>(() => DeleteItineraryCubit(sl()));
  sl.registerFactory<EditStopCubit>(() => EditStopCubit(sl(), sl(), sl()));
  sl.registerFactory<StopMediaCubit>(() => StopMediaCubit(sl(), sl(), sl()));
  sl.registerFactory<CreateContractCubit>(() => CreateContractCubit());
  sl.registerFactory<GetMyProfileCubit>(() => GetMyProfileCubit(sl()));
  sl.registerFactory<EditProfileCubit>(
    () => EditProfileCubit(
      updateInitialProfileUseCase: sl(),
      updateVerificationInfoUseCase: sl(),
      updateAvatarUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => EnableDisableVehicleCubit(
      enableVehicleUseCase: sl(),
      disableVehicleUseCase: sl(),
    ),
  );
  sl.registerFactory<VerifyEmailCubit>(() => VerifyEmailCubit());
  sl.registerFactory<VerifyPhoneCubit>(() => VerifyPhoneCubit());
  sl.registerFactory<CommentCubit>(
    () => CommentCubit(
      getFeedbackUseCase: sl(),
      createFeedbackUseCase: sl(),
      checkContentUseCase: sl(),
    ),
  );
  sl.registerFactory<DestinationCommentCubit>(
    () => DestinationCommentCubit(
      getFeedbackUseCase: sl(),
      createFeedbackUseCase: sl(),
      checkContentUseCase: sl(),
    ),
  );
  sl.registerFactory<UpdateHobbiesCubit>(
    () => UpdateHobbiesCubit(updateHobbiesUseCase: sl()),
  );
  sl.registerFactory<SearchMotorbikeCubit>(() => SearchMotorbikeCubit());
  sl.registerFactory<CreateRentalBillCubit>(() => CreateRentalBillCubit());
  sl.registerFactory<MotorbikeDetailCubit>(() => MotorbikeDetailCubit());

  sl.registerFactory<GetMyRentalBillsCubit>(() => GetMyRentalBillsCubit(sl()));
  sl.registerFactory<GetRentalBillDetailCubit>(
    () => GetRentalBillDetailCubit(sl()),
  );

  // Feedback Replies

  // Feedback Replies
  sl.registerSingleton<GetFeedbackRepliesUseCase>(GetFeedbackRepliesUseCase());
  sl.registerSingleton<CreateFeedbackReplyUseCase>(
    CreateFeedbackReplyUseCase(),
  );
  sl.registerFactory<ReplyCubit>(
    () => ReplyCubit(
      feedbackRepository: sl(),
      getFeedbackRepliesUseCase: sl(),
      createFeedbackReplyUseCase: sl(),
    ),
  );

  // Voucher
  sl.registerSingleton<VoucherApiService>(VoucherApiServiceImpl());
  sl.registerSingleton<VoucherRepository>(
    VoucherRepositoryImpl(apiService: sl()),
  );
  sl.registerSingleton<GetVouchersUseCase>(GetVouchersUseCase(sl()));
  sl.registerSingleton<GetVoucherDetailUseCase>(GetVoucherDetailUseCase(sl()));

  sl.registerFactory<GetVouchersCubit>(() => GetVouchersCubit(sl()));
}
