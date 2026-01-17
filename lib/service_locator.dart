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
import 'package:tour_guide_app/features/auth/domain/usecases/verify_citizen_id.dart';

import 'package:tour_guide_app/features/auth/domain/usecases/verify_phone.dart';
import 'package:tour_guide_app/features/auth/domain/usecases/change_password.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/get_my_rental_bills/get_my_rental_bills_cubit.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/get_rental_bill_detail/get_rental_bill_detail_cubit.dart';
import 'package:tour_guide_app/features/chat_bot/domain/usecases/send_chat_message.dart';
import 'package:tour_guide_app/features/cooperations/data/data_source/cooperation_api_service.dart';
import 'package:tour_guide_app/features/cooperations/data/repository/cooperation_repository_impl.dart';
import 'package:tour_guide_app/features/cooperations/domain/repository/cooperation_repository.dart';
import 'package:tour_guide_app/features/cooperations/domain/usecases/favorite_cooperation.dart';
import 'package:tour_guide_app/features/cooperations/domain/usecases/get_cooperation_detail.dart';
import 'package:tour_guide_app/features/cooperations/domain/usecases/get_cooperations.dart';
import 'package:tour_guide_app/features/cooperations/domain/usecases/get_favorite_cooperations.dart';
import 'package:tour_guide_app/features/cooperations/domain/usecases/unfavorite_cooperation.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/cooperation_detail/cooperation_detail_cubit.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/comment/cooperation_comment_cubit.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/cooperation_list/cooperation_list_cubit.dart';
import 'package:tour_guide_app/features/cooperations/presentation/bloc/favorite_cooperations/favorite_cooperations_cubit.dart';
import 'package:tour_guide_app/features/destination/data/data_source/destination_api_service.dart';
import 'package:tour_guide_app/features/destination/data/repository/destination_repository_impl.dart';
import 'package:tour_guide_app/features/destination/domain/repository/destination_repository.dart';
import 'package:tour_guide_app/features/destination/domain/usecases/get_destination_by_id.dart';
import 'package:tour_guide_app/features/destination/domain/usecases/get_favorites.dart';
import 'package:tour_guide_app/features/destination/domain/usecases/favorite_destination.dart';
import 'package:tour_guide_app/features/destination/domain/usecases/delete_favorite_destination.dart';
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
import 'package:tour_guide_app/features/car_rental/data/data_source/car_rental_api_service.dart';
import 'package:tour_guide_app/features/car_rental/data/repository/car_rental_repository_impl.dart';
import 'package:tour_guide_app/features/car_rental/domain/repository/car_rental_repository.dart';
import 'package:tour_guide_app/features/car_rental/domain/usecases/search_cars_use_case.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_favorite_cooperations/get_favorite_cooperations_cubit.dart';

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
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/suggest_itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/comment/comment_cubit.dart';
import 'package:tour_guide_app/features/destination/presentation/bloc/comment/destination_comment_cubit.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/create_feedback_reply.dart';
import 'package:tour_guide_app/core/services/feedback/domain/usecases/get_feedback_replies.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/reply/reply_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/use_itinerary.dart'; // Add this
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/claim_itinerary_use_case.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/use_itinerary/use_itinerary_cubit.dart'; // Add this
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/update_travel_route_use_case.dart';

import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/like_itinerary_usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/unlike_itinerary_usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/trigger_anniversary_check.dart';
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
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/checkin_stop_usecase.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/create_itinerary/create_itinerary_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/my_itinerary/bloc/get_itinerary_me/get_itinerary_me_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/get_itinerary_detail/get_itinerary_detail_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/add_stop/add_stop_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/suggest_itinerary/suggest_itinerary_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/get_stop_detail/get_stop_detail_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/checkin_stop/checkin_stop_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/get_provinces/get_province_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/delete_itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/delete_itinerary/delete_itinerary_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/domain/usecases/delete_itinerary_stop.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/delete_stop/delete_stop_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/update_itinerary_info/update_itinerary_info_cubit.dart';
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
import 'package:tour_guide_app/features/settings/presentation/bloc/change_password/change_password_cubit.dart';
import 'package:tour_guide_app/features/profile/domain/usecases/update_initial_profile.dart';

import 'package:tour_guide_app/features/profile/domain/usecases/update_avatar.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/edit_profile/edit_profile_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/get_vehicle_catalogs.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/add_vehicle/add_vehicle_cubit.dart';
import 'package:tour_guide_app/features/auth/domain/usecases/update_hobbies.dart';
import 'package:tour_guide_app/features/auth/presentation/bloc/update_hobbies/update_hobbies_cubit.dart';
import 'package:tour_guide_app/features/auth/presentation/bloc/update_contact_info/update_contact_info_cubit.dart';
import 'package:tour_guide_app/features/auth/presentation/bloc/verify_citizen_id/verify_citizen_id_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/enable_disable_vehicle/enable_disable_vehicle_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/get_owner_rental_bills.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_owner_rental_bills/get_owner_rental_bills_cubit.dart';
import 'package:tour_guide_app/core/services/bank/data/data_sources/bank_api_service.dart';
import 'package:tour_guide_app/core/services/bank/data/repositories/bank_repository_impl.dart';
import 'package:tour_guide_app/core/services/bank/domain/repositories/bank_repository.dart';
import 'package:tour_guide_app/core/services/bank/domain/usecases/get_banks_use_case.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_banks/get_banks_cubit.dart';
import 'package:tour_guide_app/features/motorbike_rental/presentation/bloc/search_motorbike/search_motorbike_cubit.dart';
import 'package:tour_guide_app/features/motorbike_rental/presentation/bloc/create_rental_bill/create_rental_bill_cubit.dart';
import 'package:tour_guide_app/features/motorbike_rental/presentation/bloc/motorbike_detail/motorbike_detail_cubit.dart';
import 'package:tour_guide_app/features/motorbike_rental/domain/usecases/get_motorbike_detail_use_case.dart';
import 'package:tour_guide_app/features/motorbike_rental/domain/usecases/create_rental_bill_use_case.dart';
import 'package:tour_guide_app/features/car_rental/presentation/bloc/search_car/search_car_cubit.dart';
import 'package:tour_guide_app/features/car_rental/presentation/bloc/create_car_rental_bill/create_car_rental_bill_cubit.dart';
import 'package:tour_guide_app/features/car_rental/presentation/bloc/car_detail/car_detail_cubit.dart';
import 'package:tour_guide_app/features/car_rental/domain/usecases/get_car_detail_use_case.dart';
import 'package:tour_guide_app/features/car_rental/domain/usecases/create_car_rental_bill_use_case.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/data_source/rental_bill_api_service.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/data/repository/rental_bill_repository_impl.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/repository/rental_bill_repository.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/usecases/get_my_rental_bills_use_case.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/usecases/get_rental_bill_detail_use_case.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/usecases/update_rental_bill_use_case.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/usecases/pay_rental_bill_use_case.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/usecases/confirm_qr_payment_use_case.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/rental_workflow/rental_workflow_cubit.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/usecases/user_pickup.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/usecases/user_return_request.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/owner_rental_workflow/owner_rental_workflow_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/owner_delivering.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/owner_delivered.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/owner_confirm_return.dart';
import 'package:tour_guide_app/features/my_vehicle/domain/usecases/owner_cancel_bill.usecase.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/domain/usecases/cancel_rental_bill_usecase.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/owner_cancel_bill/owner_cancel_bill_cubit.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/cancel_rental_bill/cancel_rental_bill_cubit.dart';

import 'package:tour_guide_app/features/voucher/data/data_source/voucher_api_service.dart';
import 'package:tour_guide_app/features/voucher/data/repository/voucher_repository_impl.dart';
import 'package:tour_guide_app/features/voucher/domain/repository/voucher_repository.dart';
import 'package:tour_guide_app/features/voucher/domain/usecases/get_voucher_detail_use_case.dart';
import 'package:tour_guide_app/features/voucher/domain/usecases/get_vouchers_use_case.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_vouchers/get_vouchers_cubit.dart';
import 'package:tour_guide_app/features/eatery/data/data_source/eatery_api_service.dart';
import 'package:tour_guide_app/features/eatery/data/repository/eatery_repository_impl.dart';
import 'package:tour_guide_app/features/eatery/domain/repository/eatery_repository.dart';
import 'package:tour_guide_app/features/eatery/domain/usecases/get_eateries_use_case.dart';
import 'package:tour_guide_app/features/eatery/domain/usecases/get_random_eatery_use_case.dart';
import 'package:tour_guide_app/features/eatery/domain/usecases/get_eatery_detail_use_case.dart';
import 'package:tour_guide_app/features/eatery/presentation/bloc/get_eateries/get_eateries_cubit.dart';
import 'package:tour_guide_app/features/eatery/presentation/bloc/get_eatery_detail/get_eatery_detail_cubit.dart';

import 'package:tour_guide_app/features/notifications/data/data_source/notification_api_service.dart';
import 'package:tour_guide_app/features/notifications/data/repository/notification_repository_impl.dart';
import 'package:tour_guide_app/features/notifications/domain/repository/notification_repository.dart';
import 'package:tour_guide_app/features/notifications/domain/usecases/get_all_notifications.dart';
import 'package:tour_guide_app/features/notifications/domain/usecases/get_my_notifications.dart';
import 'package:tour_guide_app/features/notifications/domain/usecases/mark_notification_read.dart';
import 'package:tour_guide_app/features/notifications/domain/usecases/test_reminders.dart';
import 'package:tour_guide_app/features/notifications/data/data_source/notification_socket_service.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/anniversary/bloc/anniversary_cubit.dart';
import 'package:tour_guide_app/features/notifications/presentation/bloc/notification_cubit.dart';

import 'package:tour_guide_app/features/mapping_address/data/data_source/mapping_address_api_service.dart';
import 'package:tour_guide_app/features/mapping_address/data/repository/mapping_address_repository_impl.dart';
import 'package:tour_guide_app/features/mapping_address/domain/repository/mapping_address_repository.dart';
import 'package:tour_guide_app/features/mapping_address/domain/usecases/convert_old_to_new_address_usecase.dart';
import 'package:tour_guide_app/features/mapping_address/domain/usecases/convert_new_to_old_address_usecase.dart';
import 'package:tour_guide_app/features/mapping_address/domain/usecases/convert_old_to_new_details_usecase.dart';
import 'package:tour_guide_app/features/mapping_address/domain/usecases/convert_new_to_old_details_usecase.dart';
import 'package:tour_guide_app/features/mapping_address/domain/usecases/get_legacy_provinces_usecase.dart';
import 'package:tour_guide_app/features/mapping_address/domain/usecases/get_legacy_district_usecase.dart';
import 'package:tour_guide_app/features/mapping_address/domain/usecases/get_legacy_wards_of_district_usecase.dart';
import 'package:tour_guide_app/features/mapping_address/domain/usecases/get_reform_provinces_usecase.dart';
import 'package:tour_guide_app/features/mapping_address/domain/usecases/get_reform_province_usecase.dart';
import 'package:tour_guide_app/features/mapping_address/domain/usecases/get_reform_communes_of_province_usecase.dart';
import 'package:tour_guide_app/features/mapping_address/domain/usecases/find_by_legacy_ward_usecase.dart';
import 'package:tour_guide_app/features/mapping_address/domain/usecases/find_by_reform_commune_usecase.dart';
import 'package:tour_guide_app/features/mapping_address/presentation/bloc/convert_old_to_new_address/convert_old_to_new_address_cubit.dart';
import 'package:tour_guide_app/features/mapping_address/presentation/bloc/convert_new_to_old_address/convert_new_to_old_address_cubit.dart';
import 'package:tour_guide_app/features/mapping_address/presentation/bloc/convert_old_to_new_details/convert_old_to_new_details_cubit.dart';
import 'package:tour_guide_app/features/mapping_address/presentation/bloc/convert_new_to_old_details/convert_new_to_old_details_cubit.dart';
import 'package:tour_guide_app/features/mapping_address/presentation/bloc/legacy_locations/legacy_locations_cubit.dart';
import 'package:tour_guide_app/features/mapping_address/presentation/bloc/reform_locations/reform_locations_cubit.dart';
import 'package:tour_guide_app/features/mapping_address/domain/usecases/get_legacy_districts_of_province_usecase.dart';

import 'package:tour_guide_app/features/hotel_booking/data/data_source/hotel_booking_api_service.dart';
import 'package:tour_guide_app/features/bills/book_hotel/presentation/bloc/get_my_hotel_bills/get_my_hotel_bills_cubit.dart';
import 'package:tour_guide_app/features/bills/book_hotel/presentation/bloc/get_hotel_bill_detail/get_hotel_bill_detail_cubit.dart';
import 'package:tour_guide_app/features/bills/book_hotel/presentation/bloc/hotel_payment/hotel_payment_cubit.dart';
import 'package:tour_guide_app/features/bills/book_hotel/presentation/bloc/cancel_hotel_bill/cancel_hotel_bill_cubit.dart';
import 'package:tour_guide_app/features/bills/book_hotel/presentation/bloc/book_hotel_workflow/book_hotel_workflow_cubit.dart';

import 'package:tour_guide_app/features/bills/book_hotel/data/data_source/book_hotel_api_service.dart';
import 'package:tour_guide_app/features/bills/book_hotel/data/repository/book_hotel_repository_impl.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/repository/book_hotel_repository.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/usecases/get_my_hotel_bills_usecase.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/usecases/get_hotel_bill_detail_usecase.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/usecases/confirm_hotel_bill_usecase.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/usecases/pay_hotel_bill_usecase.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/usecases/update_hotel_bill_usecase.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/usecases/cancel_hotel_bill_usecase.dart';

import 'package:tour_guide_app/features/hotel_booking/domain/usecases/create_hotel_bill_usecase.dart';
import 'package:tour_guide_app/features/hotel_booking/domain/repository/hotel_booking_repository.dart';
import 'package:tour_guide_app/features/hotel_booking/data/repository/hotel_booking_repository_impl.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/usecases/hotel_check_in_usecase.dart';
import 'package:tour_guide_app/features/bills/book_hotel/domain/usecases/hotel_check_out_usecase.dart';
import 'package:tour_guide_app/features/hotel_booking/domain/usecases/get_hotel_rooms_usecase.dart';
import 'package:tour_guide_app/features/hotel_booking/presentation/bloc/create_hotel_bill/create_hotel_bill_cubit.dart';
import 'package:tour_guide_app/features/hotel_booking/presentation/bloc/find_hotel/find_hotel_cubit.dart';

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
  sl.registerSingleton<CarRentalApiService>(CarRentalApiServiceImpl());
  sl.registerSingleton<RentalBillApiService>(RentalBillApiServiceImpl());
  sl.registerSingleton<EateryApiService>(EateryApiServiceImpl());
  sl.registerSingleton<CooperationApiService>(CooperationApiServiceImpl());
  sl.registerSingleton<NotificationApiService>(NotificationApiServiceImpl());
  sl.registerSingleton<NotificationSocketService>(NotificationSocketService());
  sl.registerSingleton<BankApiService>(BankApiServiceImpl());
  sl.registerSingleton<MappingAddressApiService>(
    MappingAddressApiServiceImpl(),
  );

  // Repositories
  sl.registerSingleton<BankRepository>(BankRepositoryImpl(sl()));
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
  sl.registerSingleton<CarRentalRepository>(CarRentalRepositoryImpl());
  sl.registerSingleton<RentalBillRepository>(RentalBillRepositoryImpl());
  sl.registerSingleton<EateryRepository>(EateryRepositoryImpl());
  sl.registerSingleton<CooperationRepository>(CooperationRepositoryImpl());
  sl.registerSingleton<NotificationRepository>(
    NotificationRepositoryImpl(apiService: sl()),
  );
  sl.registerSingleton<MappingAddressRepository>(
    MappingAddressRepositoryImpl(),
  );

  // Usecases
  sl.registerSingleton<SignInUseCase>(SignInUseCase());
  sl.registerSingleton<SignUpUseCase>(SignUpUseCase());
  sl.registerSingleton<IsLoggedInUseCase>(IsLoggedInUseCase());
  sl.registerSingleton<LogOutUseCase>(LogOutUseCase());
  sl.registerSingleton<EmailStartUseCase>(EmailStartUseCase());
  sl.registerSingleton<VerifyEmailUseCase>(VerifyEmailUseCase());
  sl.registerSingleton<ChangePasswordUseCase>(ChangePasswordUseCase());
  sl.registerSingleton<VerifyCitizenIdUseCase>(VerifyCitizenIdUseCase());
  sl.registerSingleton<GetDestinationByIdUseCase>(GetDestinationByIdUseCase());
  sl.registerSingleton<GetDestinationUseCase>(GetDestinationUseCase());
  sl.registerSingleton<GetFavoritesUseCase>(GetFavoritesUseCase());
  sl.registerSingleton<FavoriteDestinationUseCase>(
    FavoriteDestinationUseCase(),
  );
  sl.registerSingleton<DeleteFavoriteDestinationUseCase>(
    DeleteFavoriteDestinationUseCase(),
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
  sl.registerSingleton<CheckInStopUseCase>(CheckInStopUseCase(sl()));
  sl.registerSingleton<DeleteItineraryUseCase>(DeleteItineraryUseCase());
  sl.registerSingleton<UpdateTravelRouteUseCase>(
    UpdateTravelRouteUseCase(sl()),
  );
  sl.registerSingleton<EditStopTimeUseCase>(EditStopTimeUseCase());
  sl.registerSingleton<EditStopReorderUseCase>(EditStopReorderUseCase());
  sl.registerSingleton<EditStopDetailsUseCase>(EditStopDetailsUseCase());
  sl.registerSingleton<CreateFeedbackUseCase>(CreateFeedbackUseCase());
  sl.registerSingleton<GetFeedbackUseCase>(GetFeedbackUseCase());
  sl.registerSingleton<CheckContentUseCase>(CheckContentUseCase());
  sl.registerLazySingleton(() => SearchMotorbikesUseCase());
  sl.registerLazySingleton(() => GetMotorbikeDetailUseCase());
  sl.registerLazySingleton(() => CreateRentalBillUseCase());
  sl.registerLazySingleton(() => SearchCarsUseCase());
  sl.registerLazySingleton(() => GetCarDetailUseCase());
  sl.registerLazySingleton(() => CreateCarRentalBillUseCase());
  sl.registerSingleton<DeleteItineraryStopUseCase>(
    DeleteItineraryStopUseCase(sl()),
  );
  sl.registerSingleton<GetMyProfileUseCase>(GetMyProfileUseCase());
  sl.registerSingleton<GetBanksUseCase>(GetBanksUseCase(sl()));
  sl.registerLazySingleton<DeleteStopMediaUseCase>(
    () => DeleteStopMediaUseCase(),
  );
  sl.registerLazySingleton<AddStopMediaUseCase>(() => AddStopMediaUseCase());
  sl.registerSingleton<PublicizeItineraryUseCase>(
    PublicizeItineraryUseCase(sl()),
  );
  sl.registerSingleton<ClaimItineraryUseCase>(ClaimItineraryUseCase(sl()));
  sl.registerSingleton<TriggerAnniversaryCheckUseCase>(
    TriggerAnniversaryCheckUseCase(),
  );

  // Eatery
  sl.registerSingleton<GetEateriesUseCase>(GetEateriesUseCase());
  sl.registerSingleton<GetRandomEateryUseCase>(GetRandomEateryUseCase());
  sl.registerSingleton<GetEateryDetailUseCase>(GetEateryDetailUseCase());

  sl.registerSingleton<UseItineraryUseCase>(UseItineraryUseCase());

  // Like Itinerary
  sl.registerSingleton<LikeItineraryUseCase>(LikeItineraryUseCase());
  sl.registerSingleton<UnlikeItineraryUseCase>(UnlikeItineraryUseCase());

  // Notification Use Cases
  sl.registerSingleton<GetMyNotificationsUseCase>(
    GetMyNotificationsUseCase(sl()),
  );
  sl.registerSingleton<GetAllNotificationsUseCase>(
    GetAllNotificationsUseCase(sl()),
  );
  sl.registerSingleton<MarkNotificationReadUseCase>(
    MarkNotificationReadUseCase(sl()),
  );
  sl.registerSingleton<TestRemindersUseCase>(TestRemindersUseCase(sl()));

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
  sl.registerSingleton<GetOwnerRentalBillsUseCase>(
    GetOwnerRentalBillsUseCase(),
  );
  sl.registerSingleton<GetMyRentalBillsUseCase>(GetMyRentalBillsUseCase());
  sl.registerSingleton<GetRentalBillDetailUseCase>(
    GetRentalBillDetailUseCase(),
  );
  sl.registerSingleton<UpdateRentalBillUseCase>(UpdateRentalBillUseCase());
  sl.registerSingleton<PayRentalBillUseCase>(PayRentalBillUseCase());
  sl.registerSingleton<ConfirmQrPaymentUseCase>(ConfirmQrPaymentUseCase(sl()));
  sl.registerSingleton<SuggestItineraryUseCase>(SuggestItineraryUseCase());

  // Cooperation
  sl.registerSingleton<GetCooperationsUseCase>(GetCooperationsUseCase());
  sl.registerSingleton<GetCooperationDetailUseCase>(
    GetCooperationDetailUseCase(),
  );
  sl.registerSingleton<GetFavoriteCooperationsUseCase>(
    GetFavoriteCooperationsUseCase(),
  );
  sl.registerSingleton<FavoriteCooperationUseCase>(
    FavoriteCooperationUseCase(),
  );
  sl.registerSingleton<UnfavoriteCooperationUseCase>(
    UnfavoriteCooperationUseCase(),
  );

  sl.registerSingleton<UserPickupUseCase>(UserPickupUseCase());
  sl.registerSingleton<UserReturnRequestUseCase>(UserReturnRequestUseCase());
  sl.registerSingleton<OwnerDeliveringUseCase>(OwnerDeliveringUseCase());
  sl.registerSingleton<OwnerDeliveredUseCase>(OwnerDeliveredUseCase());
  sl.registerSingleton<OwnerConfirmReturnUseCase>(OwnerConfirmReturnUseCase());
  sl.registerSingleton<OwnerCancelBillUseCase>(OwnerCancelBillUseCase(sl()));
  sl.registerSingleton<CancelRentalBillUseCase>(CancelRentalBillUseCase(sl()));

  // Mapping Address
  sl.registerSingleton<ConvertOldToNewAddressUseCase>(
    ConvertOldToNewAddressUseCase(),
  );
  sl.registerSingleton<ConvertNewToOldAddressUseCase>(
    ConvertNewToOldAddressUseCase(),
  );
  sl.registerSingleton<ConvertOldToNewDetailsUseCase>(
    ConvertOldToNewDetailsUseCase(),
  );
  sl.registerSingleton<ConvertNewToOldDetailsUseCase>(
    ConvertNewToOldDetailsUseCase(),
  );
  sl.registerSingleton<GetLegacyProvincesUseCase>(GetLegacyProvincesUseCase());
  sl.registerSingleton<GetLegacyDistrictUseCase>(GetLegacyDistrictUseCase());
  sl.registerSingleton<GetLegacyDistrictsOfProvinceUseCase>(
    GetLegacyDistrictsOfProvinceUseCase(),
  );
  sl.registerSingleton<GetLegacyWardsOfDistrictUseCase>(
    GetLegacyWardsOfDistrictUseCase(),
  );
  sl.registerSingleton<GetReformProvincesUseCase>(GetReformProvincesUseCase());
  sl.registerSingleton<GetReformProvinceUseCase>(GetReformProvinceUseCase());
  sl.registerSingleton<GetReformCommunesOfProvinceUseCase>(
    GetReformCommunesOfProvinceUseCase(),
  );
  sl.registerSingleton<FindByLegacyWardUseCase>(FindByLegacyWardUseCase());
  sl.registerSingleton<FindByReformCommuneUseCase>(
    FindByReformCommuneUseCase(),
  );

  // Cubits
  sl.registerFactory<CooperationDetailCubit>(
    () => CooperationDetailCubit(sl()),
  );
  sl.registerFactory<CooperationCommentCubit>(
    () => CooperationCommentCubit(
      getFeedbackUseCase: sl(),
      createFeedbackUseCase: sl(),
      checkContentUseCase: sl(),
    ),
  );
  sl.registerFactory<CooperationListCubit>(
    () => CooperationListCubit(getCooperationsUseCase: sl()),
  );
  sl.registerFactory<FavoriteCooperationsCubit>(
    () => FavoriteCooperationsCubit(),
  );
  sl.registerFactory<GetFavoriteCooperationsCubit>(
    () => GetFavoriteCooperationsCubit(),
  );
  sl.registerFactory<SuggestItineraryCubit>(
    () => SuggestItineraryCubit(sl(), sl()),
  );
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
  sl.registerFactory(() => GetOwnerRentalBillsCubit(sl()));
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
  sl.registerFactory<CheckInStopCubit>(() => CheckInStopCubit(sl()));
  sl.registerFactory<GetProvinceCubit>(() => GetProvinceCubit());
  sl.registerFactory<GetBanksCubit>(() => GetBanksCubit(sl()));
  sl.registerFactory<DeleteItineraryCubit>(() => DeleteItineraryCubit(sl()));
  sl.registerFactory<EditStopCubit>(() => EditStopCubit(sl(), sl(), sl()));
  sl.registerFactory<StopMediaCubit>(() => StopMediaCubit(sl(), sl(), sl()));
  sl.registerFactory<CreateContractCubit>(() => CreateContractCubit());
  sl.registerFactory<GetMyProfileCubit>(() => GetMyProfileCubit(sl()));
  sl.registerFactory<EditProfileCubit>(
    () => EditProfileCubit(
      updateInitialProfileUseCase: sl(),
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
  sl.registerFactory<VerifyCitizenIdCubit>(
    () => VerifyCitizenIdCubit(verifyCitizenIdUseCase: sl()),
  );
  sl.registerFactory<ChangePasswordCubit>(() => ChangePasswordCubit());
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
  sl.registerFactory<UpdateContactInfoCubit>(
    () => UpdateContactInfoCubit(updateInitialProfileUseCase: sl()),
  );
  sl.registerFactory<SearchMotorbikeCubit>(() => SearchMotorbikeCubit());
  sl.registerFactory<CreateRentalBillCubit>(() => CreateRentalBillCubit());
  sl.registerFactory<MotorbikeDetailCubit>(() => MotorbikeDetailCubit());
  sl.registerFactory<SearchCarCubit>(() => SearchCarCubit());
  sl.registerFactory<CreateCarRentalBillCubit>(
    () => CreateCarRentalBillCubit(),
  );
  sl.registerFactory<CarDetailCubit>(() => CarDetailCubit());

  sl.registerFactory<GetMyRentalBillsCubit>(() => GetMyRentalBillsCubit(sl()));
  sl.registerFactory<GetRentalBillDetailCubit>(
    () => GetRentalBillDetailCubit(sl()),
  );
  sl.registerFactory<RentalWorkflowCubit>(
    () => RentalWorkflowCubit(
      userPickupUseCase: sl(),
      userReturnRequestUseCase: sl(),
    ),
  );
  sl.registerFactory<OwnerRentalWorkflowCubit>(
    () => OwnerRentalWorkflowCubit(
      ownerDeliveringUseCase: sl(),
      ownerDeliveredUseCase: sl(),
      ownerConfirmReturnUseCase: sl(),
    ),
  );
  sl.registerFactory<OwnerCancelBillCubit>(() => OwnerCancelBillCubit(sl()));
  sl.registerFactory<CancelRentalBillCubit>(() => CancelRentalBillCubit(sl()));

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

  // Eatery Cubits
  sl.registerFactory<GetEateriesCubit>(() => GetEateriesCubit(sl()));
  sl.registerFactory<GetEateryDetailCubit>(() => GetEateryDetailCubit(sl()));
  sl.registerFactory<NotificationCubit>(
    () => NotificationCubit(
      getMyNotificationsUseCase: sl(),
      markNotificationReadUseCase: sl(),
      socketService: sl(),
    ),
  );
  sl.registerFactory<AnniversaryCubit>(() => AnniversaryCubit(sl()));

  // Mapping Address
  sl.registerFactory<ConvertOldToNewAddressCubit>(
    () => ConvertOldToNewAddressCubit(sl()),
  );
  sl.registerFactory<ConvertNewToOldAddressCubit>(
    () => ConvertNewToOldAddressCubit(sl()),
  );
  sl.registerFactory<ConvertOldToNewDetailsCubit>(
    () => ConvertOldToNewDetailsCubit(sl()),
  );
  sl.registerFactory<ConvertNewToOldDetailsCubit>(
    () => ConvertNewToOldDetailsCubit(sl()),
  );
  sl.registerFactory<LegacyLocationsCubit>(
    () => LegacyLocationsCubit(
      getProvincesUseCase: sl(),
      getDistrictsUseCase: sl(),
      getWardsUseCase: sl(),
    ),
  );
  sl.registerFactory<ReformLocationsCubit>(
    () => ReformLocationsCubit(
      getProvincesUseCase: sl(),
      getCommunesUseCase: sl(),
    ),
  );
  // Hotel Booking
  sl.registerLazySingleton<HotelBookingApiService>(
    () => HotelBookingApiServiceImpl(),
  );
  sl.registerLazySingleton<HotelBookingRepository>(
    () => HotelBookingRepositoryImpl(),
  );
  sl.registerLazySingleton<GetHotelRoomsUseCase>(() => GetHotelRoomsUseCase());
  sl.registerLazySingleton<CreateHotelBillUseCase>(
    () => CreateHotelBillUseCase(),
  );
  sl.registerFactory<UpdateItineraryInfoCubit>(
    () => UpdateItineraryInfoCubit(updateItineraryInfoUseCase: sl()),
  );
  sl.registerFactory<FindHotelCubit>(() => FindHotelCubit(sl()));
  sl.registerFactory<CreateHotelBillCubit>(() => CreateHotelBillCubit(sl()));

  // Book Hotel (Hotel Bill Management)
  sl.registerLazySingleton<BookHotelApiService>(
    () => BookHotelApiServiceImpl(),
  );
  sl.registerLazySingleton<BookHotelRepository>(
    () => BookHotelRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetMyHotelBillsUseCase>(
    () => GetMyHotelBillsUseCase(sl()),
  );
  sl.registerLazySingleton<GetHotelBillDetailUseCase>(
    () => GetHotelBillDetailUseCase(sl()),
  );
  sl.registerLazySingleton<HotelCheckInUseCase>(
    () => HotelCheckInUseCase(sl()),
  );
  sl.registerLazySingleton<HotelCheckOutUseCase>(
    () => HotelCheckOutUseCase(sl()),
  );
  sl.registerLazySingleton<CancelHotelBillUseCase>(
    () => CancelHotelBillUseCase(sl()),
  );

  sl.registerLazySingleton<UpdateHotelBillUseCase>(
    () => UpdateHotelBillUseCase(sl()),
  );
  sl.registerLazySingleton<ConfirmHotelBillUseCase>(
    () => ConfirmHotelBillUseCase(sl()),
  );
  sl.registerLazySingleton<PayHotelBillUseCase>(
    () => PayHotelBillUseCase(sl()),
  );

  sl.registerFactory<GetMyHotelBillsCubit>(() => GetMyHotelBillsCubit(sl()));
  sl.registerFactory<GetHotelBillDetailCubit>(
    () => GetHotelBillDetailCubit(sl()),
  );
  sl.registerFactory<HotelPaymentCubit>(
    () => HotelPaymentCubit(
      payHotelBillUseCase: sl(),
      updateHotelBillUseCase: sl(),
    ),
  );
  sl.registerFactory<CancelHotelBillCubit>(() => CancelHotelBillCubit(sl()));
  sl.registerFactory<BookHotelWorkflowCubit>(
    () => BookHotelWorkflowCubit(
      confirmHotelBillUseCase: sl(),
      payHotelBillUseCase: sl(),
      cancelHotelBillUseCase: sl(),
      updateHotelBillUseCase: sl(),
    ),
  );
}
