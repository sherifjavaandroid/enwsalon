import 'package:easycut/controller/home/profile_controller.dart';
import 'package:easycut/core/class/handling_data_view.dart';
import 'package:easycut/core/constant/color.dart';
import 'package:easycut/core/constant/dimensions.dart';
import 'package:easycut/core/constant/routes.dart';
import 'package:easycut/view/screen/home/lauguage_profile.dart';
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<ProfileControllerImp>(
        builder: (controller) {
          return HandlingDataView(
            statusRequest: controller.statusRequest,
            widget: CustomScrollView(
              slivers: [
                // Custom App Bar with Profile Header
                SliverAppBar(
                  expandedHeight: 200.h,
                  pinned: true,
                  backgroundColor: AppColor.selectedColor,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColor.selectedColor,
                            AppColor.selectedColor.withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Profile Image
                            CircleAvatar(
                              radius: 45.r,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 42.r,
                                backgroundImage: controller.profile.image != null
                                    ? NetworkImage('${AppLink.imageUsers}${controller.profile.image}')
                                    : const AssetImage("assets/images/icon/user.png") as ImageProvider,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            // User Name
                            Text(
                              controller.profile.name ?? "Guest User".tr,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            // User Email
                            Text(
                              controller.profile.email ?? "",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Profile Options and Content
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // Quick Actions
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildQuickAction(
                              icon: Icons.edit,
                              title: 'Edit'.tr,
                              onTap: () => Get.toNamed(AppRoute.profileUpdate),
                            ),
                            _buildQuickAction(
                              icon: Icons.favorite,
                              title: 'Favorites'.tr,
                              onTap: () => controller.tabController?.animateTo(1),
                            ),

                            _buildQuickAction(
                              icon: Icons.help_outline,
                              title: 'Help'.tr,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),

                      Divider(height: 1, color: Colors.grey.shade200),

                      // Language Selector
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                        child: Row(
                          children: [
                            Icon(Icons.language,
                              color: AppColor.backgroundicons,
                              size: 24.r,
                            ),
                            SizedBox(width: 15.w),
                            Text(
                              'Language'.tr,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            const LanguageSwitcher(),
                          ],
                        ),
                      ),

                      Divider(height: 1, color: Colors.grey.shade200),

                      // Custom TabBar
                      Container(
                        color: Colors.white,
                        height: 50.h,
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => controller.tabController?.animateTo(0),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: controller.selectedIndex == 0
                                            ? AppColor.selectedColor
                                            : Colors.transparent,
                                        width: 3.h,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "About".tr,
                                    style: TextStyle(
                                      color: controller.selectedIndex == 0
                                          ? AppColor.selectedColor
                                          : Colors.grey.shade600,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => controller.tabController?.animateTo(1),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: controller.selectedIndex == 1
                                            ? AppColor.selectedColor
                                            : Colors.transparent,
                                        width: 3.h,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Favorites".tr,
                                    style: TextStyle(
                                      color: controller.selectedIndex == 1
                                          ? AppColor.selectedColor
                                          : Colors.grey.shade600,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Tab Views
                      SizedBox(
                        height: 400.h, // Fixed height for tab content
                        child: TabBarView(
                          controller: controller.tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            // About Tab
                            SingleChildScrollView(
                              padding: EdgeInsets.all(20.r),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildProfileSection(
                                    title: 'Personal Information'.tr,
                                    children: [
                                      _buildInfoItem(
                                        icon: Icons.email_outlined,
                                        title: 'Email'.tr,
                                        value: controller.profile.email ?? 'Not provided',
                                      ),
                                      _buildInfoItem(
                                        icon: Icons.phone_outlined,
                                        title: 'Phone'.tr,
                                        value: controller.profile.phone ?? 'Not provided',
                                      ),
                                      _buildInfoItem(
                                        icon: Icons.location_on_outlined,
                                        title: 'Address'.tr,
                                        value: controller.profile.address ?? 'Not provided',
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 24.h),

                                  _buildProfileSection(
                                    title: 'Location'.tr,
                                    children: [
                                      _buildInfoItem(
                                        icon: Icons.flag_outlined,
                                        title: 'Country'.tr,
                                        value: controller.profile.country ?? 'Not provided',
                                      ),
                                      _buildInfoItem(
                                        icon: Icons.location_city_outlined,
                                        title: 'City'.tr,
                                        value: controller.profile.city ?? 'Not provided',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Favorites Tab
                            ProfileFavoriteSalons(
                              favorites: controller.favorites,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Settings Options
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.only(top: 16.h),
                    color: Colors.white,
                    child: Column(
                      children: [
                        _buildSettingsItem(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy'.tr,
                          onTap: () {},
                        ),
                        _buildSettingsItem(
                          icon: Icons.help_outline,
                          title: 'Help & Support'.tr,
                          onTap: () {},
                        ),
                        _buildSettingsItem(
                          icon: Icons.info_outline,
                          title: 'About App'.tr,
                          onTap: () {},
                        ),
                        _buildSettingsItem(
                          icon: Icons.delete_outline,
                          title: 'Delete Account'.tr,
                          onTap: () => controller.deleteAccount(),
                          isDestructive: true,
                        ),
                        _buildSettingsItem(
                          icon: Icons.logout,
                          title: 'Logout'.tr,
                          onTap: () => controller.logout(),
                          isDestructive: true,
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(height: 30.h),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50.r,
            height: 50.r,
            decoration: BoxDecoration(
              color: AppColor.selectedColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColor.backgroundicons,
              size: 24.r,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.backgroundicons,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20.r,
            color: Colors.grey.shade600,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Colors.grey.shade700,
        size: 24.r,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : Colors.black87,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey.shade400,
        size: 24.r,
      ),
      onTap: onTap,
    );
  }
}