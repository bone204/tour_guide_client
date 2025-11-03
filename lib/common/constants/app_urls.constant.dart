  class ApiUrls {
    // static const baseURL = "https://traveline-server.onrender.com";
    static const baseURL = "http://192.168.1.204:3000";
    //Authentication URLs
    static const signup = "$baseURL/auth/signup";
    static const login = "$baseURL/auth/login";
    static const refreshToken = "$baseURL/auth/refresh";

    //Destination URLs
    static const getDestinations = "$baseURL/destinations";
  }
