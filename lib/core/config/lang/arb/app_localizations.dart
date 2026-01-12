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

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get phoneInvalid;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get emailInvalid;

  /// No description provided for @updateContactInfo.
  ///
  /// In en, this message translates to:
  /// **'Update Contact Info'**
  String get updateContactInfo;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @youHaveNotVerifiedIdentity.
  ///
  /// In en, this message translates to:
  /// **'You have not verified your identity'**
  String get youHaveNotVerifiedIdentity;

  /// No description provided for @emailNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Your email has not been verified'**
  String get emailNotVerified;

  /// No description provided for @phoneNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Your phone number has not been verified'**
  String get phoneNotVerified;

  /// No description provided for @deleteStopSuccess.
  ///
  /// In en, this message translates to:
  /// **'Delete stop successfully'**
  String get deleteStopSuccess;

  /// No description provided for @deleteStopConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Stop'**
  String get deleteStopConfirmTitle;

  /// No description provided for @deleteStopConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this stop?'**
  String get deleteStopConfirmMessage;

  /// No description provided for @vehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicle;

  /// No description provided for @contractDetails.
  ///
  /// In en, this message translates to:
  /// **'Contract Details'**
  String get contractDetails;

  /// No description provided for @signInNow.
  ///
  /// In en, this message translates to:
  /// **'Sign in now'**
  String get signInNow;

  /// No description provided for @searchAddress.
  ///
  /// In en, this message translates to:
  /// **'Search address...'**
  String get searchAddress;

  /// No description provided for @selectedLocation.
  ///
  /// In en, this message translates to:
  /// **'Selected Location'**
  String get selectedLocation;

  /// No description provided for @tapToSelectLocation.
  ///
  /// In en, this message translates to:
  /// **'Tap to select location on map'**
  String get tapToSelectLocation;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirmLocation;

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

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// No description provided for @mapType.
  ///
  /// In en, this message translates to:
  /// **'Map Type'**
  String get mapType;

  /// No description provided for @mapTypeNormal.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get mapTypeNormal;

  /// No description provided for @mapTypeSatellite.
  ///
  /// In en, this message translates to:
  /// **'Satellite'**
  String get mapTypeSatellite;

  /// No description provided for @mapTypeTerrain.
  ///
  /// In en, this message translates to:
  /// **'Terrain'**
  String get mapTypeTerrain;

  /// No description provided for @statusBooked.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get statusBooked;

  /// No description provided for @statusDelivering.
  ///
  /// In en, this message translates to:
  /// **'Delivering'**
  String get statusDelivering;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @discardChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get discardChangesTitle;

  /// No description provided for @discardChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to discard your changes?'**
  String get discardChangesMessage;

  /// No description provided for @statusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get statusDelivered;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get statusInProgress;

  /// No description provided for @statusReturnRequested.
  ///
  /// In en, this message translates to:
  /// **'Return Requested'**
  String get statusReturnRequested;

  /// No description provided for @statusReturnConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Return Confirmed'**
  String get statusReturnConfirmed;

  /// No description provided for @rentalStartDelivery.
  ///
  /// In en, this message translates to:
  /// **'Start Delivery'**
  String get rentalStartDelivery;

  /// No description provided for @rentalDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get rentalDelivered;

  /// No description provided for @rentalConfirmReturn.
  ///
  /// In en, this message translates to:
  /// **'Confirm Return'**
  String get rentalConfirmReturn;

  /// No description provided for @rentalCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in (Receive Vehicle)'**
  String get rentalCheckIn;

  /// No description provided for @rentalCheckOut.
  ///
  /// In en, this message translates to:
  /// **'Check-out (Return Vehicle)'**
  String get rentalCheckOut;

  /// No description provided for @deliveryPhotos.
  ///
  /// In en, this message translates to:
  /// **'Delivery Photos'**
  String get deliveryPhotos;

  /// No description provided for @pickupPhotos.
  ///
  /// In en, this message translates to:
  /// **'Pickup Photos'**
  String get pickupPhotos;

  /// No description provided for @returnPhotos.
  ///
  /// In en, this message translates to:
  /// **'Return Photos'**
  String get returnPhotos;

  /// No description provided for @noImages.
  ///
  /// In en, this message translates to:
  /// **'No images'**
  String get noImages;

  /// No description provided for @trackingPhotos.
  ///
  /// In en, this message translates to:
  /// **'Tracking Photos'**
  String get trackingPhotos;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @selectImageSource.
  ///
  /// In en, this message translates to:
  /// **'Select Image Source'**
  String get selectImageSource;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get changePasswordSuccess;

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

  /// No description provided for @licensePlateInvalid.
  ///
  /// In en, this message translates to:
  /// **'License plate contains invalid characters'**
  String get licensePlateInvalid;

  /// No description provided for @selectVehicleTypeFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select vehicle type first'**
  String get selectVehicleTypeFirst;

  /// No description provided for @priceFor12HoursRequired.
  ///
  /// In en, this message translates to:
  /// **'Price for 12 hours is required'**
  String get priceFor12HoursRequired;

  /// No description provided for @priceFor2DaysRequired.
  ///
  /// In en, this message translates to:
  /// **'Price for 2 days is required'**
  String get priceFor2DaysRequired;

  /// No description provided for @anotherPriceRange.
  ///
  /// In en, this message translates to:
  /// **'Another price range'**
  String get anotherPriceRange;

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

  /// No description provided for @mappingAddress.
  ///
  /// In en, this message translates to:
  /// **'Transfer Address'**
  String get mappingAddress;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

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

  /// No description provided for @searchButton.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchButton;

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

  /// No description provided for @rentalContract.
  ///
  /// In en, this message translates to:
  /// **'Rental Contract'**
  String get rentalContract;

  /// No description provided for @vehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get vehicles;

  /// No description provided for @rentalCount.
  ///
  /// In en, this message translates to:
  /// **'Rentals'**
  String get rentalCount;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @topRatedDestinations.
  ///
  /// In en, this message translates to:
  /// **'Top rated destinations'**
  String get topRatedDestinations;

  /// No description provided for @youHaveSeenAllAttractions.
  ///
  /// In en, this message translates to:
  /// **'You have seen all attractions'**
  String get youHaveSeenAllAttractions;

  /// No description provided for @noAttractionsFound.
  ///
  /// In en, this message translates to:
  /// **'No attractions found'**
  String get noAttractionsFound;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason: {reason}'**
  String reason(String reason);

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @noContracts.
  ///
  /// In en, this message translates to:
  /// **'No contracts found'**
  String get noContracts;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerNow;

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

  /// No description provided for @selectDateAndHour.
  ///
  /// In en, this message translates to:
  /// **'Select date and hour'**
  String get selectDateAndHour;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

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

  /// No description provided for @rentalLocation.
  ///
  /// In en, this message translates to:
  /// **'Rental Location'**
  String get rentalLocation;

  /// No description provided for @rentalProvince.
  ///
  /// In en, this message translates to:
  /// **'Rental Province'**
  String get rentalProvince;

  /// No description provided for @selectRentalProvince.
  ///
  /// In en, this message translates to:
  /// **'Select rental province'**
  String get selectRentalProvince;

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rent;

  /// No description provided for @useItinerarySuccess.
  ///
  /// In en, this message translates to:
  /// **'Itinerary used successfully!'**
  String get useItinerarySuccess;

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

  /// No description provided for @rentalInfo.
  ///
  /// In en, this message translates to:
  /// **'Rental Information'**
  String get rentalInfo;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customers;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phone;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Car owner'**
  String get owner;

  /// No description provided for @rentalDays.
  ///
  /// In en, this message translates to:
  /// **'Rental days'**
  String get rentalDays;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @discountPoint.
  ///
  /// In en, this message translates to:
  /// **'Reward points discount'**
  String get discountPoint;

  /// No description provided for @choosePayment.
  ///
  /// In en, this message translates to:
  /// **'Choose payment method'**
  String get choosePayment;

  /// No description provided for @paymentQRCode.
  ///
  /// In en, this message translates to:
  /// **'Payment QR Code'**
  String get paymentQRCode;

  /// No description provided for @scanToPay.
  ///
  /// In en, this message translates to:
  /// **'Please scan the QR code to complete the payment.'**
  String get scanToPay;

  /// No description provided for @myVehicles.
  ///
  /// In en, this message translates to:
  /// **'My Vehicles'**
  String get myVehicles;

  /// No description provided for @rentalRequests.
  ///
  /// In en, this message translates to:
  /// **'Rental Requests'**
  String get rentalRequests;

  /// No description provided for @noRentalRequests.
  ///
  /// In en, this message translates to:
  /// **'No rental requests'**
  String get noRentalRequests;

  /// No description provided for @useRewardPoint.
  ///
  /// In en, this message translates to:
  /// **'Use reward points'**
  String get useRewardPoint;

  /// No description provided for @availablePoints.
  ///
  /// In en, this message translates to:
  /// **'Available points'**
  String get availablePoints;

  /// No description provided for @noUsePoint.
  ///
  /// In en, this message translates to:
  /// **'Do not use points'**
  String get noUsePoint;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'points'**
  String get points;

  /// No description provided for @flight.
  ///
  /// In en, this message translates to:
  /// **'Flight Booking'**
  String get flight;

  /// No description provided for @train.
  ///
  /// In en, this message translates to:
  /// **'Train Booking'**
  String get train;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @exitApp.
  ///
  /// In en, this message translates to:
  /// **'Exit app?'**
  String get exitApp;

  /// No description provided for @exitAppConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit the app?'**
  String get exitAppConfirm;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @newsPage.
  ///
  /// In en, this message translates to:
  /// **'News Page'**
  String get newsPage;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get errorPrefix;

  /// No description provided for @pleaseSelectLocation.
  ///
  /// In en, this message translates to:
  /// **'Please select a location and make sure location is enabled.'**
  String get pleaseSelectLocation;

  /// No description provided for @navigatingCannotSelect.
  ///
  /// In en, this message translates to:
  /// **'Currently navigating, cannot select another destination.'**
  String get navigatingCannotSelect;

  /// No description provided for @locationNoData.
  ///
  /// In en, this message translates to:
  /// **'Location does not have position data.'**
  String get locationNoData;

  /// No description provided for @pleaseSelectSeat.
  ///
  /// In en, this message translates to:
  /// **'Please select a seat'**
  String get pleaseSelectSeat;

  /// No description provided for @pleaseSelectSeatClass.
  ///
  /// In en, this message translates to:
  /// **'Please select a seat class'**
  String get pleaseSelectSeatClass;

  /// No description provided for @maxSeatsSelected.
  ///
  /// In en, this message translates to:
  /// **'Maximum {maxSeats} seats can be selected'**
  String maxSeatsSelected(int maxSeats);

  /// No description provided for @departureTrip.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get departureTrip;

  /// No description provided for @returnTrip.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get returnTrip;

  /// No description provided for @bothTripsSelected.
  ///
  /// In en, this message translates to:
  /// **'Both trips selected. Full round-trip booking feature will be completed later.'**
  String get bothTripsSelected;

  /// No description provided for @downloadingTicket.
  ///
  /// In en, this message translates to:
  /// **'Downloading ticket...'**
  String get downloadingTicket;

  /// No description provided for @sharingTicket.
  ///
  /// In en, this message translates to:
  /// **'Sharing ticket...'**
  String get sharingTicket;

  /// No description provided for @pleaseSelectAtLeastOneRoom.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one room'**
  String get pleaseSelectAtLeastOneRoom;

  /// No description provided for @pleaseSelectDeliveryCompany.
  ///
  /// In en, this message translates to:
  /// **'Please select a delivery company'**
  String get pleaseSelectDeliveryCompany;

  /// No description provided for @pleaseSelectVehicleType.
  ///
  /// In en, this message translates to:
  /// **'Please select a vehicle type'**
  String get pleaseSelectVehicleType;

  /// No description provided for @pleaseSelectPickupPoint.
  ///
  /// In en, this message translates to:
  /// **'Please select a pickup point'**
  String get pleaseSelectPickupPoint;

  /// No description provided for @pleaseSelectDeliveryPoint.
  ///
  /// In en, this message translates to:
  /// **'Please select a delivery point'**
  String get pleaseSelectDeliveryPoint;

  /// No description provided for @errorSelectingImage.
  ///
  /// In en, this message translates to:
  /// **'Error selecting image: {error}'**
  String errorSelectingImage(String error);

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @selectFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Select from gallery'**
  String get selectFromGallery;

  /// No description provided for @viewImage.
  ///
  /// In en, this message translates to:
  /// **'View image'**
  String get viewImage;

  /// No description provided for @selectPackageImage.
  ///
  /// In en, this message translates to:
  /// **'Select package image'**
  String get selectPackageImage;

  /// No description provided for @packageImages.
  ///
  /// In en, this message translates to:
  /// **'Package images'**
  String get packageImages;

  /// No description provided for @addImage.
  ///
  /// In en, this message translates to:
  /// **'Add image'**
  String get addImage;

  /// No description provided for @tapToAddImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to add image'**
  String get tapToAddImage;

  /// No description provided for @bookingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking Successful!'**
  String get bookingSuccess;

  /// No description provided for @tableBookingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Table booking successful!'**
  String get tableBookingSuccess;

  /// No description provided for @pleaseConfirmPolicies.
  ///
  /// In en, this message translates to:
  /// **'Please confirm all policies'**
  String get pleaseConfirmPolicies;

  /// No description provided for @pleaseSelectSeatTrain.
  ///
  /// In en, this message translates to:
  /// **'Please select a seat'**
  String get pleaseSelectSeatTrain;

  /// No description provided for @pleaseSelectSeatClassTrain.
  ///
  /// In en, this message translates to:
  /// **'Please select a seat class'**
  String get pleaseSelectSeatClassTrain;

  /// No description provided for @maxSeatsSelectedTrain.
  ///
  /// In en, this message translates to:
  /// **'Maximum {maxSeats} seats can be selected'**
  String maxSeatsSelectedTrain(int maxSeats);

  /// No description provided for @pleaseSelectSeatBus.
  ///
  /// In en, this message translates to:
  /// **'Please select a seat'**
  String get pleaseSelectSeatBus;

  /// No description provided for @maxSeatsSelectedBus.
  ///
  /// In en, this message translates to:
  /// **'Maximum {maxSeats} seats can be selected'**
  String maxSeatsSelectedBus(int maxSeats);

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @noRouteDefined.
  ///
  /// In en, this message translates to:
  /// **'No route defined for {routeName}'**
  String noRouteDefined(String routeName);

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Traveline - Vietnam in your mind'**
  String get appTitle;

  /// No description provided for @bookingInfo.
  ///
  /// In en, this message translates to:
  /// **'Booking Information'**
  String get bookingInfo;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @tableBookingInfo.
  ///
  /// In en, this message translates to:
  /// **'Table Booking Information'**
  String get tableBookingInfo;

  /// No description provided for @confirmTableBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Table Booking'**
  String get confirmTableBooking;

  /// No description provided for @fastDeliveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Fast Delivery'**
  String get fastDeliveryTitle;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @selectRoom.
  ///
  /// In en, this message translates to:
  /// **'Select Room'**
  String get selectRoom;

  /// No description provided for @busTicket.
  ///
  /// In en, this message translates to:
  /// **'Bus Ticket'**
  String get busTicket;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @downloadTicket.
  ///
  /// In en, this message translates to:
  /// **'Download Ticket'**
  String get downloadTicket;

  /// No description provided for @shareTicket.
  ///
  /// In en, this message translates to:
  /// **'Share Ticket'**
  String get shareTicket;

  /// No description provided for @selectBusTrip.
  ///
  /// In en, this message translates to:
  /// **'Select Bus Trip'**
  String get selectBusTrip;

  /// No description provided for @selectRoundTrip.
  ///
  /// In en, this message translates to:
  /// **'Select Round Trip'**
  String get selectRoundTrip;

  /// No description provided for @busTripDetails.
  ///
  /// In en, this message translates to:
  /// **'Bus Trip Details'**
  String get busTripDetails;

  /// No description provided for @busTripInfo.
  ///
  /// In en, this message translates to:
  /// **'Bus Trip Information'**
  String get busTripInfo;

  /// No description provided for @amenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get amenities;

  /// No description provided for @trainTicket.
  ///
  /// In en, this message translates to:
  /// **'Train Ticket'**
  String get trainTicket;

  /// No description provided for @trainTripDetails.
  ///
  /// In en, this message translates to:
  /// **'Train Trip Details'**
  String get trainTripDetails;

  /// No description provided for @trainTripInfo.
  ///
  /// In en, this message translates to:
  /// **'Train Trip Information'**
  String get trainTripInfo;

  /// No description provided for @trainAmenities.
  ///
  /// In en, this message translates to:
  /// **'Train Amenities'**
  String get trainAmenities;

  /// No description provided for @selectSeatToContinue.
  ///
  /// In en, this message translates to:
  /// **'Select seat to continue'**
  String get selectSeatToContinue;

  /// No description provided for @flightTicket.
  ///
  /// In en, this message translates to:
  /// **'Flight Ticket'**
  String get flightTicket;

  /// No description provided for @flightTripDetails.
  ///
  /// In en, this message translates to:
  /// **'Flight Trip Details'**
  String get flightTripDetails;

  /// No description provided for @flightTripInfo.
  ///
  /// In en, this message translates to:
  /// **'Flight Trip Information'**
  String get flightTripInfo;

  /// No description provided for @flightAmenities.
  ///
  /// In en, this message translates to:
  /// **'Flight Amenities'**
  String get flightAmenities;

  /// No description provided for @selectSeatToContinueFlight.
  ///
  /// In en, this message translates to:
  /// **'Select seat to continue'**
  String get selectSeatToContinueFlight;

  /// No description provided for @selectFlightTrip.
  ///
  /// In en, this message translates to:
  /// **'Select Flight Trip'**
  String get selectFlightTrip;

  /// No description provided for @selectTrainTrip.
  ///
  /// In en, this message translates to:
  /// **'Select Train Trip'**
  String get selectTrainTrip;

  /// No description provided for @selectProvince.
  ///
  /// In en, this message translates to:
  /// **'Select Province/City'**
  String get selectProvince;

  /// No description provided for @createItinerary.
  ///
  /// In en, this message translates to:
  /// **'Create Itinerary'**
  String get createItinerary;

  /// No description provided for @myVehicle.
  ///
  /// In en, this message translates to:
  /// **'My Vehicle'**
  String get myVehicle;

  /// No description provided for @addVehicle.
  ///
  /// In en, this message translates to:
  /// **'Add Vehicle'**
  String get addVehicle;

  /// No description provided for @businessRegisterPhoto.
  ///
  /// In en, this message translates to:
  /// **'Business Register Photo'**
  String get businessRegisterPhoto;

  /// No description provided for @identificationPhoto.
  ///
  /// In en, this message translates to:
  /// **'Identification Photo'**
  String get identificationPhoto;

  /// No description provided for @vehicleRegistrationFrontPhoto.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Registration Front Photo'**
  String get vehicleRegistrationFrontPhoto;

  /// No description provided for @vehicleRegistrationBackPhoto.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Registration Back Photo'**
  String get vehicleRegistrationBackPhoto;

  /// No description provided for @travelAssistant.
  ///
  /// In en, this message translates to:
  /// **'Traveline Travel Assistant'**
  String get travelAssistant;

  /// No description provided for @bookTable.
  ///
  /// In en, this message translates to:
  /// **'Book Table'**
  String get bookTable;

  /// No description provided for @bookRoom.
  ///
  /// In en, this message translates to:
  /// **'Book Room'**
  String get bookRoom;

  /// No description provided for @confirmBookingTicket.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBookingTicket;

  /// No description provided for @bookFlight.
  ///
  /// In en, this message translates to:
  /// **'Book Flight'**
  String get bookFlight;

  /// No description provided for @findFlight.
  ///
  /// In en, this message translates to:
  /// **'Find Flight'**
  String get findFlight;

  /// No description provided for @bookTrain.
  ///
  /// In en, this message translates to:
  /// **'Book Train'**
  String get bookTrain;

  /// No description provided for @findTrain.
  ///
  /// In en, this message translates to:
  /// **'Find Train'**
  String get findTrain;

  /// No description provided for @hotelList.
  ///
  /// In en, this message translates to:
  /// **'Hotel List'**
  String get hotelList;

  /// No description provided for @findHotel.
  ///
  /// In en, this message translates to:
  /// **'Find Hotel'**
  String get findHotel;

  /// No description provided for @selectTable.
  ///
  /// In en, this message translates to:
  /// **'Select Table'**
  String get selectTable;

  /// No description provided for @restaurantList.
  ///
  /// In en, this message translates to:
  /// **'Restaurant List'**
  String get restaurantList;

  /// No description provided for @findRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Find Restaurant'**
  String get findRestaurant;

  /// No description provided for @confirmOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get confirmOrder;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @bookBus.
  ///
  /// In en, this message translates to:
  /// **'Book Bus'**
  String get bookBus;

  /// No description provided for @findBus.
  ///
  /// In en, this message translates to:
  /// **'Find Bus Trip'**
  String get findBus;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @table.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get table;

  /// No description provided for @numberOfPeople.
  ///
  /// In en, this message translates to:
  /// **'Number of People'**
  String get numberOfPeople;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// No description provided for @totalPayment.
  ///
  /// In en, this message translates to:
  /// **'Total Payment'**
  String get totalPayment;

  /// No description provided for @pickupPoint.
  ///
  /// In en, this message translates to:
  /// **'Pickup Point'**
  String get pickupPoint;

  /// No description provided for @deliveryPoint.
  ///
  /// In en, this message translates to:
  /// **'Delivery Point'**
  String get deliveryPoint;

  /// No description provided for @recipientName.
  ///
  /// In en, this message translates to:
  /// **'Recipient Name'**
  String get recipientName;

  /// No description provided for @recipientPhone.
  ///
  /// In en, this message translates to:
  /// **'Recipient Phone'**
  String get recipientPhone;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get checkIn;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check-out'**
  String get checkOut;

  /// No description provided for @numberOfNights.
  ///
  /// In en, this message translates to:
  /// **'Number of nights'**
  String get numberOfNights;

  /// No description provided for @totalRoomPrice.
  ///
  /// In en, this message translates to:
  /// **'Total Room Price'**
  String get totalRoomPrice;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @businessType.
  ///
  /// In en, this message translates to:
  /// **'Business Type'**
  String get businessType;

  /// No description provided for @businessName.
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get businessName;

  /// No description provided for @businessAddress.
  ///
  /// In en, this message translates to:
  /// **'Business Address'**
  String get businessAddress;

  /// No description provided for @taxCode.
  ///
  /// In en, this message translates to:
  /// **'Tax Code'**
  String get taxCode;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @identificationNumber.
  ///
  /// In en, this message translates to:
  /// **'Identification Number'**
  String get identificationNumber;

  /// No description provided for @departurePoint.
  ///
  /// In en, this message translates to:
  /// **'Departure Point'**
  String get departurePoint;

  /// No description provided for @arrivalPoint.
  ///
  /// In en, this message translates to:
  /// **'Arrival Point'**
  String get arrivalPoint;

  /// No description provided for @departureDate.
  ///
  /// In en, this message translates to:
  /// **'Departure Date'**
  String get departureDate;

  /// No description provided for @returnDate.
  ///
  /// In en, this message translates to:
  /// **'Return Date'**
  String get returnDate;

  /// No description provided for @numberOfPassengers.
  ///
  /// In en, this message translates to:
  /// **'Number of Passengers'**
  String get numberOfPassengers;

  /// No description provided for @bookingTime.
  ///
  /// In en, this message translates to:
  /// **'Booking Time'**
  String get bookingTime;

  /// No description provided for @foodType.
  ///
  /// In en, this message translates to:
  /// **'Food Type'**
  String get foodType;

  /// No description provided for @checkInDate.
  ///
  /// In en, this message translates to:
  /// **'Check In Date'**
  String get checkInDate;

  /// No description provided for @checkOutDate.
  ///
  /// In en, this message translates to:
  /// **'Check Out Date'**
  String get checkOutDate;

  /// No description provided for @departureStation.
  ///
  /// In en, this message translates to:
  /// **'Departure Station'**
  String get departureStation;

  /// No description provided for @arrivalStation.
  ///
  /// In en, this message translates to:
  /// **'Arrival Station'**
  String get arrivalStation;

  /// No description provided for @departureAirport.
  ///
  /// In en, this message translates to:
  /// **'Departure Airport'**
  String get departureAirport;

  /// No description provided for @arrivalAirport.
  ///
  /// In en, this message translates to:
  /// **'Arrival Airport'**
  String get arrivalAirport;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @deliveryRequirements.
  ///
  /// In en, this message translates to:
  /// **'Delivery Requirements'**
  String get deliveryRequirements;

  /// No description provided for @bankName.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get bankName;

  /// No description provided for @bankAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'Bank Account Number'**
  String get bankAccountNumber;

  /// No description provided for @bankAccountName.
  ///
  /// In en, this message translates to:
  /// **'Bank Account Name'**
  String get bankAccountName;

  /// No description provided for @confirmInfoAccurate.
  ///
  /// In en, this message translates to:
  /// **'I confirm that all information provided is accurate and complete'**
  String get confirmInfoAccurate;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the terms and conditions of vehicle rental services'**
  String get agreeToTerms;

  /// No description provided for @authorizeBankingInfo.
  ///
  /// In en, this message translates to:
  /// **'I authorize the platform to use my banking information for payment processing'**
  String get authorizeBankingInfo;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @cmndCccd.
  ///
  /// In en, this message translates to:
  /// **'ID Card/CCCD'**
  String get cmndCccd;

  /// No description provided for @businessTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Business Type'**
  String get businessTypeLabel;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyName;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @bank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bank;

  /// No description provided for @accountHolder.
  ///
  /// In en, this message translates to:
  /// **'Account Holder'**
  String get accountHolder;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumber;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @rejectionReason.
  ///
  /// In en, this message translates to:
  /// **'Rejection Reason'**
  String get rejectionReason;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get lastUpdated;

  /// No description provided for @vehicleType.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicleType;

  /// No description provided for @brandAndModel.
  ///
  /// In en, this message translates to:
  /// **'Brand & Model'**
  String get brandAndModel;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @numberOfSeats.
  ///
  /// In en, this message translates to:
  /// **'Number of Seats'**
  String get numberOfSeats;

  /// No description provided for @pricePerHour.
  ///
  /// In en, this message translates to:
  /// **'Price Per Hour'**
  String get pricePerHour;

  /// No description provided for @pricePerDay.
  ///
  /// In en, this message translates to:
  /// **'Price Per Day'**
  String get pricePerDay;

  /// No description provided for @priceFor4Hours.
  ///
  /// In en, this message translates to:
  /// **'Price for 4 Hours'**
  String get priceFor4Hours;

  /// No description provided for @priceFor8Hours.
  ///
  /// In en, this message translates to:
  /// **'Price for 8 Hours'**
  String get priceFor8Hours;

  /// No description provided for @priceFor12Hours.
  ///
  /// In en, this message translates to:
  /// **'Price for 12 Hours'**
  String get priceFor12Hours;

  /// No description provided for @priceFor2Days.
  ///
  /// In en, this message translates to:
  /// **'Price for 2 Days'**
  String get priceFor2Days;

  /// No description provided for @priceFor3Days.
  ///
  /// In en, this message translates to:
  /// **'Price for 3 Days'**
  String get priceFor3Days;

  /// No description provided for @priceFor5Days.
  ///
  /// In en, this message translates to:
  /// **'Price for 5 Days'**
  String get priceFor5Days;

  /// No description provided for @priceFor7Days.
  ///
  /// In en, this message translates to:
  /// **'Price for 7 Days'**
  String get priceFor7Days;

  /// No description provided for @fuelType.
  ///
  /// In en, this message translates to:
  /// **'Fuel Type'**
  String get fuelType;

  /// No description provided for @transmission.
  ///
  /// In en, this message translates to:
  /// **'Transmission'**
  String get transmission;

  /// No description provided for @seatingCapacity.
  ///
  /// In en, this message translates to:
  /// **'Seating Capacity'**
  String get seatingCapacity;

  /// No description provided for @maxSpeed.
  ///
  /// In en, this message translates to:
  /// **'Max Speed'**
  String get maxSpeed;

  /// No description provided for @transmissionManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get transmissionManual;

  /// No description provided for @transmissionAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get transmissionAutomatic;

  /// No description provided for @fuelGasoline.
  ///
  /// In en, this message translates to:
  /// **'Gasoline'**
  String get fuelGasoline;

  /// No description provided for @fuelElectric.
  ///
  /// In en, this message translates to:
  /// **'Electric'**
  String get fuelElectric;

  /// No description provided for @totalRentals.
  ///
  /// In en, this message translates to:
  /// **'Total Rentals'**
  String get totalRentals;

  /// No description provided for @averageRating.
  ///
  /// In en, this message translates to:
  /// **'Average Rating'**
  String get averageRating;

  /// No description provided for @approvalStatus.
  ///
  /// In en, this message translates to:
  /// **'Approval Status'**
  String get approvalStatus;

  /// No description provided for @requirements.
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get requirements;

  /// No description provided for @rejectionReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Rejection Reason'**
  String get rejectionReasonLabel;

  /// No description provided for @selectPickupPoint.
  ///
  /// In en, this message translates to:
  /// **'Select Pickup Point'**
  String get selectPickupPoint;

  /// No description provided for @selectDeliveryPoint.
  ///
  /// In en, this message translates to:
  /// **'Select Delivery Point'**
  String get selectDeliveryPoint;

  /// No description provided for @enterRecipientName.
  ///
  /// In en, this message translates to:
  /// **'Enter Recipient Name'**
  String get enterRecipientName;

  /// No description provided for @enterRecipientPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter Recipient Phone'**
  String get enterRecipientPhone;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter Username'**
  String get enterUsername;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enterPassword;

  /// No description provided for @enterBusinessName.
  ///
  /// In en, this message translates to:
  /// **'Enter Business Name'**
  String get enterBusinessName;

  /// No description provided for @enterBusinessAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter Business Address'**
  String get enterBusinessAddress;

  /// No description provided for @enterTaxCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Tax Code'**
  String get enterTaxCode;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Full Name'**
  String get enterFullName;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Email'**
  String get enterEmail;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Phone Number'**
  String get enterPhoneNumber;

  /// No description provided for @enterIdNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Your ID Number'**
  String get enterIdNumber;

  /// No description provided for @selectDeparturePoint.
  ///
  /// In en, this message translates to:
  /// **'Select Departure Point'**
  String get selectDeparturePoint;

  /// No description provided for @selectArrivalPoint.
  ///
  /// In en, this message translates to:
  /// **'Select Arrival Point'**
  String get selectArrivalPoint;

  /// No description provided for @selectDepartureDate.
  ///
  /// In en, this message translates to:
  /// **'Select Departure Date'**
  String get selectDepartureDate;

  /// No description provided for @selectReturnDate.
  ///
  /// In en, this message translates to:
  /// **'Select Return Date'**
  String get selectReturnDate;

  /// No description provided for @selectDateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Select Date and Time'**
  String get selectDateAndTime;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// No description provided for @selectCheckInDate.
  ///
  /// In en, this message translates to:
  /// **'Select Check In Date'**
  String get selectCheckInDate;

  /// No description provided for @selectCheckOutDate.
  ///
  /// In en, this message translates to:
  /// **'Select Check Out Date'**
  String get selectCheckOutDate;

  /// No description provided for @selectPlace.
  ///
  /// In en, this message translates to:
  /// **'Select Place'**
  String get selectPlace;

  /// No description provided for @selectDepartureStation.
  ///
  /// In en, this message translates to:
  /// **'Select Departure Station'**
  String get selectDepartureStation;

  /// No description provided for @selectArrivalStation.
  ///
  /// In en, this message translates to:
  /// **'Select Arrival Station'**
  String get selectArrivalStation;

  /// No description provided for @selectDepartureAirport.
  ///
  /// In en, this message translates to:
  /// **'Select Departure Airport'**
  String get selectDepartureAirport;

  /// No description provided for @selectArrivalAirport.
  ///
  /// In en, this message translates to:
  /// **'Select Arrival Airport'**
  String get selectArrivalAirport;

  /// No description provided for @enterAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Account Number'**
  String get enterAccountNumber;

  /// No description provided for @enterAccountHolderName.
  ///
  /// In en, this message translates to:
  /// **'Enter Account Holder Name'**
  String get enterAccountHolderName;

  /// No description provided for @enterPricePerHour.
  ///
  /// In en, this message translates to:
  /// **'Enter Price Per Hour'**
  String get enterPricePerHour;

  /// No description provided for @enterPricePerDay.
  ///
  /// In en, this message translates to:
  /// **'Enter Price Per Day'**
  String get enterPricePerDay;

  /// No description provided for @enterRegistrationNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Registration Number'**
  String get enterRegistrationNumber;

  /// No description provided for @exampleBrand.
  ///
  /// In en, this message translates to:
  /// **'e.g. Honda, Toyota'**
  String get exampleBrand;

  /// No description provided for @exampleModel.
  ///
  /// In en, this message translates to:
  /// **'e.g. City, Wave'**
  String get exampleModel;

  /// No description provided for @exampleColor.
  ///
  /// In en, this message translates to:
  /// **'e.g. Black, White'**
  String get exampleColor;

  /// No description provided for @cancelSuccess.
  ///
  /// In en, this message translates to:
  /// **'Cancelled successfully'**
  String get cancelSuccess;

  /// No description provided for @cancelBill.
  ///
  /// In en, this message translates to:
  /// **'Cancel Bill'**
  String get cancelBill;

  /// No description provided for @confirmCancelBill.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this bill?'**
  String get confirmCancelBill;

  /// No description provided for @cancelReasonTooShort.
  ///
  /// In en, this message translates to:
  /// **'Reason must be at least 10 characters'**
  String get cancelReasonTooShort;

  /// No description provided for @itineraryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Explore Da Nang 3 days'**
  String get itineraryHint;

  /// No description provided for @enterFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Full Name'**
  String get enterFullNameHint;

  /// No description provided for @enterPhoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Phone Number'**
  String get enterPhoneNumberHint;

  /// No description provided for @car.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get car;

  /// No description provided for @motorbike.
  ///
  /// In en, this message translates to:
  /// **'Motorbike'**
  String get motorbike;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @vehicleRegistrationNumber.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Registration Number'**
  String get vehicleRegistrationNumber;

  /// No description provided for @vehicleBrand.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Brand'**
  String get vehicleBrand;

  /// No description provided for @vehicleModel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Model'**
  String get vehicleModel;

  /// No description provided for @vehicleColor.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Color'**
  String get vehicleColor;

  /// No description provided for @contractOwnerInfo.
  ///
  /// In en, this message translates to:
  /// **'Contract Owner Information'**
  String get contractOwnerInfo;

  /// No description provided for @contractInfo.
  ///
  /// In en, this message translates to:
  /// **'Contract Information'**
  String get contractInfo;

  /// No description provided for @companyInfo.
  ///
  /// In en, this message translates to:
  /// **'Company Information'**
  String get companyInfo;

  /// No description provided for @bankingInfo.
  ///
  /// In en, this message translates to:
  /// **'Banking Information'**
  String get bankingInfo;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @citizenId.
  ///
  /// In en, this message translates to:
  /// **'Citizen ID'**
  String get citizenId;

  /// No description provided for @province.
  ///
  /// In en, this message translates to:
  /// **'Province'**
  String get province;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @createdDate.
  ///
  /// In en, this message translates to:
  /// **'Created Date'**
  String get createdDate;

  /// No description provided for @updatedDate.
  ///
  /// In en, this message translates to:
  /// **'Updated Date'**
  String get updatedDate;

  /// No description provided for @citizenIdPhoto.
  ///
  /// In en, this message translates to:
  /// **'Citizen ID Photo'**
  String get citizenIdPhoto;

  /// No description provided for @citizenFrontPhoto.
  ///
  /// In en, this message translates to:
  /// **'Citizen ID Front Photo'**
  String get citizenFrontPhoto;

  /// No description provided for @registeredVehicles.
  ///
  /// In en, this message translates to:
  /// **'Registered Vehicles'**
  String get registeredVehicles;

  /// No description provided for @businessInfo.
  ///
  /// In en, this message translates to:
  /// **'Business Information'**
  String get businessInfo;

  /// No description provided for @contractDetail.
  ///
  /// In en, this message translates to:
  /// **'Contract Detail'**
  String get contractDetail;

  /// No description provided for @notesAndStatus.
  ///
  /// In en, this message translates to:
  /// **'Notes & Status'**
  String get notesAndStatus;

  /// No description provided for @vehicleInfo.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Information'**
  String get vehicleInfo;

  /// No description provided for @priceAndPerformance.
  ///
  /// In en, this message translates to:
  /// **'Price & Performance'**
  String get priceAndPerformance;

  /// No description provided for @statusAndRequirements.
  ///
  /// In en, this message translates to:
  /// **'Status & Requirements'**
  String get statusAndRequirements;

  /// No description provided for @personal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personal;

  /// No description provided for @business.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get business;

  /// No description provided for @numberOfRooms.
  ///
  /// In en, this message translates to:
  /// **'Number of Rooms'**
  String get numberOfRooms;

  /// No description provided for @numberOfGuests.
  ///
  /// In en, this message translates to:
  /// **'Number of Guests'**
  String get numberOfGuests;

  /// No description provided for @licensePlate.
  ///
  /// In en, this message translates to:
  /// **'License Plate'**
  String get licensePlate;

  /// No description provided for @pricePerHourVnd.
  ///
  /// In en, this message translates to:
  /// **'Price Per Hour (VND)'**
  String get pricePerHourVnd;

  /// No description provided for @pricePerDayVnd.
  ///
  /// In en, this message translates to:
  /// **'Price Per Day (VND)'**
  String get pricePerDayVnd;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} is required'**
  String fieldRequired(Object fieldName);

  /// No description provided for @pleaseEnterValidPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid price'**
  String get pleaseEnterValidPrice;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @pleaseEnterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 10-digit phone number'**
  String get pleaseEnterValidPhone;

  /// No description provided for @pleaseSelectBank.
  ///
  /// In en, this message translates to:
  /// **'Please select a bank'**
  String get pleaseSelectBank;

  /// No description provided for @pleaseEnterUsername.
  ///
  /// In en, this message translates to:
  /// **'Please enter username'**
  String get pleaseEnterUsername;

  /// No description provided for @usernameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters'**
  String get usernameMinLength;

  /// No description provided for @usernameMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Username must not exceed 20 characters'**
  String get usernameMaxLength;

  /// No description provided for @usernameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Username can only contain letters, numbers and underscores'**
  String get usernameInvalid;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get pleaseEnterPassword;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm password'**
  String get pleaseConfirmPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @usernameAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Username already exists'**
  String get usernameAlreadyExists;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid username or password'**
  String get invalidCredentials;

  /// No description provided for @pleaseEnterEmailOrUsername.
  ///
  /// In en, this message translates to:
  /// **'Please enter email or username'**
  String get pleaseEnterEmailOrUsername;

  /// No description provided for @pleaseEnterValidEmailOrUsername.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email or username'**
  String get pleaseEnterValidEmailOrUsername;

  /// No description provided for @pleaseEnterRecipientName.
  ///
  /// In en, this message translates to:
  /// **'Please enter recipient name'**
  String get pleaseEnterRecipientName;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @phoneNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get phoneNumberInvalid;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @suspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get suspended;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @rented.
  ///
  /// In en, this message translates to:
  /// **'Rented'**
  String get rented;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @rentalVehicle.
  ///
  /// In en, this message translates to:
  /// **'Rental Vehicle'**
  String get rentalVehicle;

  /// No description provided for @rentalVehicleDefault.
  ///
  /// In en, this message translates to:
  /// **'Rental vehicle'**
  String get rentalVehicleDefault;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @memoryLane.
  ///
  /// In en, this message translates to:
  /// **'Memory Lane'**
  String get memoryLane;

  /// No description provided for @noMemoriesToday.
  ///
  /// In en, this message translates to:
  /// **'No memories today'**
  String get noMemoriesToday;

  /// No description provided for @sinceYouCompleted.
  ///
  /// In en, this message translates to:
  /// **'Since you completed'**
  String get sinceYouCompleted;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @itinerary.
  ///
  /// In en, this message translates to:
  /// **'Itinerary'**
  String get itinerary;

  /// No description provided for @hotel.
  ///
  /// In en, this message translates to:
  /// **'Hotel'**
  String get hotel;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session Expired'**
  String get sessionExpired;

  /// No description provided for @sessionExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Your login session has expired. Please sign in again.'**
  String get sessionExpiredMessage;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @searchDestinationHint.
  ///
  /// In en, this message translates to:
  /// **'Search for destination...'**
  String get searchDestinationHint;

  /// No description provided for @rentalPickupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Vehicle picked up successfully'**
  String get rentalPickupSuccess;

  /// No description provided for @rentalReturnRequestSuccess.
  ///
  /// In en, this message translates to:
  /// **'Return request sent successfully'**
  String get rentalReturnRequestSuccess;

  /// No description provided for @rentalStartDeliverySuccess.
  ///
  /// In en, this message translates to:
  /// **'Delivery started successfully'**
  String get rentalStartDeliverySuccess;

  /// No description provided for @rentalDeliveredSuccess.
  ///
  /// In en, this message translates to:
  /// **'Delivery confirmed successfully'**
  String get rentalDeliveredSuccess;

  /// No description provided for @rentalConfirmReturnSuccess.
  ///
  /// In en, this message translates to:
  /// **'Return confirmed successfully'**
  String get rentalConfirmReturnSuccess;

  /// No description provided for @locationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Location permission required'**
  String get locationPermissionRequired;

  /// No description provided for @locationPermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied'**
  String get locationPermissionDeniedForever;

  /// No description provided for @locationError.
  ///
  /// In en, this message translates to:
  /// **'Error getting location: {error}'**
  String locationError(String error);

  /// No description provided for @searchFavoritePlaceHint.
  ///
  /// In en, this message translates to:
  /// **'Search favorite places...'**
  String get searchFavoritePlaceHint;

  /// No description provided for @searchProvinceHint.
  ///
  /// In en, this message translates to:
  /// **'Search province/city...'**
  String get searchProvinceHint;

  /// No description provided for @selectRentType.
  ///
  /// In en, this message translates to:
  /// **'Please select rental type in filter'**
  String get selectRentType;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @unverified.
  ///
  /// In en, this message translates to:
  /// **'Unverified'**
  String get unverified;

  /// No description provided for @selectVoucher.
  ///
  /// In en, this message translates to:
  /// **'Select Voucher'**
  String get selectVoucher;

  /// No description provided for @finalPrice.
  ///
  /// In en, this message translates to:
  /// **'Final Price'**
  String get finalPrice;

  /// No description provided for @voucherDiscount.
  ///
  /// In en, this message translates to:
  /// **'Voucher Discount'**
  String get voucherDiscount;

  /// No description provided for @pointDiscount.
  ///
  /// In en, this message translates to:
  /// **'Point Discount'**
  String get pointDiscount;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @billCode.
  ///
  /// In en, this message translates to:
  /// **'Bill Code'**
  String get billCode;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @contractTitle.
  ///
  /// In en, this message translates to:
  /// **'Contract #{id}'**
  String contractTitle(int id);

  /// No description provided for @vehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle #{licensePlate}'**
  String vehicleTitle(String licensePlate);

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description available'**
  String get noDescription;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @vehicleDetail.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Detail'**
  String get vehicleDetail;

  /// No description provided for @flagUS.
  ///
  /// In en, this message translates to:
  /// **'🇺🇸'**
  String get flagUS;

  /// No description provided for @flagVN.
  ///
  /// In en, this message translates to:
  /// **'🇻🇳'**
  String get flagVN;

  /// No description provided for @searchResultsCount.
  ///
  /// In en, this message translates to:
  /// **'Found {count} results'**
  String searchResultsCount(int count);

  /// No description provided for @noComments.
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get noComments;

  /// No description provided for @addComment.
  ///
  /// In en, this message translates to:
  /// **'Add a comment...'**
  String get addComment;

  /// No description provided for @like.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get like;

  /// No description provided for @liked.
  ///
  /// In en, this message translates to:
  /// **'Liked'**
  String get liked;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @replyingTo.
  ///
  /// In en, this message translates to:
  /// **'Replying to'**
  String get replyingTo;

  /// No description provided for @viewReplies.
  ///
  /// In en, this message translates to:
  /// **'View {count} replies'**
  String viewReplies(int count);

  /// No description provided for @useItinerary.
  ///
  /// In en, this message translates to:
  /// **'Use Itinerary'**
  String get useItinerary;

  /// No description provided for @confirmUseItinerary.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to use this itinerary?'**
  String get confirmUseItinerary;

  /// No description provided for @itineraryPublicizedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Itinerary publicized successfully!'**
  String get itineraryPublicizedSuccess;

  /// No description provided for @findVehicle.
  ///
  /// In en, this message translates to:
  /// **'Find Vehicle'**
  String get findVehicle;

  /// No description provided for @durationPackage.
  ///
  /// In en, this message translates to:
  /// **'Duration Package'**
  String get durationPackage;

  /// No description provided for @confirmRental.
  ///
  /// In en, this message translates to:
  /// **'Confirm Rental'**
  String get confirmRental;

  /// No description provided for @calculatedEndDate.
  ///
  /// In en, this message translates to:
  /// **'End Date (Calculated)'**
  String get calculatedEndDate;

  /// No description provided for @pleaseSelectPackage.
  ///
  /// In en, this message translates to:
  /// **'Please select a package'**
  String get pleaseSelectPackage;

  /// No description provided for @rentalBillCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Rental Bill created successfully!'**
  String get rentalBillCreatedSuccess;

  /// No description provided for @enterPickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter pickup location'**
  String get enterPickupLocation;

  /// No description provided for @selectStartDate.
  ///
  /// In en, this message translates to:
  /// **'Please select start date'**
  String get selectStartDate;

  /// No description provided for @selectEndDate.
  ///
  /// In en, this message translates to:
  /// **'Please select end date'**
  String get selectEndDate;

  /// No description provided for @endDateMustBeAfterStartDate.
  ///
  /// In en, this message translates to:
  /// **'End date must be after start date'**
  String get endDateMustBeAfterStartDate;

  /// No description provided for @rentalType.
  ///
  /// In en, this message translates to:
  /// **'Rental Type'**
  String get rentalType;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @actionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get actionSuccess;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get totalPrice;

  /// No description provided for @contract.
  ///
  /// In en, this message translates to:
  /// **'Contract'**
  String get contract;

  /// No description provided for @myRentalBills.
  ///
  /// In en, this message translates to:
  /// **'My Rental Bills'**
  String get myRentalBills;

  /// No description provided for @rentalBillDetail.
  ///
  /// In en, this message translates to:
  /// **'Rental Bill Detail'**
  String get rentalBillDetail;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @cancelReason.
  ///
  /// In en, this message translates to:
  /// **'Cancel Reason'**
  String get cancelReason;

  /// No description provided for @contactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInfo;

  /// No description provided for @vehicleList.
  ///
  /// In en, this message translates to:
  /// **'Vehicle List'**
  String get vehicleList;

  /// No description provided for @noRentalBills.
  ///
  /// In en, this message translates to:
  /// **'No rental bills found'**
  String get noRentalBills;

  /// No description provided for @document.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get document;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @unsavedChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Discard them?'**
  String get unsavedChangesMessage;

  /// No description provided for @noChangesToUpdate.
  ///
  /// In en, this message translates to:
  /// **'No changes to update'**
  String get noChangesToUpdate;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @idCard.
  ///
  /// In en, this message translates to:
  /// **'ID Card'**
  String get idCard;

  /// No description provided for @citizenFront.
  ///
  /// In en, this message translates to:
  /// **'Citizen Front'**
  String get citizenFront;

  /// No description provided for @citizenBack.
  ///
  /// In en, this message translates to:
  /// **'Citizen Back'**
  String get citizenBack;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @drive.
  ///
  /// In en, this message translates to:
  /// **'Drive'**
  String get drive;

  /// No description provided for @walk.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get walk;

  /// No description provided for @calculatingRoute.
  ///
  /// In en, this message translates to:
  /// **'Calculating route...'**
  String get calculatingRoute;

  /// No description provided for @updatingTime.
  ///
  /// In en, this message translates to:
  /// **'Updating time...'**
  String get updatingTime;

  /// No description provided for @updatingDistance.
  ///
  /// In en, this message translates to:
  /// **'Updating distance...'**
  String get updatingDistance;

  /// No description provided for @hoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours {minutes} minutes'**
  String hoursMinutes(int hours, int minutes);

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes'**
  String minutes(int minutes);

  /// No description provided for @kilometers.
  ///
  /// In en, this message translates to:
  /// **'{km} km'**
  String kilometers(String km);

  /// No description provided for @meters.
  ///
  /// In en, this message translates to:
  /// **'{m} m'**
  String meters(int m);

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @estimatedArrival.
  ///
  /// In en, this message translates to:
  /// **'Estimated Arrival'**
  String get estimatedArrival;

  /// No description provided for @checkInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Check-in successful!'**
  String get checkInSuccess;

  /// No description provided for @checkInFailed.
  ///
  /// In en, this message translates to:
  /// **'Check-in failed'**
  String get checkInFailed;

  /// No description provided for @checkInHere.
  ///
  /// In en, this message translates to:
  /// **'Check In Here'**
  String get checkInHere;

  /// No description provided for @gettingLocation.
  ///
  /// In en, this message translates to:
  /// **'Getting location...'**
  String get gettingLocation;

  /// No description provided for @stopStatusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get stopStatusUpcoming;

  /// No description provided for @stopStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get stopStatusInProgress;

  /// No description provided for @stopStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get stopStatusCompleted;

  /// No description provided for @stopStatusMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get stopStatusMissed;

  /// No description provided for @myItinerary.
  ///
  /// In en, this message translates to:
  /// **'My Itinerary'**
  String get myItinerary;

  /// No description provided for @memberFeatures.
  ///
  /// In en, this message translates to:
  /// **'Member Features'**
  String get memberFeatures;

  /// No description provided for @favouriteDestinations.
  ///
  /// In en, this message translates to:
  /// **'Favourite Destinations'**
  String get favouriteDestinations;

  /// No description provided for @travelHistory.
  ///
  /// In en, this message translates to:
  /// **'Travel History'**
  String get travelHistory;

  /// No description provided for @myWallet.
  ///
  /// In en, this message translates to:
  /// **'My Wallet'**
  String get myWallet;

  /// No description provided for @memberForDays.
  ///
  /// In en, this message translates to:
  /// **'Member for {days} days'**
  String memberForDays(int days);

  /// No description provided for @itemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String itemsCount(int count);

  /// No description provided for @mediaUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Media updated successfully'**
  String get mediaUpdatedSuccessfully;

  /// No description provided for @photosCount.
  ///
  /// In en, this message translates to:
  /// **'Photos ({count})'**
  String photosCount(int count);

  /// No description provided for @videosCount.
  ///
  /// In en, this message translates to:
  /// **'Videos ({count})'**
  String videosCount(int count);

  /// No description provided for @addPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add Photos'**
  String get addPhotos;

  /// No description provided for @addVideo.
  ///
  /// In en, this message translates to:
  /// **'Add Video'**
  String get addVideo;

  /// No description provided for @noPhotosYet.
  ///
  /// In en, this message translates to:
  /// **'No photos yet'**
  String get noPhotosYet;

  /// No description provided for @noVideosYet.
  ///
  /// In en, this message translates to:
  /// **'No videos yet'**
  String get noVideosYet;

  /// No description provided for @unknownDestination.
  ///
  /// In en, this message translates to:
  /// **'Unknown Destination'**
  String get unknownDestination;

  /// No description provided for @dayWithOrder.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String dayWithOrder(int day);

  /// No description provided for @dayOrder.
  ///
  /// In en, this message translates to:
  /// **'Day Order'**
  String get dayOrder;

  /// No description provided for @sequence.
  ///
  /// In en, this message translates to:
  /// **'Sequence'**
  String get sequence;

  /// No description provided for @editStop.
  ///
  /// In en, this message translates to:
  /// **'Edit Stop'**
  String get editStop;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @bronzeMember.
  ///
  /// In en, this message translates to:
  /// **'Bronze Member'**
  String get bronzeMember;

  /// No description provided for @silverMember.
  ///
  /// In en, this message translates to:
  /// **'Silver Member'**
  String get silverMember;

  /// No description provided for @goldMember.
  ///
  /// In en, this message translates to:
  /// **'Gold Member'**
  String get goldMember;

  /// No description provided for @platinumMember.
  ///
  /// In en, this message translates to:
  /// **'Platinum Member'**
  String get platinumMember;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'reviews'**
  String get reviews;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @totalTrips.
  ///
  /// In en, this message translates to:
  /// **'Total Trips'**
  String get totalTrips;

  /// No description provided for @upcomingTrips.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcomingTrips;

  /// No description provided for @completedTrips.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedTrips;

  /// No description provided for @tripList.
  ///
  /// In en, this message translates to:
  /// **'Trip List'**
  String get tripList;

  /// No description provided for @foodWheel.
  ///
  /// In en, this message translates to:
  /// **'Food Wheel'**
  String get foodWheel;

  /// No description provided for @createTrip.
  ///
  /// In en, this message translates to:
  /// **'Create Trip'**
  String get createTrip;

  /// No description provided for @createTripDesc.
  ///
  /// In en, this message translates to:
  /// **'Plan your next adventure'**
  String get createTripDesc;

  /// No description provided for @tripListDesc.
  ///
  /// In en, this message translates to:
  /// **'View your travel history'**
  String get tripListDesc;

  /// No description provided for @foodWheelDesc.
  ///
  /// In en, this message translates to:
  /// **'Spin to decide what to eat'**
  String get foodWheelDesc;

  /// No description provided for @documentation.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get documentation;

  /// No description provided for @vehicleAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Added Successfully!'**
  String get vehicleAddedSuccessfully;

  /// No description provided for @vehicleAddedSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your vehicle has been added successfully and is now available for rental.'**
  String get vehicleAddedSuccessMessage;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @failedToAddVehicle.
  ///
  /// In en, this message translates to:
  /// **'Failed to Add Vehicle'**
  String get failedToAddVehicle;

  /// No description provided for @exampleLicensePlate.
  ///
  /// In en, this message translates to:
  /// **'e.g. 51F-12345'**
  String get exampleLicensePlate;

  /// No description provided for @colorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Color: {color}'**
  String colorPrefix(String color);

  /// No description provided for @registrationPrefix.
  ///
  /// In en, this message translates to:
  /// **'Registration: {registration}'**
  String registrationPrefix(String registration);

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Registration Successful!'**
  String get registrationSuccessful;

  /// No description provided for @registrationSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your vehicle rental registration has been submitted successfully. We will review your information and contact you soon.'**
  String get registrationSuccessMessage;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration Failed'**
  String get registrationFailed;

  /// No description provided for @identityInformation.
  ///
  /// In en, this message translates to:
  /// **'Identity Information'**
  String get identityInformation;

  /// No description provided for @taxInformation.
  ///
  /// In en, this message translates to:
  /// **'Tax Information'**
  String get taxInformation;

  /// No description provided for @bankingInformation.
  ///
  /// In en, this message translates to:
  /// **'Banking Information'**
  String get bankingInformation;

  /// No description provided for @failedToLoadContract.
  ///
  /// In en, this message translates to:
  /// **'Failed to load contract'**
  String get failedToLoadContract;

  /// No description provided for @contractOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner: {name}'**
  String contractOwner(String name);

  /// No description provided for @emailPrefix.
  ///
  /// In en, this message translates to:
  /// **'Email: {email}'**
  String emailPrefix(String email);

  /// No description provided for @phonePrefix.
  ///
  /// In en, this message translates to:
  /// **'Phone: {phone}'**
  String phonePrefix(String phone);

  /// No description provided for @statusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get statusApproved;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get statusSuspended;

  /// No description provided for @pleaseFillAllRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get pleaseFillAllRequiredFields;

  /// No description provided for @vehicleRentalRegister.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Rental Registration'**
  String get vehicleRentalRegister;

  /// No description provided for @itineraryDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Itinerary Detail'**
  String get itineraryDetailTitle;

  /// No description provided for @itineraryInfo.
  ///
  /// In en, this message translates to:
  /// **'Itinerary Information'**
  String get itineraryInfo;

  /// No description provided for @itineraryName.
  ///
  /// In en, this message translates to:
  /// **'Itinerary Name'**
  String get itineraryName;

  /// No description provided for @itineraryCity.
  ///
  /// In en, this message translates to:
  /// **'Province/City'**
  String get itineraryCity;

  /// No description provided for @itineraryDays.
  ///
  /// In en, this message translates to:
  /// **'Duration (Days)'**
  String get itineraryDays;

  /// No description provided for @itineraryPlaces.
  ///
  /// In en, this message translates to:
  /// **'Number of Places'**
  String get itineraryPlaces;

  /// No description provided for @itineraryStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get itineraryStartDate;

  /// No description provided for @itineraryEndDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get itineraryEndDate;

  /// No description provided for @exploreProvince.
  ///
  /// In en, this message translates to:
  /// **'Explore {province}'**
  String exploreProvince(String province);

  /// No description provided for @noFavouriteDestinations.
  ///
  /// In en, this message translates to:
  /// **'No favourite destinations'**
  String get noFavouriteDestinations;

  /// No description provided for @addFavouriteDestinationsHint.
  ///
  /// In en, this message translates to:
  /// **'Add destinations to favourites to see them here'**
  String get addFavouriteDestinationsHint;

  /// No description provided for @favouriteDestinationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} favourite destinations'**
  String favouriteDestinationsCount(int count);

  /// No description provided for @searchDestinationsHint.
  ///
  /// In en, this message translates to:
  /// **'Search destinations...'**
  String get searchDestinationsHint;

  /// No description provided for @searchInFavourites.
  ///
  /// In en, this message translates to:
  /// **'Search in favourites'**
  String get searchInFavourites;

  /// No description provided for @enterDestinationName.
  ///
  /// In en, this message translates to:
  /// **'Enter destination name, province...'**
  String get enterDestinationName;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @foundResults.
  ///
  /// In en, this message translates to:
  /// **'Found {count} results'**
  String foundResults(int count);

  /// No description provided for @itineraryCreationTitle.
  ///
  /// In en, this message translates to:
  /// **'Itinerary {province}'**
  String itineraryCreationTitle(String province);

  /// No description provided for @arrangeItinerary.
  ///
  /// In en, this message translates to:
  /// **'Arrange Itinerary'**
  String get arrangeItinerary;

  /// No description provided for @placesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} places'**
  String placesCount(int count);

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String daysCount(int count);

  /// No description provided for @tripDuration.
  ///
  /// In en, this message translates to:
  /// **'Trip Duration'**
  String get tripDuration;

  /// No description provided for @totalDuration.
  ///
  /// In en, this message translates to:
  /// **'Total Duration'**
  String get totalDuration;

  /// No description provided for @arrangePlacesByDay.
  ///
  /// In en, this message translates to:
  /// **'Arrange places by day'**
  String get arrangePlacesByDay;

  /// No description provided for @arrangePlacesByDayDesc.
  ///
  /// In en, this message translates to:
  /// **'Select places for each day of the itinerary'**
  String get arrangePlacesByDayDesc;

  /// No description provided for @dayNumber.
  ///
  /// In en, this message translates to:
  /// **'Day {number}'**
  String dayNumber(int number);

  /// No description provided for @noDateSelected.
  ///
  /// In en, this message translates to:
  /// **'No date selected'**
  String get noDateSelected;

  /// No description provided for @noPlacesAdded.
  ///
  /// In en, this message translates to:
  /// **'No places added. Tap to add.'**
  String get noPlacesAdded;

  /// No description provided for @completeItinerary.
  ///
  /// In en, this message translates to:
  /// **'Complete Itinerary'**
  String get completeItinerary;

  /// No description provided for @createItinerarySuccess.
  ///
  /// In en, this message translates to:
  /// **'Itinerary Created!'**
  String get createItinerarySuccess;

  /// No description provided for @createItinerarySuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your itinerary has been created. You can view and edit it later.'**
  String get createItinerarySuccessMessage;

  /// No description provided for @addLocation.
  ///
  /// In en, this message translates to:
  /// **'Add Location'**
  String get addLocation;

  /// No description provided for @placesNotAdded.
  ///
  /// In en, this message translates to:
  /// **'{count} places not added'**
  String placesNotAdded(int count);

  /// No description provided for @allLocationsAdded.
  ///
  /// In en, this message translates to:
  /// **'All locations have been added to the itinerary'**
  String get allLocationsAdded;

  /// No description provided for @failedToLoadDestination.
  ///
  /// In en, this message translates to:
  /// **'Failed to load destination'**
  String get failedToLoadDestination;

  /// No description provided for @unknownLocation.
  ///
  /// In en, this message translates to:
  /// **'Unknown location'**
  String get unknownLocation;

  /// No description provided for @reviewsCount.
  ///
  /// In en, this message translates to:
  /// **'({count} reviews)'**
  String reviewsCount(int count);

  /// No description provided for @stopDetail.
  ///
  /// In en, this message translates to:
  /// **'Stop Detail'**
  String get stopDetail;

  /// No description provided for @tabAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get tabAbout;

  /// No description provided for @tabReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get tabReviews;

  /// No description provided for @tabPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get tabPhotos;

  /// No description provided for @itinerarySchedule.
  ///
  /// In en, this message translates to:
  /// **'Itinerary Schedule'**
  String get itinerarySchedule;

  /// No description provided for @emptyItinerary.
  ///
  /// In en, this message translates to:
  /// **'No itinerary found'**
  String get emptyItinerary;

  /// No description provided for @addStop.
  ///
  /// In en, this message translates to:
  /// **'Add Stop'**
  String get addStop;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @renterInfo.
  ///
  /// In en, this message translates to:
  /// **'Renter Info'**
  String get renterInfo;

  /// No description provided for @rentalRequestDetail.
  ///
  /// In en, this message translates to:
  /// **'Rental Request Detail'**
  String get rentalRequestDetail;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalRevenue;

  /// No description provided for @travelPoints.
  ///
  /// In en, this message translates to:
  /// **'Travel Points'**
  String get travelPoints;

  /// No description provided for @travelTrips.
  ///
  /// In en, this message translates to:
  /// **'Travel Trips'**
  String get travelTrips;

  /// No description provided for @routeStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get routeStatusInProgress;

  /// No description provided for @enterPoints.
  ///
  /// In en, this message translates to:
  /// **'Enter points'**
  String get enterPoints;

  /// No description provided for @addNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Add notes here...'**
  String get addNotesHint;

  /// No description provided for @selectStartEndTimeError.
  ///
  /// In en, this message translates to:
  /// **'Please select both start and end time'**
  String get selectStartEndTimeError;

  /// No description provided for @editItinerary.
  ///
  /// In en, this message translates to:
  /// **'Edit Itinerary'**
  String get editItinerary;

  /// No description provided for @itineraryUpdated.
  ///
  /// In en, this message translates to:
  /// **'Itinerary updated'**
  String get itineraryUpdated;

  /// No description provided for @selectDestination.
  ///
  /// In en, this message translates to:
  /// **'Select Destination'**
  String get selectDestination;

  /// No description provided for @noDestinationsFound.
  ///
  /// In en, this message translates to:
  /// **'No destinations found'**
  String get noDestinationsFound;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @voucher10Percent.
  ///
  /// In en, this message translates to:
  /// **'Voucher 10%'**
  String get voucher10Percent;

  /// No description provided for @voucherFreeShipping.
  ///
  /// In en, this message translates to:
  /// **'Voucher Free Shipping'**
  String get voucherFreeShipping;

  /// No description provided for @voucher50K.
  ///
  /// In en, this message translates to:
  /// **'Voucher 50K'**
  String get voucher50K;

  /// No description provided for @voucher20Percent.
  ///
  /// In en, this message translates to:
  /// **'Voucher 20%'**
  String get voucher20Percent;

  /// No description provided for @voucherBuy1Get1.
  ///
  /// In en, this message translates to:
  /// **'Voucher Buy 1 Get 1'**
  String get voucherBuy1Get1;

  /// No description provided for @specialOfferForYou.
  ///
  /// In en, this message translates to:
  /// **'Special offer for you'**
  String get specialOfferForYou;

  /// No description provided for @useNowToGetOffer.
  ///
  /// In en, this message translates to:
  /// **'Use now to get offer'**
  String get useNowToGetOffer;

  /// No description provided for @hotel5Star.
  ///
  /// In en, this message translates to:
  /// **'5 Star'**
  String get hotel5Star;

  /// No description provided for @hotelResort.
  ///
  /// In en, this message translates to:
  /// **'Resort'**
  String get hotelResort;

  /// No description provided for @hotelSeaside.
  ///
  /// In en, this message translates to:
  /// **'Seaside'**
  String get hotelSeaside;

  /// No description provided for @hotelLodge.
  ///
  /// In en, this message translates to:
  /// **'Lodge'**
  String get hotelLodge;

  /// No description provided for @restaurantFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get restaurantFrench;

  /// No description provided for @restaurantJapanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get restaurantJapanese;

  /// No description provided for @restaurantSeafood.
  ///
  /// In en, this message translates to:
  /// **'Seafood'**
  String get restaurantSeafood;

  /// No description provided for @restaurantBBQ.
  ///
  /// In en, this message translates to:
  /// **'BBQ'**
  String get restaurantBBQ;

  /// No description provided for @noSchedule.
  ///
  /// In en, this message translates to:
  /// **'No schedule for this trip'**
  String get noSchedule;

  /// No description provided for @noStop.
  ///
  /// In en, this message translates to:
  /// **'No stops for this trip'**
  String get noStop;

  /// No description provided for @statusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get statusUpcoming;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusOngoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get statusOngoing;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get statusDraft;

  /// No description provided for @statusMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get statusMissed;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @confirmDeleteContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this itinerary?'**
  String get confirmDeleteContent;

  /// No description provided for @deleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Itinerary deleted successfully'**
  String get deleteSuccess;

  /// No description provided for @foodWheelTitle.
  ///
  /// In en, this message translates to:
  /// **'What to eat today?'**
  String get foodWheelTitle;

  /// No description provided for @spinWheel.
  ///
  /// In en, this message translates to:
  /// **'Spin Wheel'**
  String get spinWheel;

  /// No description provided for @spin.
  ///
  /// In en, this message translates to:
  /// **'Spin'**
  String get spin;

  /// No description provided for @foodWheelResultTitle.
  ///
  /// In en, this message translates to:
  /// **'🎉 Today\'s meal:'**
  String get foodWheelResultTitle;

  /// No description provided for @awesome.
  ///
  /// In en, this message translates to:
  /// **'Awesome!'**
  String get awesome;

  /// No description provided for @spinAgain.
  ///
  /// In en, this message translates to:
  /// **'Spin Again'**
  String get spinAgain;

  /// No description provided for @yourVehicles.
  ///
  /// In en, this message translates to:
  /// **'Your Vehicles'**
  String get yourVehicles;

  /// No description provided for @readyToAddVehicles.
  ///
  /// In en, this message translates to:
  /// **'Ready to Add Vehicles'**
  String get readyToAddVehicles;

  /// No description provided for @contractApprovedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your contract has been approved! Start adding your vehicles to earn money from rentals.'**
  String get contractApprovedMessage;

  /// No description provided for @contractApproved.
  ///
  /// In en, this message translates to:
  /// **'Contract Approved!'**
  String get contractApproved;

  /// No description provided for @whatYouCanDoNow.
  ///
  /// In en, this message translates to:
  /// **'What you can do now:'**
  String get whatYouCanDoNow;

  /// No description provided for @benefitAddUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Add unlimited vehicles to your account'**
  String get benefitAddUnlimited;

  /// No description provided for @benefitUploadPhotos.
  ///
  /// In en, this message translates to:
  /// **'Upload clear photos and documentation'**
  String get benefitUploadPhotos;

  /// No description provided for @benefitSetPrices.
  ///
  /// In en, this message translates to:
  /// **'Set your own rental prices'**
  String get benefitSetPrices;

  /// No description provided for @benefitVisibility.
  ///
  /// In en, this message translates to:
  /// **'Your vehicles will be visible to customers'**
  String get benefitVisibility;

  /// No description provided for @benefitStartEarning.
  ///
  /// In en, this message translates to:
  /// **'Start earning from the first rental'**
  String get benefitStartEarning;

  /// No description provided for @noRentalContractYet.
  ///
  /// In en, this message translates to:
  /// **'No Rental Contract Yet'**
  String get noRentalContractYet;

  /// No description provided for @registerContractBeforeListing.
  ///
  /// In en, this message translates to:
  /// **'Register a rental contract before listing your vehicles for rent.'**
  String get registerContractBeforeListing;

  /// No description provided for @registerRentalContract.
  ///
  /// In en, this message translates to:
  /// **'Register Rental Contract'**
  String get registerRentalContract;

  /// No description provided for @whyRegisterContract.
  ///
  /// In en, this message translates to:
  /// **'Why register a rental contract first?'**
  String get whyRegisterContract;

  /// No description provided for @benefitReuseInfo.
  ///
  /// In en, this message translates to:
  /// **'Provide owner information once and reuse it later'**
  String get benefitReuseInfo;

  /// No description provided for @benefitVerify.
  ///
  /// In en, this message translates to:
  /// **'Enable Traveline to verify payouts and legal docs'**
  String get benefitVerify;

  /// No description provided for @benefitListUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlock the ability to list unlimited vehicles'**
  String get benefitListUnlimited;

  /// No description provided for @benefitSupport.
  ///
  /// In en, this message translates to:
  /// **'Get dedicated support for future rentals'**
  String get benefitSupport;

  /// No description provided for @cannotLoadVehicleInfo.
  ///
  /// In en, this message translates to:
  /// **'Cannot load vehicle information'**
  String get cannotLoadVehicleInfo;

  /// No description provided for @createdOn.
  ///
  /// In en, this message translates to:
  /// **'Created on {date}'**
  String createdOn(String date);

  /// No description provided for @contractId.
  ///
  /// In en, this message translates to:
  /// **'Contract #{id}'**
  String contractId(String id);

  /// No description provided for @idWithPrefix.
  ///
  /// In en, this message translates to:
  /// **'ID: {id}'**
  String idWithPrefix(String id);

  /// No description provided for @connectionLostTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection Lost'**
  String get connectionLostTitle;

  /// No description provided for @connectionLostContent.
  ///
  /// In en, this message translates to:
  /// **'Network connection interrupted. Please check and try again.'**
  String get connectionLostContent;

  /// No description provided for @serverNoResponseTitle.
  ///
  /// In en, this message translates to:
  /// **'Server Not Responding'**
  String get serverNoResponseTitle;

  /// No description provided for @serverNoResponseContent.
  ///
  /// In en, this message translates to:
  /// **'Server response timed out. Please try again later.'**
  String get serverNoResponseContent;

  /// No description provided for @discountPointsLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount Points'**
  String get discountPointsLabel;

  /// No description provided for @payWithPoints.
  ///
  /// In en, this message translates to:
  /// **'Pay with points'**
  String get payWithPoints;

  /// No description provided for @statusAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get statusAvailable;

  /// No description provided for @statusSoldOut.
  ///
  /// In en, this message translates to:
  /// **'Sold Out'**
  String get statusSoldOut;

  /// No description provided for @statusSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get statusSelected;

  /// No description provided for @statusEmpty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get statusEmpty;

  /// No description provided for @selectDeparture.
  ///
  /// In en, this message translates to:
  /// **'Select departure point'**
  String get selectDeparture;

  /// No description provided for @busTicketTitle.
  ///
  /// In en, this message translates to:
  /// **'ELECTRONIC BUS TICKET'**
  String get busTicketTitle;

  /// No description provided for @busCompany.
  ///
  /// In en, this message translates to:
  /// **'Bus Company'**
  String get busCompany;

  /// No description provided for @departureTime.
  ///
  /// In en, this message translates to:
  /// **'Departure Time'**
  String get departureTime;

  /// No description provided for @arrivalTime.
  ///
  /// In en, this message translates to:
  /// **'Arrival Time'**
  String get arrivalTime;

  /// No description provided for @seatNumber.
  ///
  /// In en, this message translates to:
  /// **'Seat Number'**
  String get seatNumber;

  /// No description provided for @passengerInfo.
  ///
  /// In en, this message translates to:
  /// **'Passenger Info'**
  String get passengerInfo;

  /// No description provided for @driver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get driver;

  /// No description provided for @selectedSeats.
  ///
  /// In en, this message translates to:
  /// **'Selected Seats'**
  String get selectedSeats;

  /// No description provided for @roomQuantity.
  ///
  /// In en, this message translates to:
  /// **'Room Quantity'**
  String get roomQuantity;

  /// No description provided for @roomNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Room not available'**
  String get roomNotAvailable;

  /// No description provided for @selectFoodType.
  ///
  /// In en, this message translates to:
  /// **'Select Food Type'**
  String get selectFoodType;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all information'**
  String get fillAllFields;

  /// No description provided for @pleaseSelectReturnDate.
  ///
  /// In en, this message translates to:
  /// **'Please select return date'**
  String get pleaseSelectReturnDate;

  /// No description provided for @invalidReturnDate.
  ///
  /// In en, this message translates to:
  /// **'Return date must be after departure date'**
  String get invalidReturnDate;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @videos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get videos;

  /// No description provided for @ticketNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Important Note'**
  String get ticketNoteTitle;

  /// No description provided for @ticketNote1.
  ///
  /// In en, this message translates to:
  /// **'Show QR code to driver for confirmation'**
  String get ticketNote1;

  /// No description provided for @ticketNote2.
  ///
  /// In en, this message translates to:
  /// **'Arrive 15 minutes before departure'**
  String get ticketNote2;

  /// No description provided for @ticketNote3.
  ///
  /// In en, this message translates to:
  /// **'Ticket is valid for selected date and time only'**
  String get ticketNote3;

  /// No description provided for @bookingCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Booking Code'**
  String get bookingCodeLabel;

  /// No description provided for @departure.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get departure;

  /// No description provided for @arrival.
  ///
  /// In en, this message translates to:
  /// **'Arrival'**
  String get arrival;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @ticketNote4.
  ///
  /// In en, this message translates to:
  /// **'Bring ID/CCCD when boarding'**
  String get ticketNote4;

  /// No description provided for @selectedRoom.
  ///
  /// In en, this message translates to:
  /// **'Selected Room'**
  String get selectedRoom;

  /// No description provided for @people.
  ///
  /// In en, this message translates to:
  /// **'people'**
  String get people;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @exploreItineraries.
  ///
  /// In en, this message translates to:
  /// **'Explore Itineraries'**
  String get exploreItineraries;

  /// No description provided for @cameraPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera permission denied'**
  String get cameraPermissionDenied;

  /// No description provided for @faceInstruction.
  ///
  /// In en, this message translates to:
  /// **'Place your face in the frame'**
  String get faceInstruction;

  /// No description provided for @cameraError.
  ///
  /// In en, this message translates to:
  /// **'Error initializing camera: {error}'**
  String cameraError(String error);

  /// No description provided for @noCamerasAvailable.
  ///
  /// In en, this message translates to:
  /// **'No cameras available'**
  String get noCamerasAvailable;

  /// No description provided for @cameraNotInitialized.
  ///
  /// In en, this message translates to:
  /// **'Camera not initialized'**
  String get cameraNotInitialized;

  /// No description provided for @takePictureError.
  ///
  /// In en, this message translates to:
  /// **'Error taking picture: {error}'**
  String takePictureError(String error);

  /// No description provided for @unknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get unknownUser;

  /// No description provided for @destinationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Destinations'**
  String destinationsCount(String count);

  /// No description provided for @noVehicles.
  ///
  /// In en, this message translates to:
  /// **'No Vehicles'**
  String get noVehicles;

  /// No description provided for @foodTypeAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get foodTypeAll;

  /// No description provided for @foodTypeVietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get foodTypeVietnamese;

  /// No description provided for @foodTypeAsian.
  ///
  /// In en, this message translates to:
  /// **'Asian'**
  String get foodTypeAsian;

  /// No description provided for @foodTypeEuropean.
  ///
  /// In en, this message translates to:
  /// **'European'**
  String get foodTypeEuropean;

  /// No description provided for @foodTypeSeafood.
  ///
  /// In en, this message translates to:
  /// **'Seafood'**
  String get foodTypeSeafood;

  /// No description provided for @foodTypeHotpot.
  ///
  /// In en, this message translates to:
  /// **'Hotpot'**
  String get foodTypeHotpot;

  /// No description provided for @foodTypeBBQ.
  ///
  /// In en, this message translates to:
  /// **'BBQ'**
  String get foodTypeBBQ;

  /// No description provided for @foodTypeVegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get foodTypeVegetarian;

  /// No description provided for @foodTypeKorean.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get foodTypeKorean;

  /// No description provided for @foodTypeJapanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get foodTypeJapanese;

  /// No description provided for @foodTypeFastFood.
  ///
  /// In en, this message translates to:
  /// **'Fast Food'**
  String get foodTypeFastFood;

  /// No description provided for @contractDurationPolicy.
  ///
  /// In en, this message translates to:
  /// **'The contract shall remain in effect until either party terminates the cooperation.'**
  String get contractDurationPolicy;

  /// No description provided for @verifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get verifyEmail;

  /// No description provided for @enterCodeSentToEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to your email'**
  String get enterCodeSentToEmail;

  /// No description provided for @codeExpiresIn.
  ///
  /// In en, this message translates to:
  /// **'Code expires in: {time}'**
  String codeExpiresIn(String time);

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @enterValid6DigitCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 6-digit code'**
  String get enterValid6DigitCode;

  /// No description provided for @requestCodeFirst.
  ///
  /// In en, this message translates to:
  /// **'Please request a code first'**
  String get requestCodeFirst;

  /// No description provided for @couldNotFindUserEmail.
  ///
  /// In en, this message translates to:
  /// **'Could not find user email'**
  String get couldNotFindUserEmail;

  /// No description provided for @codeSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Code sent successfully'**
  String get codeSentSuccess;

  /// No description provided for @emailVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Email verified successfully'**
  String get emailVerifiedSuccess;

  /// No description provided for @verifyPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Phone Number'**
  String get verifyPhoneTitle;

  /// No description provided for @verifyPhoneDescription.
  ///
  /// In en, this message translates to:
  /// **'We have sent a verification code to {phone}'**
  String verifyPhoneDescription(String phone);

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP Code'**
  String get enterOtp;

  /// No description provided for @phoneVerificationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Phone verification successful'**
  String get phoneVerificationSuccess;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP code'**
  String get invalidOtp;

  /// No description provided for @sendingCode.
  ///
  /// In en, this message translates to:
  /// **'Sending verification code...'**
  String get sendingCode;

  /// No description provided for @verifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get verifying;

  /// No description provided for @recaptchaRequired.
  ///
  /// In en, this message translates to:
  /// **'Please complete the CAPTCHA verification'**
  String get recaptchaRequired;

  /// No description provided for @enterItineraryName.
  ///
  /// In en, this message translates to:
  /// **'Enter itinerary name'**
  String get enterItineraryName;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @dateRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select start and end dates'**
  String get dateRequired;

  /// No description provided for @whatFascinatesYou.
  ///
  /// In en, this message translates to:
  /// **'What fascinates you?'**
  String get whatFascinatesYou;

  /// No description provided for @interestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'To give you a personalized experience, let us know your interests.'**
  String get interestSubtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @adventure.
  ///
  /// In en, this message translates to:
  /// **'Adventure'**
  String get adventure;

  /// No description provided for @cultureHistory.
  ///
  /// In en, this message translates to:
  /// **'Culture & History'**
  String get cultureHistory;

  /// No description provided for @nature.
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get nature;

  /// No description provided for @sports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get sports;

  /// No description provided for @relaxation.
  ///
  /// In en, this message translates to:
  /// **'Relaxation'**
  String get relaxation;

  /// No description provided for @festival.
  ///
  /// In en, this message translates to:
  /// **'Festival'**
  String get festival;

  /// No description provided for @beachIslands.
  ///
  /// In en, this message translates to:
  /// **'Beach & Islands'**
  String get beachIslands;

  /// No description provided for @photography.
  ///
  /// In en, this message translates to:
  /// **'Photography'**
  String get photography;

  /// No description provided for @entertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get entertainment;

  /// No description provided for @mountainForest.
  ///
  /// In en, this message translates to:
  /// **'Mountain & Forest'**
  String get mountainForest;

  /// No description provided for @foodsDrinks.
  ///
  /// In en, this message translates to:
  /// **'Foods & Drinks'**
  String get foodsDrinks;

  /// No description provided for @feedbackContentRejected.
  ///
  /// In en, this message translates to:
  /// **'Content rejected: {reason}'**
  String feedbackContentRejected(String reason);

  /// No description provided for @feedbackContentUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Your comment is under review but has been posted.'**
  String get feedbackContentUnderReview;

  /// No description provided for @toxicity_high.
  ///
  /// In en, this message translates to:
  /// **'High toxicity detected'**
  String get toxicity_high;

  /// No description provided for @spam_high.
  ///
  /// In en, this message translates to:
  /// **'Spam detected'**
  String get spam_high;

  /// No description provided for @rule_reject.
  ///
  /// In en, this message translates to:
  /// **'Violated community rules'**
  String get rule_reject;

  /// No description provided for @toxicity_manual.
  ///
  /// In en, this message translates to:
  /// **'Potential toxicity'**
  String get toxicity_manual;

  /// No description provided for @spam_manual.
  ///
  /// In en, this message translates to:
  /// **'Potential spam'**
  String get spam_manual;

  /// No description provided for @rule_manual.
  ///
  /// In en, this message translates to:
  /// **'Potential rule violation'**
  String get rule_manual;

  /// No description provided for @too_short.
  ///
  /// In en, this message translates to:
  /// **'Comments must be at least 5 characters'**
  String get too_short;

  /// No description provided for @profanity.
  ///
  /// In en, this message translates to:
  /// **'Profanity detected'**
  String get profanity;

  /// No description provided for @sexual_content.
  ///
  /// In en, this message translates to:
  /// **'Sexual content detected'**
  String get sexual_content;

  /// No description provided for @harassment.
  ///
  /// In en, this message translates to:
  /// **'Harassment detected'**
  String get harassment;

  /// No description provided for @hate_speech.
  ///
  /// In en, this message translates to:
  /// **'Hate speech detected'**
  String get hate_speech;

  /// No description provided for @splashTitle.
  ///
  /// In en, this message translates to:
  /// **'Traveline'**
  String get splashTitle;

  /// No description provided for @splashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tour Guide App'**
  String get splashSubtitle;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Discover the world\nYour journey, your style'**
  String get splashTagline;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Starting up...'**
  String get splashLoading;

  /// No description provided for @addLottieFile.
  ///
  /// In en, this message translates to:
  /// **'Add Lottie file\nto assets/lottie/'**
  String get addLottieFile;

  /// No description provided for @vehiclePhoto.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Photo'**
  String get vehiclePhoto;

  /// No description provided for @availability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get availability;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @enableRental.
  ///
  /// In en, this message translates to:
  /// **'Enable Rental'**
  String get enableRental;

  /// No description provided for @disableRental.
  ///
  /// In en, this message translates to:
  /// **'Disable Rental'**
  String get disableRental;

  /// No description provided for @updateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Update successful'**
  String get updateSuccess;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @suggest.
  ///
  /// In en, this message translates to:
  /// **'Suggest'**
  String get suggest;

  /// No description provided for @itineraryPreview.
  ///
  /// In en, this message translates to:
  /// **'Itinerary Preview'**
  String get itineraryPreview;

  /// No description provided for @suggestItinerary.
  ///
  /// In en, this message translates to:
  /// **'Suggest Itinerary'**
  String get suggestItinerary;

  /// No description provided for @famousEateries.
  ///
  /// In en, this message translates to:
  /// **'Famous Eateries'**
  String get famousEateries;

  /// No description provided for @noEateriesFound.
  ///
  /// In en, this message translates to:
  /// **'No eateries found'**
  String get noEateriesFound;

  /// No description provided for @eateryDetail.
  ///
  /// In en, this message translates to:
  /// **'Eatery Detail'**
  String get eateryDetail;

  /// No description provided for @detectingLocation.
  ///
  /// In en, this message translates to:
  /// **'Detecting your location...'**
  String get detectingLocation;

  /// No description provided for @eateryWheelTitle.
  ///
  /// In en, this message translates to:
  /// **'What to Eat?'**
  String get eateryWheelTitle;

  /// No description provided for @eateryWheelResultTitle.
  ///
  /// In en, this message translates to:
  /// **'You should try:'**
  String get eateryWheelResultTitle;

  /// No description provided for @selectLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocationTitle;

  /// No description provided for @aboutTab.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTab;

  /// No description provided for @reviewsTab.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewsTab;

  /// No description provided for @photosTab.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photosTab;

  /// No description provided for @videosTab.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get videosTab;

  /// No description provided for @floor1.
  ///
  /// In en, this message translates to:
  /// **'Floor 1'**
  String get floor1;

  /// No description provided for @floor2.
  ///
  /// In en, this message translates to:
  /// **'Floor 2'**
  String get floor2;

  /// No description provided for @nearWindow.
  ///
  /// In en, this message translates to:
  /// **'Near Window'**
  String get nearWindow;

  /// No description provided for @middleOfRoom.
  ///
  /// In en, this message translates to:
  /// **'Middle of Room'**
  String get middleOfRoom;

  /// No description provided for @vip.
  ///
  /// In en, this message translates to:
  /// **'VIP'**
  String get vip;

  /// No description provided for @cornerOfRoom.
  ///
  /// In en, this message translates to:
  /// **'Corner of Room'**
  String get cornerOfRoom;

  /// No description provided for @privateRoom.
  ///
  /// In en, this message translates to:
  /// **'Private Room'**
  String get privateRoom;

  /// No description provided for @balcony.
  ///
  /// In en, this message translates to:
  /// **'Balcony'**
  String get balcony;

  /// No description provided for @vietnameseFood.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese Food'**
  String get vietnameseFood;

  /// No description provided for @thaiFood.
  ///
  /// In en, this message translates to:
  /// **'Thai Food'**
  String get thaiFood;

  /// No description provided for @japaneseFood.
  ///
  /// In en, this message translates to:
  /// **'Japanese Food'**
  String get japaneseFood;

  /// No description provided for @district1.
  ///
  /// In en, this message translates to:
  /// **'District 1'**
  String get district1;

  /// No description provided for @district2.
  ///
  /// In en, this message translates to:
  /// **'District 2'**
  String get district2;

  /// No description provided for @district3.
  ///
  /// In en, this message translates to:
  /// **'District 3'**
  String get district3;

  /// No description provided for @district4.
  ///
  /// In en, this message translates to:
  /// **'District 4'**
  String get district4;

  /// No description provided for @district5.
  ///
  /// In en, this message translates to:
  /// **'District 5'**
  String get district5;

  /// No description provided for @district7.
  ///
  /// In en, this message translates to:
  /// **'District 7'**
  String get district7;

  /// No description provided for @district10.
  ///
  /// In en, this message translates to:
  /// **'District 10'**
  String get district10;

  /// No description provided for @thuDuc.
  ///
  /// In en, this message translates to:
  /// **'Thu Duc City'**
  String get thuDuc;

  /// No description provided for @binhThanh.
  ///
  /// In en, this message translates to:
  /// **'Binh Thanh District'**
  String get binhThanh;

  /// No description provided for @phuNhuan.
  ///
  /// In en, this message translates to:
  /// **'Phu Nhuan District'**
  String get phuNhuan;

  /// No description provided for @tanBinh.
  ///
  /// In en, this message translates to:
  /// **'Tan Binh District'**
  String get tanBinh;

  /// No description provided for @goVap.
  ///
  /// In en, this message translates to:
  /// **'Go Vap District'**
  String get goVap;

  /// No description provided for @hcmCity.
  ///
  /// In en, this message translates to:
  /// **'Ho Chi Minh City'**
  String get hcmCity;

  /// No description provided for @viewDetail.
  ///
  /// In en, this message translates to:
  /// **'View Detail'**
  String get viewDetail;

  /// No description provided for @totalAmountRoundTrip.
  ///
  /// In en, this message translates to:
  /// **'Total Amount (2 trips)'**
  String get totalAmountRoundTrip;

  /// No description provided for @roundTrip.
  ///
  /// In en, this message translates to:
  /// **'Round Trip'**
  String get roundTrip;

  /// No description provided for @oneWay.
  ///
  /// In en, this message translates to:
  /// **'One Way'**
  String get oneWay;

  /// No description provided for @passengers.
  ///
  /// In en, this message translates to:
  /// **'passengers'**
  String get passengers;

  /// No description provided for @noBusFound.
  ///
  /// In en, this message translates to:
  /// **'No bus found'**
  String get noBusFound;

  /// No description provided for @tryAgainWithDifferentFilter.
  ///
  /// In en, this message translates to:
  /// **'Please try again with different filters'**
  String get tryAgainWithDifferentFilter;

  /// No description provided for @selectSeat.
  ///
  /// In en, this message translates to:
  /// **'Select Seat'**
  String get selectSeat;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @pickUpPoint.
  ///
  /// In en, this message translates to:
  /// **'Pick up point'**
  String get pickUpPoint;

  /// No description provided for @dropOffPoint.
  ///
  /// In en, this message translates to:
  /// **'Drop off point'**
  String get dropOffPoint;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @cancelTicket.
  ///
  /// In en, this message translates to:
  /// **'Cancel Ticket'**
  String get cancelTicket;

  /// No description provided for @changeTicket.
  ///
  /// In en, this message translates to:
  /// **'Change Ticket'**
  String get changeTicket;

  /// No description provided for @luggage.
  ///
  /// In en, this message translates to:
  /// **'Luggage'**
  String get luggage;

  /// No description provided for @freeBefore24h.
  ///
  /// In en, this message translates to:
  /// **'Free before 24h'**
  String get freeBefore24h;

  /// No description provided for @fee20k.
  ///
  /// In en, this message translates to:
  /// **'Fee 20.000đ'**
  String get fee20k;

  /// No description provided for @max20kg.
  ///
  /// In en, this message translates to:
  /// **'Max 20kg'**
  String get max20kg;

  /// No description provided for @wifi.
  ///
  /// In en, this message translates to:
  /// **'WiFi'**
  String get wifi;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @tv.
  ///
  /// In en, this message translates to:
  /// **'TV'**
  String get tv;

  /// No description provided for @coldTowel.
  ///
  /// In en, this message translates to:
  /// **'Cold Towel'**
  String get coldTowel;

  /// No description provided for @massage.
  ///
  /// In en, this message translates to:
  /// **'Massage'**
  String get massage;

  /// No description provided for @blanket.
  ///
  /// In en, this message translates to:
  /// **'Blanket'**
  String get blanket;

  /// No description provided for @priceDetails.
  ///
  /// In en, this message translates to:
  /// **'Price Details'**
  String get priceDetails;

  /// No description provided for @selectBank.
  ///
  /// In en, this message translates to:
  /// **'Select Bank'**
  String get selectBank;

  /// No description provided for @ticketPrice.
  ///
  /// In en, this message translates to:
  /// **'Ticket Price'**
  String get ticketPrice;

  /// No description provided for @serviceFee.
  ///
  /// In en, this message translates to:
  /// **'Service Fee'**
  String get serviceFee;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @continentalHotel.
  ///
  /// In en, this message translates to:
  /// **'Hotel Continental'**
  String get continentalHotel;

  /// No description provided for @rexHotel.
  ///
  /// In en, this message translates to:
  /// **'Rex Hotel'**
  String get rexHotel;

  /// No description provided for @newWorldSaigon.
  ///
  /// In en, this message translates to:
  /// **'New World Saigon'**
  String get newWorldSaigon;

  /// No description provided for @fiveStarHotel.
  ///
  /// In en, this message translates to:
  /// **'5 Star Hotel'**
  String get fiveStarHotel;

  /// No description provided for @fourStarHotel.
  ///
  /// In en, this message translates to:
  /// **'4 Star Hotel'**
  String get fourStarHotel;

  /// No description provided for @district1Hcm.
  ///
  /// In en, this message translates to:
  /// **'District 1, HCMC'**
  String get district1Hcm;

  /// No description provided for @roomsLower.
  ///
  /// In en, this message translates to:
  /// **'rooms'**
  String get roomsLower;

  /// No description provided for @roomSuperior.
  ///
  /// In en, this message translates to:
  /// **'Superior Room'**
  String get roomSuperior;

  /// No description provided for @roomDeluxe.
  ///
  /// In en, this message translates to:
  /// **'Deluxe Room'**
  String get roomDeluxe;

  /// No description provided for @roomSuite.
  ///
  /// In en, this message translates to:
  /// **'Suite Room'**
  String get roomSuite;

  /// No description provided for @roomFamily.
  ///
  /// In en, this message translates to:
  /// **'Family Room'**
  String get roomFamily;

  /// No description provided for @saigonRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Saigon Restaurant'**
  String get saigonRestaurant;

  /// No description provided for @thaiHotpot.
  ///
  /// In en, this message translates to:
  /// **'Thai Hotpot Tomyummmmmm'**
  String get thaiHotpot;

  /// No description provided for @sushiWorld.
  ///
  /// In en, this message translates to:
  /// **'Sushi World'**
  String get sushiWorld;

  /// No description provided for @ownerInfo.
  ///
  /// In en, this message translates to:
  /// **'Owner Info'**
  String get ownerInfo;

  /// No description provided for @actionFailed.
  ///
  /// In en, this message translates to:
  /// **'Action failed'**
  String get actionFailed;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get paymentFailed;

  /// No description provided for @paymentGatewayError.
  ///
  /// In en, this message translates to:
  /// **'Could not launch payment gateway'**
  String get paymentGatewayError;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet.'**
  String get noNotificationsYet;

  /// No description provided for @markAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get markAsRead;

  /// No description provided for @notificationList.
  ///
  /// In en, this message translates to:
  /// **'Notification List'**
  String get notificationList;

  /// No description provided for @noVouchersAvailable.
  ///
  /// In en, this message translates to:
  /// **'No vouchers available'**
  String get noVouchersAvailable;

  /// No description provided for @getDirections.
  ///
  /// In en, this message translates to:
  /// **'Get Directions'**
  String get getDirections;

  /// No description provided for @vehiclePhotoInstruction.
  ///
  /// In en, this message translates to:
  /// **'Please take a photo of the vehicle'**
  String get vehiclePhotoInstruction;

  /// No description provided for @verifyCitizenId.
  ///
  /// In en, this message translates to:
  /// **'Verify Citizen ID'**
  String get verifyCitizenId;

  /// No description provided for @selfiePhoto.
  ///
  /// In en, this message translates to:
  /// **'Selfie Photo'**
  String get selfiePhoto;

  /// No description provided for @citizenIdInstruction.
  ///
  /// In en, this message translates to:
  /// **'Place your Citizen ID within the frame'**
  String get citizenIdInstruction;

  /// No description provided for @verifySuccess.
  ///
  /// In en, this message translates to:
  /// **'Verification submitted successfully'**
  String get verifySuccess;

  /// No description provided for @retake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retake;

  /// No description provided for @captureCitizenId.
  ///
  /// In en, this message translates to:
  /// **'Capture Citizen ID'**
  String get captureCitizenId;

  /// No description provided for @capturePortrait.
  ///
  /// In en, this message translates to:
  /// **'Capture Portrait'**
  String get capturePortrait;

  /// No description provided for @shippingFee.
  ///
  /// In en, this message translates to:
  /// **'Shipping Fee'**
  String get shippingFee;

  /// No description provided for @locationServiceDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled.'**
  String get locationServiceDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are denied.'**
  String get locationPermissionDenied;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @estimatedTime.
  ///
  /// In en, this message translates to:
  /// **'Estimated Time'**
  String get estimatedTime;

  /// No description provided for @traveled.
  ///
  /// In en, this message translates to:
  /// **'Traveled'**
  String get traveled;

  /// No description provided for @trackDeliveryRoute.
  ///
  /// In en, this message translates to:
  /// **'Track delivery route'**
  String get trackDeliveryRoute;

  /// No description provided for @updating.
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get updating;

  /// No description provided for @recalculating.
  ///
  /// In en, this message translates to:
  /// **'Recalculating...'**
  String get recalculating;

  /// No description provided for @selectMapType.
  ///
  /// In en, this message translates to:
  /// **'Select Map Type'**
  String get selectMapType;

  /// No description provided for @verifyEmailMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter the code sent to {email}'**
  String verifyEmailMessage(String email);

  /// No description provided for @verifyPhoneMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter the code sent to {phone}'**
  String verifyPhoneMessage(String phone);
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
