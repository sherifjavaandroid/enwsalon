import 'package:easycut/core/class/status_request.dart';
import 'package:easycut/core/functions/handling_data_controller.dart';
import 'package:easycut/core/services/services.dart';
import 'package:easycut/data/data_source/remote/profile/profile_update_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileUpdateController extends GetxController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  bool isShowPassword = true;
  bool isLoading = false;
  StatusRequest statusRequest = StatusRequest.success;

  ProfileUpdateData profileUpdateData = ProfileUpdateData(Get.find());
  MyServices myServices = Get.find();

  // Toggle password visibility
  void showPassword() {
    isShowPassword = !isShowPassword;
    update();
  }

  // Update profile information
  Future<void> updateProfile() async {
    if (formState.currentState!.validate()) {
      isLoading = true;
      statusRequest = StatusRequest.loading;
      update();

      try {
        // Check if password field is filled and matches confirmation
        if (passwordController.text.isNotEmpty) {
          if (passwordController.text != confirmPasswordController.text) {
            Get.snackbar(
              "Error".tr,
              "Passwords do not match".tr,
              colorText: Colors.red,
            );
            isLoading = false;
            statusRequest = StatusRequest.failure;
            update();
            return;
          }
        }

        // Get user ID from shared preferences
        String userId = myServices.sharedPreferences.getInt('id').toString();

        var response = await profileUpdateData.updateProfile(
          userId: userId,
          name: nameController.text,
          email: emailController.text.isNotEmpty ? emailController.text : null,
          phone: phoneController.text.isNotEmpty ? phoneController.text : null,
          address: addressController.text.isNotEmpty ? addressController.text : null,
          password: passwordController.text.isNotEmpty ? passwordController.text : null,
        );

        statusRequest = handlingData(response);

        if (statusRequest == StatusRequest.success) {
          if (response['status'] == 'success') {
            // Update stored user information in shared preferences
            myServices.sharedPreferences.setString('name', nameController.text);
            if (emailController.text.isNotEmpty) {
              myServices.sharedPreferences.setString('email', emailController.text);
            }
            if (phoneController.text.isNotEmpty) {
              myServices.sharedPreferences.setString('phone', phoneController.text);
            }
            if (addressController.text.isNotEmpty) {
              myServices.sharedPreferences.setString('address', addressController.text);
            }

            Get.snackbar(
              "Success".tr,
              "Profile updated successfully".tr,
              colorText: Colors.green,
            );
          } else {
            Get.snackbar(
              "Error".tr,
              response['message'] ?? "Failed to update profile".tr,
              colorText: Colors.red,
            );
            statusRequest = StatusRequest.failure;
          }
        }
      } catch (e) {
        Get.snackbar(
          "Error".tr,
          "An error occurred while updating profile".tr,
          colorText: Colors.red,
        );
        statusRequest = StatusRequest.serverException;
      } finally {
        isLoading = false;
        update();
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize controllers with current user data from shared preferences
    nameController = TextEditingController(text: myServices.sharedPreferences.getString('name') ?? '');
    emailController = TextEditingController(text: myServices.sharedPreferences.getString('email') ?? '');
    phoneController = TextEditingController(text: myServices.sharedPreferences.getString('phone') ?? '');
    addressController = TextEditingController(text: myServices.sharedPreferences.getString('address') ?? '');
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}