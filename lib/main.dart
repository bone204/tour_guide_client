import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tour_guide_app/common/bloc/auth/auth_state_cubit.dart';
import 'package:tour_guide_app/common/bloc/lang/locale_cubit.dart';
import 'package:tour_guide_app/common/bloc/lang/locale_state.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/config/lang/l10n.dart';
import 'package:tour_guide_app/features/splash/presentation/pages/splash_screen.page.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/features/notifications/presentation/bloc/notification_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/anniversary/bloc/anniversary_cubit.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Load environment variables (optional)
      try {
        await dotenv.load(fileName: ".env");
      } catch (e) {
        debugPrint('Warning: .env file not found, using default values');
      }

      String initialRoute = AppRouteConstant.signIn;

      FlutterError.onError = (FlutterErrorDetails details) {
        if (kDebugMode &&
            (details.exception.toString().contains('mouse_tracker.dart') ||
                details.exception.toString().contains('!_debugLocked'))) {
          debugPrint('Framework assertion filtered: ${details.exception}');
          return;
        }

        FlutterError.presentError(details);
        Zone.current.handleUncaughtError(
          details.exception,
          details.stack ?? StackTrace.empty,
        );
      };

      final prefs = await SharedPreferences.getInstance();
      setUpServiceLocator(prefs);

      runApp(MyApp(initialRoute: initialRoute));
    },
    (error, stackTrace) {
      debugPrint('ERROR: $error');
      debugPrint('STACKTRACE: $stackTrace');
    },
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthStateCubit()..appStarted()),
        BlocProvider(create: (context) => LocaleCubit()),
        BlocProvider(create: (context) => sl<NotificationCubit>(), lazy: false),
        BlocProvider(create: (context) => sl<AnniversaryCubit>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, state) {
              Locale locale = const Locale('en');
              if (state is LocaleLoaded) {
                locale = state.locale;
              }

              return MaterialApp(
                navigatorKey: navigatorKey,
                theme: AppTheme.lightTheme,
                onGenerateRoute: AppRouter.generateRoute,
                debugShowCheckedModeBanner: false,
                supportedLocales: L10n.all,
                locale: locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                home: const SplashScreenPage(),
              );
            },
          );
        },
      ),
    );
  }
}
