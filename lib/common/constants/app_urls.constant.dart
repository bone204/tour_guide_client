class ApiUrls {
  // static const baseURL = "https://traveline-server.onrender.com";
  static const baseURL = "http://192.168.1.243:3000";
  //Authentication URLs
  static const signup = "$baseURL/auth/signup";
  static const login = "$baseURL/auth/login";
  static const refreshToken = "$baseURL/auth/refresh";
  static const emailStart = "$baseURL/auth/email/start";
  static const emailVerify = "$baseURL/auth/email/verify";

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

  //Rental Vehicles URLs
  static const chatbot = "$baseURL/chat";

  //Provinces URLs
  static const provinces = "$baseURL/vn-admin/legacy/provinces";

  //Travel Routes URLs
  static const itinerary = "$baseURL/travel-routes";

  //Feedback URLs
  static const feedback = "$baseURL/feedback";
}
