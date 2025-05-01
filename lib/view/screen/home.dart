import 'package:easycut/app.dart';
import 'package:easycut/controller/home/home_screen_controller.dart';
import 'package:easycut/core/constant/color.dart';
import 'package:easycut/core/constant/image_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/constant/routes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(HomeScreenControllerImp());
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<HomeScreenControllerImp>(
        builder: (controller) {
          return controller.pages[controller.currentPage];
        },
      ),
      bottomNavigationBar: GetBuilder<HomeScreenControllerImp>(
        builder: (controller) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                currentIndex: controller.currentPage,
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedLabelStyle: TextStyle(
                  color: AppColor.backgroundicons,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  color: AppColor.backgroundicons,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                selectedItemColor: AppColor.selectedColor,
                unselectedItemColor: Colors.grey.shade600,
                elevation: 0,
                items: [
                  _buildBottomNavItem(
                    icon: AppImageAsset.home,
                    label: 'Home'.tr,
                    isSelected: controller.currentPage == 0,
                  ),
                  _buildBottomNavItem(
                    icon: AppImageAsset.booking,
                    label: 'Booking'.tr,
                    isSelected: controller.currentPage == 1,
                  ),
                  _buildBottomNavItem(
                    icon: AppImageAsset.bottomprofile,
                    label: 'Profile'.tr,
                    isSelected: controller.currentPage == 2,
                  ),
                ],
                onTap: (index) {
                  controller.changePage(index);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  BottomNavigationBarItem _buildBottomNavItem({
    required String icon,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: ImageIcon(
          AssetImage(icon),
          color: isSelected ? AppColor.selectedColor : Colors.grey.shade600,
          size: 24.r,
        ),
      ),
      label: label,
    );
  }

  Widget _buildFloatingActionButton() {
    return GetBuilder<HomeScreenControllerImp>(
      builder: (controller) {
        return Container(
          height: 60.r,
          width: 60.r,
          margin: EdgeInsets.only(top: 30.h),
          child: FloatingActionButton(
            elevation: 4,
            backgroundColor: AppColor.selectedColor,
            onPressed: () {
              // Handle FAB tap - could be used for quick booking or search
              Get.toNamed(AppRoute.enhancedSearch);
            },
            child: Icon(
              Icons.search,
              size: 30.r,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}