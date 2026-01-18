import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiUrls {
  static String get baseURL =>
      dotenv.env['BASE_URL'] ?? 'https://traveline-server.vercel.app';

  //Authentication URLs
  static String get signup => "$baseURL/auth/signup";
  static String get login => "$baseURL/auth/login";
  static String get refreshToken => "$baseURL/auth/refresh";
  static String get emailStart => "$baseURL/auth/email/start";
  static String get emailVerify => "$baseURL/auth/email/verify";
  static String get phoneStart => "$baseURL/auth/phone/start";
  static String get phoneVerify => "$baseURL/auth/phone/verify";

  static String get auth => "$baseURL/auth";
  static String get changePassword => "$baseURL/auth/password";

  //Users URLs
  static String get users => "$baseURL/users";

  //Destination URLs
  static String get getDestinations => "$baseURL/destinations";
  static String get getFavoriteDestinations =>
      "$baseURL/destinations/favorites";
  static String favoriteDestination(int id) =>
      "$baseURL/destinations/$id/favorite";

  //Rental Contracts URLs
  static String get rentalContracts => "$baseURL/rental-contracts";

  //Hotel Rooms URLs
  static String get hotelRooms => "$baseURL/hotel-rooms";
  static String get hotelBills => "$baseURL/hotel-bills";

  //Rental Vehicles URLs
  static String get rentalVehicles => "$baseURL/rental-vehicles";
  static String get vehicleCatalogs => "$baseURL/vehicle-catalog";

  //Rental Bills URLs
  static String get rentalBills => "$baseURL/rental-bills";

  //Chatbot URLs
  static String get chatbot => "$baseURL/chat";

  //Provinces URLs
  static String get provinces => "$baseURL/provinces";

  //Travel Routes URLs
  static String get itinerary => "$baseURL/travel-routes";

  //Feedback URLs
  static String get feedback => "$baseURL/feedback";

  //Hobbies URLs
  static String get hobbies => "$baseURL/users/profile/hobbies";

  //Voucher URLs
  static String get vouchers => "$baseURL/vouchers";

  //Cooperation URLs
  static String get cooperations => "$baseURL/cooperations";
  static String get getFavoriteCooperations =>
      "$baseURL/cooperations/favorites";
  static String favoriteCooperation(int id) =>
      "$baseURL/cooperations/$id/favorite";

  //Restaurant Tables URLs
  static String get restaurantTables => "$baseURL/restaurant/tables";
  static String get restaurantBookings => "$baseURL/restaurant/bookings";

  //Payment URLs
  static String get payments => "$baseURL/payments";

  //Notification URLs
  static String get notifications => "$baseURL/notifications";

  //Administrative Mapping URLs
  static String get vnAdmin => "$baseURL/vn-admin";
  static String get mapping => "$vnAdmin/mapping";
  static String get legacy => "$vnAdmin/legacy";
  static String get reform => "$vnAdmin/reform";
}
