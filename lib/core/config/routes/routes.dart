import 'package:flutter/services.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/auth/presentation/pages/sign_in.page.dart';
import 'package:tour_guide_app/features/auth/presentation/pages/sign_up.page.dart';
import 'package:tour_guide_app/features/bike_rental/presentation/pages/bike_rental.page.dart';
import 'package:tour_guide_app/features/car_rental/presentation/pages/car_rental.page.dart';
import 'package:tour_guide_app/features/main_screen.dart';
import 'package:tour_guide_app/features/settings/presentation/pages/change_language.page.dart';

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

      case AppRouteConstant.bikeRental:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BikeRentalPage(),
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
