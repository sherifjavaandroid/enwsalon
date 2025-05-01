import 'package:easycut/core/constant/routes.dart';

import 'package:get/get.dart';
import 'dart:async';
import 'package:easycut/core/services/services.dart';

class SplashController extends GetxController {
  var opacity = 0.0.obs;
  MyServices myServices = Get.find();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 500), () {
      opacity.value = 1.0;
    });

    Future.delayed(const Duration(seconds: 3), () {
      _handleNavigation();
    });
  }

  void _handleNavigation() {
    String? step = myServices.sharedPreferences.getString('step');
    if (step == '2') {
      Get.offNamed(AppRoute.home);
    } else if (step == '1') {
      Get.offNamed(AppRoute.languagescreen);
    } else {
      Get.offNamed(AppRoute.languagescreen); // Default redirection
    }
  }
}
