import 'package:flutter/services.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/auth/presentation/pages/sign_in.page.dart';
import 'package:tour_guide_app/features/auth/presentation/pages/sign_up.page.dart';
import 'package:tour_guide_app/features/car_rental/presentation/pages/car_bill.page.dart';
import 'package:tour_guide_app/features/car_rental/presentation/pages/car_detail.page.dart';
import 'package:tour_guide_app/features/auth/presentation/pages/verify_email.page.dart';
import 'package:tour_guide_app/features/auth/presentation/pages/verify_phone.page.dart';
import 'package:tour_guide_app/features/auth/presentation/pages/verify_citizen_id.page.dart';
import 'package:tour_guide_app/features/car_rental/presentation/pages/car_list.page.dart';
import 'package:tour_guide_app/features/car_rental/presentation/pages/car_rental.page.dart';
import 'package:tour_guide_app/features/motorbike_rental/presentation/pages/motorbike_rental.page.dart';
import 'package:tour_guide_app/features/motorbike_rental/presentation/pages/motorbike_list.page.dart';
import 'package:tour_guide_app/features/motorbike_rental/presentation/pages/motorbike_detail.page.dart';
import 'package:tour_guide_app/features/motorbike_rental/presentation/pages/motorbike_bill.page.dart';
import 'package:tour_guide_app/features/bus_booking/presentation/pages/bus_search.page.dart';
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
import 'package:tour_guide_app/features/hotel_booking/data/models/hotel_booking.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/pages/create_itinerary.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/pages/itinerary_detail.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/pages/add_stop.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/pages/edit_itinerary.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/pages/province_selection.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/pages/destination_selection.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/my_itinerary/pages/my_itinerary.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/my_itinerary/pages/itinerary_list.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/my_itinerary/pages/food_wheel.page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/pages/stop_detail.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/pages/stop_images.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/pages/stop_videos.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/get_stop_detail/get_stop_detail_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/contract/contract.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/vehicle/vehicle.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/contract/contract_detail.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/contract/create_contract.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/create_contract/create_contract_cubit.dart';
import 'package:tour_guide_app/features/profile/presentation/pages/personal_information.page.dart';

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
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CarDetailPage(),
        );

      case AppRouteConstant.motorbikeDetails:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MotorbikeDetailPage(),
        );

      case AppRouteConstant.carBill:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CarBillPage(),
        );

      case AppRouteConstant.motorbikeBill:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MotorbikeBillPage(),
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
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HotelListPage(),
        );

      case AppRouteConstant.hotelDetail:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HotelDetailPage(),
        );

      case AppRouteConstant.hotelRoomList:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HotelRoomListPage(),
        );

      case AppRouteConstant.hotelBookingInfo:
        final booking = settings.arguments as HotelBooking;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HotelBookingInfoPage(hotelBooking: booking),
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
              (_) => BlocProvider(
                create: (_) => sl<GetStopDetailCubit>(),
                child: StopDetailPage(
                  stop: args['stop'] as Stop,
                  itineraryId: args['itineraryId'] as int,
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
          builder:
              (_) => BlocProvider(
                create: (_) => sl<CreateContractCubit>(),
                child: const CreateContractPage(),
              ),
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

      case AppRouteConstant.contractDetail:
        final contractId = settings.arguments as int;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ContractDetailPage(contractId: contractId),
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
