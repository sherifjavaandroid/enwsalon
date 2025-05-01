import 'package:easycut/controller/home/profile_controller.dart';
import 'package:easycut/core/class/handling_data_view.dart';
import 'package:easycut/core/constant/color.dart';
import 'package:easycut/core/constant/dimensions.dart';
import 'package:easycut/core/constant/routes.dart';
import 'package:easycut/view/widget/home/cart_profile.dart';
import 'package:easycut/view/widget/profile/about_profile.dart';
import 'package:easycut/view/widget/profile/profile_favorite_salons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:easycut/linkapi.dart';
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ProfileControllerImp());

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoute.home,
          (Route<dynamic> route) => false,
        );
        return false;
      },
      child: SafeArea(
        child: GetBuilder<ProfileControllerImp>(
          builder: (controller) {
            return HandlingDataView(
              statusRequest: controller.statusRequest,
              widget: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CartProfile(
                      userName: controller.profile.name ?? "",
                      userImage: controller.profile.image != null
                          ? '${AppLink.imageUsers}${controller.profile.image}'
                          : "assets/images/icon/user.png",
                      userEmail: controller.profile.email ?? "",
                      logout: () {
                        controller.logout();
                      },
                    ),

                    SizedBox(height: Dimensions.height15),

                    // Custom Tabs

                    Container(
                      width: double.infinity,
                      height: 41,
                      decoration: const BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(
                            color: AppColor.backgroundicons2,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  controller.tabController!.animateTo(0),
                              child: Container(
                                alignment: Alignment.center,
                                height: 41,
                                decoration: BoxDecoration(
                                  color: controller.selectedIndex == 0
                                      ? AppColor.selectedColor
                                      : Colors.white,
                                ),
                                child: Text(
                                  "About".tr,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  controller.tabController!.animateTo(1),
                              child: Container(
                                alignment: Alignment.center,
                                height: 41,
                                decoration: BoxDecoration(
                                  color: controller.selectedIndex == 1
                                      ? AppColor.selectedColor
                                      : Colors.white,
                                ),
                                child: Text(
                                  "Favorites".tr,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Row(
                          //   children: [
                          //     GestureDetector(
                          //       onTap: () {
                          //         controller.deleteAccount();
                          //       },
                          //       child: BigText(
                          //         text: "Delete Account".tr,
                          //         color: Colors.red,
                          //         size: Dimensions.font20,
                          //       ),
                          //     ),
                          //     SizedBox(width: 120.w),
                          //     const LanguageSwitcher(),
                          //   ],
                          // ),

//Adding LanguageSwitcher for language change
                        ],
                      ),
                    ),

                    // Tab View Content
                    Expanded(
                      child: GetBuilder<ProfileControllerImp>(
                        builder: (controller) {
                          return TabBarView(
                            controller: controller.tabController,
                            children: [
                              AboutProfile(
                                email: controller.profile.email ?? "",
                                country: controller.profile.country ?? "",
                              ),
                              ProfileFavoriteSalons(
                                favorites: controller.favorites,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
