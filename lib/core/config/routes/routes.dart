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
          pageBuilder: (_, __, ___) => const HomeSearchPage(),
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

      default:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => PopScope(
                canPop: false,
                child: Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ),
              ),
        );
    }
  }
}
