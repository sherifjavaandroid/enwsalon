import 'package:easycut/controller/auth/activate_code_controller.dart';
import 'package:easycut/controller/auth/forget_password_controller.dart';
import 'package:easycut/controller/auth/login_controller.dart';
import 'package:easycut/controller/auth/reset_password_controller.dart';
import 'package:easycut/controller/auth/signup_controller.dart';
import 'package:easycut/controller/auth/verify_code_controller.dart';
import 'package:easycut/controller/home/home_controller.dart';
import 'package:easycut/controller/onboarding_controller.dart';
import 'package:easycut/core/class/crud.dart';

// Import new controllers
import 'package:easycut/controller/profile/profile_update_controller.dart';
import 'package:easycut/controller/search/salon_search_controller.dart';
import 'package:easycut/controller/rating/rating_controller.dart';
import 'package:easycut/controller/booking/booking_management_controller.dart';

import 'package:get/get.dart';

class MyBinding extends Bindings {
  @override
  void dependencies() {
    // ============== CRUD Operations
    Get.put(Crud());
    // ============== On Boarding Controller
    Get.lazyPut(() => OnBoardingControllerImp(), fenix: true);
    // ============== Auth Controller
    Get.lazyPut(() => LoginControllerImp(), fenix: true);
    Get.lazyPut(() => SignUpControllerImp(), fenix: true);
    Get.lazyPut(() => ForgetPasswordControllerImp(), fenix: true);
    Get.lazyPut(() => VerifyCodeControllerImp(), fenix: true);
    Get.lazyPut(() => ResetPasswordControllerImp(), fenix: true);
    Get.lazyPut(() => ActivateCodeControllerImp(), fenix: true);
    // ============== Home Controller
    Get.lazyPut(() => HomeControllerImp(), fenix: true);

    // ============== New Controllers
    Get.lazyPut(() => ProfileUpdateController(), fenix: true);
    Get.lazyPut(() => SalonSearchController(), fenix: true);
    Get.lazyPut(() => RatingController(), fenix: true);
    Get.lazyPut(() => BookingManagementController(), fenix: true);
  }
}