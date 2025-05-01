class AppLink {
  static const String server = "https://easycuteg.com";
  static const String server2 = "https://dashboard.easycuteg.com";
  static const String imageUsers = "https://easycuteg.com/upload/users/";
  static const String imageSalons = "https://easycuteg.com/upload/salons/";
  static const String imageProducts = "https://easycuteg.com/upload/products/";
  static const String imageServices = "https://easycuteg.com/upload/services/";
// ============================= Test ================================
  static const String test = "$server/test.php";
// ================================= Auth ==========================
  static const String signUp = "$server/users/auth/signup.php";
  static const String login = "$server/users/auth/login.php";
  static const String activateCode = "$server/users/auth/activatecode.php";
  static const String resend = "$server/users/auth/resend.php";
// ================================= ForgetPassword ====================
  static const String checkEmail = "$server/users/auth/checkemail.php";
  static const String resetPassword = "$server/users/auth/resetpassword.php";
  static const String verifyCode = "$server/users/auth/verifycode.php";
// ================================= Home ====================
  static const String home = "$server/users/home/home.php";
  static const String userInfo = "$server/users/profile/show.php";
  static const String userDelete = "$server/users/profile/delete.php";
  static const String salonDetail = "$server/users/main/salondetail.php";
  static const String addFavorite = "$server/users/favorites/add.php";
  static const String deleteFavorite = "$server/users/favorites/delete.php";
  static const String addBooking = "$server/booking/add.php";
  static const String addServiceBooking = "$server/booking_service/add.php";
  static const String showBooking = "$server/booking/show.php";
  static const String viewBookings = "$server/booking/view.php";
  static const String viewCountries = "$server/settings/states.php";
  static const String viewAvaliableTimes = "$server2/api/checkAvailability";
  static const String viewSalonRates = "$server2/api/salons";
  static const String feedbackSalonRates = "$server2/api/ratings";
  static const String searchSalon = "$server2/api/test";

  // ================================= New API Endpoints ====================

  // Profile
  static const String profileUpdate = "$server2/api/v1/auth/profile/update";

  // Salon Search
  static const String salonSearch = "$server2/api/salon/search";

  // Ratings
  static const String salonFeedback = "$server2/api/v1/auth/salon/feedback";
  static const String submitRating = "$server2/api/v1/auth/rating/submit";
  static const String checkRating = "$server2/api/v1/auth/rating/check";
  static const String salonRatings = "$server2/api/v1/auth/salon/ratings";

  // Booking Management
  static const String bookingDetails = "$server2/api/v1/auth/booking/details";
  static const String bookingServices = "$server2/api/v1/auth/booking/services";
  static const String cancelBooking = "$server2/api/v1/auth/booking/cancel";
  static const String rescheduleBooking = "$server2/api/v1/auth/booking/reschedule";
}