import 'package:easycut/core/class/status_request.dart';
import 'package:easycut/core/constant/routes.dart';
import 'package:easycut/core/functions/handling_data_controller.dart';
import 'package:easycut/core/services/services.dart';
import 'package:easycut/data/data_source/remote/home/profile_data.dart';
import 'package:easycut/data/model/favorite_model.dart';
import 'package:easycut/data/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class ProfileController extends GetxController {
  getData();
  logout();
  deleteAccount();
}

class ProfileControllerImp extends ProfileController
    with GetSingleTickerProviderStateMixin {
  MyServices myServices = Get.find();
  int? id;

  ProfileData profileData = ProfileData(Get.find());
  StatusRequest statusRequest = StatusRequest.success;
  ProfileModel profile = ProfileModel();
  List<FavoriteModel> favorites = [];

  TabController? tabController; // Nullable to prevent LateInitializationError
  int selectedIndex = 0; // Track selected tab

  @override
  void onInit() {
    super.onInit();
    initialData();
    tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        selectedIndex = tabController!.index;
        update();
      });
    getData();
  }

  void initialData() {
    id = myServices.sharedPreferences.getInt('id');
  }

  @override
  getData() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await profileData.postData(id?.toString() ?? '');
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      if (response['status'] == 'success') {
        var data = response['profile'] as Map<String, dynamic>;
        profile = ProfileModel.fromJson(data);
        favorites = FavoriteModel.fromList(
            List<Map<String, dynamic>>.from(response['favorites']));
      } else {
        Get.snackbar(
          'Warning'.tr,
          'There is no data'.tr,
          snackPosition: SnackPosition.TOP,
          colorText: Colors.red,
        );
        statusRequest = StatusRequest.failure;
      }
    }
    update();
  }

  @override
  void onClose() {
    tabController?.dispose();
    super.onClose();
  }

  @override
  logout() {
    Get.offAllNamed(AppRoute.login);
    myServices.sharedPreferences.clear();
    myServices.sharedPreferences.setString('step', '1');
  }

  @override
  deleteAccount() {
    Get.defaultDialog(
      middleText: "Are you sure to delete your account?".tr,
      actions: [
        TextButton(
          onPressed: () async {
            Get.back();
            statusRequest = StatusRequest.loading;
            update();
            var response = await profileData.deleteData(
              id?.toString() ?? '',
              profile.image ?? '',
            );
            statusRequest = handlingData(response);
            if (statusRequest == StatusRequest.success) {
              if (response['status'] == 'success') {
                logout();
              } else {
                Get.snackbar(
                  'Warning'.tr,
                  'Failed to Delete Account, Try Again'.tr,
                  snackPosition: SnackPosition.TOP,
                  colorText: Colors.red,
                );
                statusRequest = StatusRequest.failure;
              }
            }
            update();
          },
          child: Text("yes".tr, style: const TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text("no".tr, style: const TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}
