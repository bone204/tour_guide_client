import 'package:flutter/services.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/auth/presentation/pages/sign_in.page.dart';
import 'package:tour_guide_app/features/auth/presentation/pages/sign_up.page.dart';
import 'package:tour_guide_app/features/car_rental/presentation/pages/car_bill.page.dart';
import 'package:tour_guide_app/features/car_rental/presentation/pages/car_detail.page.dart';
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
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/my_vehicle.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/contract/vehicle_rental_register.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/contract/contract_detail.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/contract/vehicle_detail.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/pages/add_vehicle/add_vehicle.page.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/register_rental_vehicle/register_rental_vehicle_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_contracts/get_contracts_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/get_vehicles/get_vehicles_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/add_vehicle/add_vehicle_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/contract_detail/contract_detail_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/vehicle_detail/vehicle_detail_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/create_itinerary/pages/itinerary_detail.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/create_itinerary/pages/province_selection.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/create_itinerary/pages/destination_selection.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/create_itinerary/pages/itinerary_creation.page.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/my_itinerary/pages/my_itinerary.page.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';
import 'package:tour_guide_app/features/home/presentation/bloc/get_destination_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/service_locator.dart';

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
        final provinceName = settings.arguments as String;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ItineraryDetailPage(provinceName: provinceName),
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

      case AppRouteConstant.myVehicle:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => sl<GetContractsCubit>()),
                  BlocProvider(create: (_) => sl<GetVehiclesCubit>()),
                ],
                child: const MyVehiclePage(),
              ),
        );

      case AppRouteConstant.vehicleRentalRegister:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (_) => sl<RegisterRentalVehicleCubit>(),
                child: const VehicleRentalRegisterPage(),
              ),
        );

      case AppRouteConstant.addVehicle:
        final contractId = settings.arguments as int;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (_) => sl<AddVehicleCubit>(),
                child: AddVehiclePage(contractId: contractId),
              ),
        );

      case AppRouteConstant.contractDetail:
        final contractId = settings.arguments as int;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (_) => sl<ContractDetailCubit>(),
                child: ContractDetailPage(contractId: contractId),
              ),
        );

      case AppRouteConstant.vehicleDetail:
        final licensePlate = settings.arguments as String;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (_) => sl<VehicleDetailCubit>(),
                child: VehicleDetailPage(licensePlate: licensePlate),
              ),
        );

      case AppRouteConstant.itineraryProvinceSelection:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ProvinceSelectionPage.withProvider(),
        );

      case AppRouteConstant.itineraryDestinationSelection:
        final province = settings.arguments as String;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (_) => sl<GetDestinationCubit>(),
                child: DestinationSelectionPage(province: province),
              ),
        );

      case AppRouteConstant.itineraryCreation:
        final args = settings.arguments as Map<String, dynamic>;
        final province = args['province'] as String;
        final destinations = args['destinations'] as List<Destination>;
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => ItineraryCreationPage(
                province: province,
                selectedDestinations: destinations,
              ),
        );

      case AppRouteConstant.myItinerary:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MyItineraryPage(),
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
