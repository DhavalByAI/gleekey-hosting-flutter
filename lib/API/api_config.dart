class ApiConfig {
  ///base url
  static String BASE_URL = 'https://gleekey.in/api/';
  static String Property_Image_Url =
      'https://gleekey.in/public/images/property_type/';
  //

/*  /// new
  static String BASE_URL = 'http://softieons.in/gleekey/api/';
  static String Property_Image_Url =
      'http://softieons.in/gleekey/public/images/property_type/';*/

  ///snackbar
  static const String error = "Error";
  static const String success = "Success";
  static const String warning = "Warning";

  ///forgotpass
  static String forgotpass = '${BASE_URL}forgot_password';
  static String login = '${BASE_URL}login';
  static String sendOTP = '${BASE_URL}send-otp';
  static String social_media_login = '${BASE_URL}social_media_login';
  static String changeSecurityPass = '${BASE_URL}user_change_password';

  ///get User

  static String get_user_info = '${BASE_URL}get_user_info';

  ///get country, state, city
  static String get_country = '${BASE_URL}get_country';
  static String get_state = '${BASE_URL}get_state';
  static String get_city = '${BASE_URL}get_city';
  static String get_bank_list = '${BASE_URL}get_bank_list';

  ///dashboard
  static String reservation = '${BASE_URL}reservations';
  static String allProperties = '${BASE_URL}allProperties';
  static String viewProperties = '${BASE_URL}viewProperties/';

  ///accept and decline api
  static String booking_accept = '${BASE_URL}booking_accept';
  static String booking_decline = '${BASE_URL}booking_decline';

  ///kyc
  static String get_kyc_data = '${BASE_URL}get_kyc_data';
  static String post_user_kyc_data = '${BASE_URL}post_user_kyc_data';
  static String becomeAgent = '${BASE_URL}become-a-agent';

  ///wishlist
  static String wishListData = '${BASE_URL}wishlist';
  static String addEditWishlist = '${BASE_URL}addEditWishlist';

  ///insight
  static String reviews = '${BASE_URL}reviews';

  ///endpoints
  static String startHost = '${BASE_URL}property/getStarted';
  static String hostProperty = '${BASE_URL}property/listing/';
  static String transactionHistory = '${BASE_URL}transactionHistory';
  static String get_all_room_names = '${BASE_URL}get_all_room_names';
  static String hotel_room_image_delete =
      '${BASE_URL}property/hotel_room_image_delete';

  ///set_price_date
  static String set_price_date = '${BASE_URL}set_price_date';
  static String get_property_calender_price =
      '${BASE_URL}get_property_calender_price';

  ///profile
  static String updateProfile = '${BASE_URL}users/profile';

  ///agent apis
  static String get_agent_dashboard = '${BASE_URL}get_agent_dashboard';
  static String agent_property_list = '${BASE_URL}agent_property_list';
  static String agent_bookings = '${BASE_URL}agent_bookings';
  static String agent_transaction = '${BASE_URL}agent_transaction';

  ///notification api
  static String get_all_notification = '${BASE_URL}get_all_notification';
}
