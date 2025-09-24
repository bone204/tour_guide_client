import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @signInNow.
  ///
  /// In en, this message translates to:
  /// **'Sign in now'**
  String get signInNow;

  /// No description provided for @signInDescription.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to continue using our app'**
  String get signInDescription;

  /// No description provided for @usernameOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Username/Email'**
  String get usernameOrEmail;

  /// No description provided for @enterUsernameOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter username or email'**
  String get enterUsernameOrEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @orConnect.
  ///
  /// In en, this message translates to:
  /// **'Or connect'**
  String get orConnect;

  /// No description provided for @signUpNow.
  ///
  /// In en, this message translates to:
  /// **'Sign up now'**
  String get signUpNow;

  /// No description provided for @signUpDescription.
  ///
  /// In en, this message translates to:
  /// **'Please fill the details and create account'**
  String get signUpDescription;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter username'**
  String get enterUsername;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enterEmail;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @enterConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get enterConfirmPassword;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @discoverSub.
  ///
  /// In en, this message translates to:
  /// **'Discover and share unique travel experiences'**
  String get discoverSub;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @accountAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Account & Security'**
  String get accountAndSecurity;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @accountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInfo;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get terms;

  /// No description provided for @policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get policy;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @vietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get vietnamese;

  /// No description provided for @carRental.
  ///
  /// In en, this message translates to:
  /// **'Car Rental'**
  String get carRental;

  /// No description provided for @bikeRental.
  ///
  /// In en, this message translates to:
  /// **'Motorbike Rental'**
  String get bikeRental;

  /// No description provided for @busBooking.
  ///
  /// In en, this message translates to:
  /// **'Bus Booking'**
  String get busBooking;

  /// No description provided for @findRes.
  ///
  /// In en, this message translates to:
  /// **'Find Restaurant'**
  String get findRes;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Fast Delivery'**
  String get delivery;

  /// No description provided for @findHotel.
  ///
  /// In en, this message translates to:
  /// **'Find Hotel'**
  String get findHotel;

  /// No description provided for @exclusiveVouchers.
  ///
  /// In en, this message translates to:
  /// **'Exclusive Vouchers'**
  String get exclusiveVouchers;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @popularDes.
  ///
  /// In en, this message translates to:
  /// **'The best destination for you'**
  String get popularDes;

  /// No description provided for @nearby.
  ///
  /// In en, this message translates to:
  /// **'Destination nearby'**
  String get nearby;

  /// No description provided for @nearbyDes.
  ///
  /// In en, this message translates to:
  /// **'Explore spots around you'**
  String get nearbyDes;

  /// No description provided for @hotelNearby.
  ///
  /// In en, this message translates to:
  /// **'Hotels nearby'**
  String get hotelNearby;

  /// No description provided for @hotelNearbyDes.
  ///
  /// In en, this message translates to:
  /// **'Nearby hotels for your stay'**
  String get hotelNearbyDes;

  /// No description provided for @restaurantNearby.
  ///
  /// In en, this message translates to:
  /// **'Restaurants nearby'**
  String get restaurantNearby;

  /// No description provided for @restaurantNearbyDes.
  ///
  /// In en, this message translates to:
  /// **'Dining options nearby'**
  String get restaurantNearbyDes;

  /// No description provided for @attraction.
  ///
  /// In en, this message translates to:
  /// **'More travel inspiration'**
  String get attraction;

  /// No description provided for @attractionDes.
  ///
  /// In en, this message translates to:
  /// **'Extra highlights for you!'**
  String get attractionDes;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price range'**
  String get priceRange;

  /// No description provided for @hourlyRent.
  ///
  /// In en, this message translates to:
  /// **'Hourly Rent'**
  String get hourlyRent;

  /// No description provided for @dailyRent.
  ///
  /// In en, this message translates to:
  /// **'Daily Rent'**
  String get dailyRent;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get endDate;

  /// No description provided for @selectDateAndHour.
  ///
  /// In en, this message translates to:
  /// **'Select date and hour'**
  String get selectDateAndHour;

  /// No description provided for @startHour.
  ///
  /// In en, this message translates to:
  /// **'Start hour'**
  String get startHour;

  /// No description provided for @endHour.
  ///
  /// In en, this message translates to:
  /// **'End hour'**
  String get endHour;

  /// No description provided for @selectHour.
  ///
  /// In en, this message translates to:
  /// **'Selecr hour'**
  String get selectHour;

  /// No description provided for @pickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Pickup location'**
  String get pickupLocation;

  /// No description provided for @selectPickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Select pickup location'**
  String get selectPickupLocation;

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rent;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @seats.
  ///
  /// In en, this message translates to:
  /// **'seats'**
  String get seats;

  /// No description provided for @carList.
  ///
  /// In en, this message translates to:
  /// **'Car List'**
  String get carList;

  /// No description provided for @motorbikeList.
  ///
  /// In en, this message translates to:
  /// **'Motorbike List'**
  String get motorbikeList;

  /// No description provided for @carDetails.
  ///
  /// In en, this message translates to:
  /// **'Car Details'**
  String get carDetails;

  /// No description provided for @mortorbikeDetails.
  ///
  /// In en, this message translates to:
  /// **'Motorbike Details'**
  String get mortorbikeDetails;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
