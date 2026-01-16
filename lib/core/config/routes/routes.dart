import 'package:flutter/services.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/auth/presentation/pages/sign_in.page.dart';
import 'package:tour_guide_app/features/auth/presentation/pages/sign_up.page.dart';
import 'package:tour_guide_app/features/car_rental/presentation/pages/car_detail.page.dart';
import 'package:tour_guide_app/features/auth/presentation/pages/verify_email.page.dart';
import 'package:tour_guide_app/features/auth/presentation/pages/verify_phone.page.dart';
import 'package:tour_guide_app/features/auth/presentation/pages/verify_citizen_id.page.dart';
import 'package:tour_guide_app/features/auth/presentation/pages/interest_selection.page.dart';
import 'package:tour_guide_app/features/auth/presentation/pages/update_contact_info.page.dart';
import 'package:tour_guide_app/features/car_rental/presentation/pages/car_list.page.dart';
import 'package:tour_guide_app/features/car_rental/presentation/pages/car_rental.page.dart';
import 'package:tour_guide_app/features/mapping_address/presentation/pages/mapping_address.page.dart';
import 'package:tour_guide_app/features/motorbike_rental/presentation/pages/motorbike_rental.page.dart';
import 'package:tour_guide_app/features/motorbike_rental/presentation/pages/motorbike_list.page.dart';
import 'package:tour_guide_app/features/motorbike_rental/presentation/pages/motorbike_detail.page.dart';
import 'package:tour_guide_app/features/bus_booking/presentation/pages/bus_search.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/add_vehicle/add_vehicle.page.dart';
import 'package:tour_guide_app/features/splash/presentation/pages/splash_screen.page.dart';
import 'package:tour_guide_app/features/train_booking/presentation/pages/train_search.page.dart';
import 'package:tour_guide_app/features/flight_booking/presentation/pages/flight_search.page.dart';
import 'package:tour_guide_app/features/home/presentation/pages/home_search.page.dart';
import 'package:tour_guide_app/features/main_screen.dart';
import 'package:tour_guide_app/features/settings/presentation/pages/change_language.page.dart';
import 'package:tour_guide_app/features/restaurant/presentation/pages/find_restaurant.page.dart';
import 'package:tour_guide_app/features/restaurant/presentation/pages/restaurant_list.page.dart';
import 'package:tour_guide_app/features/restaurant/presentation/pages/restaurant_detail.page.dart';
import 'package:tour_guide_app/features/restaurant/presentation/pages/restaurant_table_list.page.dart';
import 'package:tour_guide_app/features/restaurant/presentation/pages/restaurant_booking_info.page.dart';
import 'package:tour_guide_app/features/fast_delivery/presentation/pages/fast_delivery.page.dart';
import 'package:tour_guide_app/features/fast_delivery/presentation/pages/fast_delivery_detail.page.dart';
import 'package:tour_guide_app/features/fast_delivery/presentation/pages/fast_delivery_bill.page.dart';
import 'package:tour_guide_app/features/fast_delivery/data/models/delivery_order.dart';
import 'package:tour_guide_app/features/hotel_booking/presentation/pages/hotel_search.page.dart';
import 'package:tour_guide_app/features/hotel_booking/presentation/pages/hotel_list.page.dart';
import 'package:tour_guide_app/features/hotel_booking/presentation/pages/hotel_detail.page.dart';
import 'package:tour_guide_app/features/hotel_booking/presentation/pages/hotel_room_list.page.dart';
import 'package:tour_guide_app/features/hotel_booking/presentation/pages/hotel_booking_info.page.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/room.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel_room_search_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/presentation/itinerary_explore.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/presentation/itinerary_explore_detail.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/pages/create_itinerary.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/pages/itinerary_detail.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/pages/add_stop.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/pages/edit_itinerary.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/pages/edit_itinerary_info.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/pages/province_selection.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/pages/destination_selection.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/my_itinerary/pages/my_itinerary.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/my_itinerary/pages/itinerary_list.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/my_itinerary/pages/food_wheel.page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/pages/suggest_itinerary_preview.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/pages/stop_detail.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/pages/stop_images.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/pages/stop_videos.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/get_stop_detail/get_stop_detail_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/checkin_stop/checkin_stop_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/contract/contract.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/add_vehicle/vehicle.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/contract/contract_detail.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/contract/create_contract.page.dart';
import 'package:tour_guide_app/features/profile/presentation/pages/personal_information.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/add_vehicle/vehicle_detail.page.dart';
import 'package:tour_guide_app/features/cooperations/presentation/pages/cooperation_detail.page.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/pages/rental_bill_list.page.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/pages/rental_bill_detail.page.dart';
import 'package:tour_guide_app/features/motorbike_rental/presentation/pages/create_rental_bill.page.dart';
import 'package:tour_guide_app/features/car_rental/presentation/pages/create_car_rental_bill.page.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';
import 'package:tour_guide_app/features/eatery/presentation/pages/eatery_list.page.dart';
import 'package:tour_guide_app/features/eatery/presentation/pages/eatery_detail.page.dart';
import 'package:tour_guide_app/features/eatery/presentation/pages/eatery_wheel.page.dart';
import 'package:tour_guide_app/features/eatery/data/models/eatery.dart';

import 'package:tour_guide_app/features/my_vehicle/presentation/pages/rental_request_detail/owner_rental_request_detail.page.dart';
import 'package:tour_guide_app/features/notifications/presentation/pages/notification.page.dart';
import 'package:tour_guide_app/features/settings/presentation/pages/change_password.page.dart';
import 'package:tour_guide_app/features/settings/presentation/pages/terms_and_conditions.page.dart';
import 'package:tour_guide_app/features/settings/presentation/pages/privacy_policy.page.dart';
import 'package:tour_guide_app/features/settings/presentation/pages/contact_support.page.dart';
import 'package:tour_guide_app/features/mapping_address/presentation/pages/convert_old_to_new_address.page.dart';
import 'package:tour_guide_app/features/mapping_address/presentation/pages/convert_new_to_old_address.page.dart';
import 'package:tour_guide_app/features/mapping_address/presentation/pages/convert_old_to_new_details.page.dart';
import 'package:tour_guide_app/features/mapping_address/presentation/pages/convert_new_to_old_details.page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteConstant.signIn:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) async {
                  if (!didPop) return;
                  SystemNavigator.pop();
                },
                child: SignInPage(),
              ),
        );

      case AppRouteConstant.itineraryDetail:
        final itineraryId = settings.arguments as int;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ItineraryDetailPage(itineraryId: itineraryId),
        );

      case AppRouteConstant.addStop:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => AddStopPage(
                itineraryId: args['itineraryId'] as int,
                destination: args['destination'] as Destination,
                dayOrder: args['dayOrder'] as int?,
              ),
        );

      case AppRouteConstant.editItinerary:
        final itinerary = settings.arguments as Itinerary;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => EditItineraryPage(itinerary: itinerary),
        );

      case AppRouteConstant.editItineraryInfo:
        final itinerary = settings.arguments as Itinerary;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => EditItineraryInfoPage(itinerary: itinerary),
        );

      case AppRouteConstant.createItinerary:
        final province = settings.arguments as String;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CreateItineraryPage(province: province),
        );

      case AppRouteConstant.signUp:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) async {
                  if (!didPop) return;
                  SystemNavigator.pop();
                },
                child: SignUpPage(),
              ),
        );

      case AppRouteConstant.mainScreen:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) async {
                  if (!didPop) return;
                  SystemNavigator.pop();
                },
                child: const MainScreen(),
              ),
        );

      case AppRouteConstant.homeSearch:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => HomeSearchPage.withProvider(),
          transitionsBuilder: (_, animation, __, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic, // mượt hơn easeInOut
            );

            // Slide từ dưới lên
            final slideTween = Tween(
              begin: const Offset(0.0, 0.1), // nhỏ hơn 1.0 => nhẹ nhàng hơn
              end: Offset.zero,
            );

            // Fade vào cùng lúc
            final fadeTween = Tween<double>(begin: 0, end: 1);

            return SlideTransition(
              position: curvedAnimation.drive(slideTween),
              child: FadeTransition(
                opacity: curvedAnimation.drive(fadeTween),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        );

      case AppRouteConstant.language:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ChangeLanguagePage(),
        );

      case AppRouteConstant.carRental:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CarRentalPage(),
        );

      case AppRouteConstant.motorbikeRental:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MotorbikeRentalPage(),
        );

      case AppRouteConstant.busBooking:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BusSearchPage(),
        );

      case AppRouteConstant.mappingAddress:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MappingAddressPage(),
        );

      case AppRouteConstant.convertOldToNewAddress:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ConvertOldToNewAddressPage(),
        );

      case AppRouteConstant.convertNewToOldAddress:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ConvertNewToOldAddressPage(),
        );

      case AppRouteConstant.convertOldToNewDetails:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ConvertOldToNewDetailsPage(),
        );

      case AppRouteConstant.convertNewToOldDetails:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ConvertNewToOldDetailsPage(),
        );

      case AppRouteConstant.carList:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CarListPage(),
        );

      case AppRouteConstant.splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SplashScreenPage(),
        );

      case AppRouteConstant.motorbikeList:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MotorbikeListPage(),
        );

      case AppRouteConstant.carDetails:
        final licensePlate = settings.arguments as String?;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CarDetailPage(licensePlate: licensePlate),
        );

      case AppRouteConstant.motorbikeDetails:
        final args = settings.arguments;
        String? licensePlate;
        if (args is String) {
          licensePlate = args;
        } else if (args is Map<String, dynamic>) {
          licensePlate = args['licensePlate'] as String?;
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MotorbikeDetailPage(licensePlate: licensePlate),
        );

      case AppRouteConstant.findRestaurant:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => FindRestaurantPage(),
        );

      case AppRouteConstant.restaurantList:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => RestaurantListPage(),
        );

      case AppRouteConstant.restaurantDetail:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => RestaurantDetailPage(),
        );

      case AppRouteConstant.restaurantTableList:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => RestaurantTableListPage(),
        );

      case AppRouteConstant.restaurantBookingInfo:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => RestaurantBookingInfoPage(),
        );

      case AppRouteConstant.fastDelivery:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const FastDeliveryPage(),
        );

      case AppRouteConstant.fastDeliveryDetail:
        final order = settings.arguments as DeliveryOrder;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => FastDeliveryDetailPage(initialOrder: order),
        );

      case AppRouteConstant.fastDeliveryBill:
        final order = settings.arguments as DeliveryOrder;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => FastDeliveryBillPage(deliveryOrder: order),
        );

      case AppRouteConstant.hotelSearch:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HotelSearchPage(),
        );

      case AppRouteConstant.hotelList:
        final request = settings.arguments as HotelRoomSearchRequest?;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HotelListPage(request: request),
        );

      case AppRouteConstant.hotelDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => HotelDetailPage(
                hotel: args?['hotel'],
                rooms: args?['rooms'],
                request: args?['request'],
              ),
        );

      case AppRouteConstant.hotelRoomList:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => HotelRoomListPage(
                request: args?['request'],
                rooms: args?['rooms'],
                hotel: args?['hotel'],
              ),
        );

      case AppRouteConstant.hotelBookingInfo:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => HotelBookingInfoPage(
                hotel: args['hotel'] as Hotel,
                selectedRooms: args['selectedRooms'] as List<RoomBooking>,
                checkInDate: args['checkInDate'] as DateTime,
                checkOutDate: args['checkOutDate'] as DateTime,
              ),
        );

      case AppRouteConstant.flightBooking:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const FlightSearchPage(),
        );

      case AppRouteConstant.trainBooking:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const TrainSearchPage(),
        );

      case AppRouteConstant.itineraryExplore:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ItineraryExplorePage(),
        );

      case AppRouteConstant.itineraryProvinceSelection:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ProvinceSelectionPage.withProvider(),
        );

      case AppRouteConstant.myItinerary:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MyItineraryPage(),
        );

      case AppRouteConstant.itineraryList:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ItineraryListPage(),
        );

      case AppRouteConstant.itineraryDestinationSelection:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => DestinationSelectionPage(
                province: args['province'] as String,
                itineraryId: args['itineraryId'] as int,
                dayOrder: args['dayOrder'] as int?,
              ),
        );

      case AppRouteConstant.itineraryStopDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => sl<GetStopDetailCubit>()),
                  BlocProvider(create: (_) => sl<CheckInStopCubit>()),
                ],
                child: StopDetailPage(
                  stop: args['stop'] as Stop,
                  itineraryId: args['itineraryId'] as int,
                  itineraryStatus: args['itineraryStatus'] as String,
                ),
              ),
        );

      case AppRouteConstant.foodWheel:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const FoodWheelPage(),
        );

      case AppRouteConstant.stopImages:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => StopImagesPage(
                stop: args['stop'] as Stop,
                itineraryId: args['itineraryId'] as int,
              ),
        );

      case AppRouteConstant.stopVideos:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => StopVideosPage(
                stop: args['stop'] as Stop,
                itineraryId: args['itineraryId'] as int,
              ),
        );

      case AppRouteConstant.contract:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ContractPage(),
        );

      case AppRouteConstant.createContract:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CreateContractPage.provider(),
        );

      case AppRouteConstant.personalInfo:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PersonalInformationPage(),
        );

      case AppRouteConstant.vehicle:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const VehiclePage(),
        );

      case AppRouteConstant.addVehicle:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AddVehiclePage(),
        );

      case AppRouteConstant.contractDetail:
        final contractId = settings.arguments as int;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ContractDetailPage(contractId: contractId),
        );

      case AppRouteConstant.vehicleDetail:
        final licensePlate = settings.arguments as String;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => VehicleDetailPage(licensePlate: licensePlate),
        );

      case AppRouteConstant.verifyEmail:
        final email = settings.arguments as String;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => VerifyEmailPage(email: email),
        );

      case AppRouteConstant.verifyPhone:
        final phoneNumber = settings.arguments as String;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => VerifyPhonePage(phoneNumber: phoneNumber),
        );

      case AppRouteConstant.verifyCitizenId:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const VerifyCitizenIdPage(),
        );

      case AppRouteConstant.itineraryExploreDetail:
        final itineraryId = settings.arguments as int;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ItineraryExploreDetailPage(itineraryId: itineraryId),
        );

      case AppRouteConstant.interestSelection:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const InterestSelectionPage(),
        );

      case AppRouteConstant.updateInitialProfile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const UpdateContactInfoPage(),
        );

      case AppRouteConstant.rentalBillList:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RentalBillListPage(),
        );

      case AppRouteConstant.rentalBillDetail:
        final id = settings.arguments as int;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => RentalBillDetailPage(id: id),
        );

      case AppRouteConstant.cooperationDetail:
        final id = settings.arguments as int;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CooperationDetailPage.withProvider(id: id),
        );

      case AppRouteConstant.createRentalBill:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => CreateRentalBillPage(
                vehicle: args['vehicle'] as RentalVehicle,
                rentalType: args['rentalType'] as String,
                initialStartDate: args['initialStartDate'] as DateTime,
                locationAddress: args['locationAddress'] as String?,
                pickupLatitude: args['pickupLatitude'] as double?,
                pickupLongitude: args['pickupLongitude'] as double?,
              ),
        );

      case AppRouteConstant.createCarRentalBill:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => CreateCarRentalBillPage(
                vehicle: args['vehicle'] as RentalVehicle,
                rentalType: args['rentalType'] as String,
                initialStartDate: args['initialStartDate'] as DateTime,
                locationAddress: args['locationAddress'] as String?,
                pickupLatitude: args['pickupLatitude'] as double?,
                pickupLongitude: args['pickupLongitude'] as double?,
              ),
        );

      case AppRouteConstant.suggestItineraryPreview:
        final itinerary = settings.arguments as Itinerary;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SuggestItineraryPreviewPage(itinerary: itinerary),
        );

      case AppRouteConstant.eateryList:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const EateryListPage(),
        );

      case AppRouteConstant.eateryDetail:
        final eateryId = settings.arguments as int;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => EateryDetailPage(eateryId: eateryId),
        );

      case AppRouteConstant.eateryWheel:
        final eateries = settings.arguments as List<Eatery>;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => EateryWheelPage(eateries: eateries),
        );

      case AppRouteConstant.ownerRentalRequestDetail:
        final id = settings.arguments as int;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => OwnerRentalRequestDetailPage(id: id),
        );

      case AppRouteConstant.notification:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const NotificationPage(),
        );

      case AppRouteConstant.changePassword:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ChangePasswordPage(),
        );

      case AppRouteConstant.termsAndConditions:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const TermsAndConditionsPage(),
        );

      case AppRouteConstant.privacyPolicy:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PrivacyPolicyPage(),
        );

      case AppRouteConstant.contactSupport:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ContactSupportPage(),
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (context) => PopScope(
                canPop: false,
                child: Scaffold(
                  body: Center(
                    child: Text(
                      AppLocalizations.of(
                        context,
                      )!.noRouteDefined(settings.name ?? 'unknown'),
                    ),
                  ),
                ),
              ),
        );
    }
  }
}
