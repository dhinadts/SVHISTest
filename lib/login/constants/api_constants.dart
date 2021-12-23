class ApiConstants {
  static const String BASE_URL = "https://api.jamaica.servicedx.com";

  static const String SIGN_UP = "/admin/sdxcontact/departments/";

  static const String LOGIN = "/auth/oauth/token";
  static const String VALIDATE_OTP = "/admin/sdxcontact/users/validateOTP";

  static const String SET_PASSWORD = "/admin/sdxcontact/users/setPassword";
  static const String GET_USER = "/admin/sdxcontact/users";
  static const int CONNECTION_TIME_OUT = 30000;
  static const int SERVICE_TIME_OUT = 30000;

  static const String SUPPORT = "/sender/messages/sendMessage";
    static const String APP_VERSION = "/license/version?";

}
