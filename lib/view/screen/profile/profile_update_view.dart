import 'package:easycut/controller/profile/profile_update_controller.dart';
import 'package:easycut/core/class/handling_data_view.dart';
import 'package:easycut/core/constant/color.dart';
import 'package:easycut/core/functions/valid_input.dart';
import 'package:easycut/view/widget/auth/custom_button_auth.dart';
import 'package:easycut/view/widget/auth/custom_text_form_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfileUpdateView extends StatelessWidget {
  const ProfileUpdateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileUpdateController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Update Profile'.tr,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: GetBuilder<ProfileUpdateController>(
        builder: (controller) {
          return HandlingDataView(
            statusRequest: controller.statusRequest,
            widget: Padding(
              padding: EdgeInsets.all(20.r),
              child: Form(
                key: controller.formState,
                child: ListView(
                  children: [
                    // Profile picture section
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50.r,
                            backgroundImage: AssetImage('assets/images/icon/user.png'),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 36.r,
                              width: 36.r,
                              decoration: BoxDecoration(
                                color: AppColor.selectedColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20.r,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30.h),

                    // Name field
                    CustomTextFormAuth(
                      myController: controller.nameController,
                      valid: (val) {
                        return validInput(val!, 3, 30, 'name');
                      },
                      type: TextInputType.name,
                      hintText: "Full Name".tr,
                      prefixIcon: 'assets/images/icon/user.png',
                    ),

                    SizedBox(height: 15.h),

                    // Email field
                    CustomTextFormAuth(
                      myController: controller.emailController,
                      valid: (val) {
                        return validInput(val!, 5, 100, 'email');
                      },
                      type: TextInputType.emailAddress,
                      hintText: "Email".tr,
                      prefixIcon: 'assets/images/icon/sms.png',
                    ),

                    SizedBox(height: 15.h),

                    // Phone field
                    CustomTextFormAuth(
                      myController: controller.phoneController,
                      valid: (val) {
                        return null; // Optional field
                      },
                      type: TextInputType.phone,
                      hintText: "Phone Number".tr,
                      prefixIcon: 'assets/images/icon/call-calling.png',
                    ),

                    SizedBox(height: 15.h),

                    // Address field
                    CustomTextFormAuth(
                      myController: controller.addressController,
                      valid: (val) {
                        return null; // Optional field
                      },
                      type: TextInputType.streetAddress,
                      hintText: "Address".tr,
                      prefixIcon: 'assets/images/icon/location.png',
                    ),

                    SizedBox(height: 20.h),

                    // Password heading
                    Text(
                      "Change Password (Optional)".tr,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.backgroundicons,
                      ),
                    ),

                    SizedBox(height: 15.h),

                    // Password field
                    CustomTextFormAuth(
                      myController: controller.passwordController,
                      valid: (val) {
                        if (val!.isEmpty) return null; // Optional field
                        return validInput(val, 6, 30, 'password');
                      },
                      type: TextInputType.visiblePassword,
                      obSecure: controller.isShowPassword,
                      hintText: "New Password".tr,
                      prefixIcon: 'assets/images/icon/lock.png',
                      suffixIcon: controller.isShowPassword
                          ? 'assets/images/icon/eye.png'
                          : 'assets/images/icon/eye_off.png',
                      suffixPressed: () {
                        controller.showPassword();
                      },
                    ),

                    SizedBox(height: 15.h),

                    // Confirm Password field
                    CustomTextFormAuth(
                      myController: controller.confirmPasswordController,
                      valid: (val) {
                        if (controller.passwordController.text.isEmpty) return null;
                        if (val != controller.passwordController.text) {
                          return "Passwords do not match".tr;
                        }
                        return null;
                      },
                      type: TextInputType.visiblePassword,
                      obSecure: controller.isShowPassword,
                      hintText: "Confirm New Password".tr,
                      prefixIcon: 'assets/images/icon/lock.png',
                      suffixIcon: controller.isShowPassword
                          ? 'assets/images/icon/eye.png'
                          : 'assets/images/icon/eye_off.png',
                      suffixPressed: () {
                        controller.showPassword();
                      },
                    ),

                    SizedBox(height: 40.h),

                    // Update button
                    CustomButtonAuth(
                      onPressed: controller.isLoading
                          ? null
                          : () => controller.updateProfile(),
                      text: controller.isLoading
                          ? "Updating...".tr
                          : "Update Profile".tr,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}