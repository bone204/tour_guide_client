  class ApiUrls {
    // static const baseURL = "https://traveline-server.onrender.com";
    // static const baseURL = "http://192.168.1.35:4000";
    static const baseURL = "http://192.168.1.100:4000";
    //Authentication URLs
    static const signup = "$baseURL/auth/signup";
    static const login = "$baseURL/auth/login";
    static const refreshToken = "$baseURL/auth/refresh";

    //Destination URLs
    static const getDestinations = "$baseURL/destinations";
    static const getFavoriteDestinations = "$baseURL/destinations/favorites";
    static String favoriteDestination(int id) => "$baseURL/destinations/$id/favorite";
    
    //Rental Contracts URLs
    static const rentalContracts = "$baseURL/rental-contracts";
    
    //Rental Vehicles URLs
    static const rentalVehicles = "$baseURL/rental-vehicles";

    //Rental Vehicles URLs
    static const chatbot = "$baseURL/chat";
  }
