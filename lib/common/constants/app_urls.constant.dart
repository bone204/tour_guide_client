class ApiUrls {
  // static const baseURL = "https://traveline-server.onrender.com";
  static const baseURL = "http://192.168.1.30:3000";
  //Authentication URLs
  static const signup = "$baseURL/auth/signup";
  static const login = "$baseURL/auth/login";
  static const refreshToken = "$baseURL/auth/refresh";
  static const emailStart = "$baseURL/auth/email/start";
  static const emailVerify = "$baseURL/auth/email/verify";
  static const phoneStart = "$baseURL/auth/phone/start";
  static const phoneVerify = "$baseURL/auth/phone/verify";

  //Users URLs
  static const users = "$baseURL/users";

  //Destination URLs
  static const getDestinations = "$baseURL/destinations";
  static const getFavoriteDestinations = "$baseURL/destinations/favorites";
  static String favoriteDestination(int id) =>
      "$baseURL/destinations/$id/favorite";

  //Rental Contracts URLs
  static const rentalContracts = "$baseURL/rental-contracts";

  //Rental Vehicles URLs
  static const rentalVehicles = "$baseURL/rental-vehicles";
  static const vehicleCatalogs = "$baseURL/vehicle-catalog";

  //Rental Bills URLs
  static const rentalBills = "$baseURL/rental-bills";

  //Chatbot URLs
  static const chatbot = "$baseURL/chat";

  //Provinces URLs
  static const provinces = "$baseURL/vn-admin/legacy/provinces";

  //Travel Routes URLs
  static const itinerary = "$baseURL/travel-routes";

  //Feedback URLs
  static const feedback = "$baseURL/feedback";

  //Hobbies URLs
  static const hobbies = "$baseURL/users/profile/hobbies";

  //Voucher URLs
  static const vouchers = "$baseURL/vouchers";

  //Cooperation URLs
  static const cooperations = "$baseURL/cooperations";
  static const getFavoriteCooperations = "$baseURL/cooperations/favorites";
  static String favoriteCooperation(int id) =>
      "$baseURL/cooperations/$id/favorite";

  //Payment URLs
  static const payments = "$baseURL/payments";
}
