import 'package:carousel_slider/carousel_slider.dart';
import 'package:easycut/controller/home/home_controller.dart';
import 'package:easycut/core/class/handling_data_view.dart';
import 'package:easycut/core/constant/dimensions.dart';
import 'package:easycut/core/constant/image_asset.dart';
import 'package:easycut/core/constant/routes.dart';
import 'package:easycut/core/constant/color.dart';
import 'package:easycut/core/shared/widgets/small_text.dart';
import 'package:easycut/view/screen/home/salonsearchdelegate.dart';
import 'package:easycut/view/widget/auth/custom_buttom_search.dart';
import 'package:easycut/view/widget/exitdialog.dart';
import 'package:easycut/view/widget/home/guest_NewestSalonItem.dart';
import 'package:easycut/view/widget/home/header_main_view.dart';
import 'package:easycut/view/widget/home/newest_salon_item.dart';
import 'package:easycut/view/widget/home/newest_text.dart';
import 'package:easycut/view/widget/home/sliding_popular_salons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../features/search/controller/carousel_controller_x.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final CarouselControllerX controllerX = Get.put(CarouselControllerX());

    final List<Map<String, dynamic>> promotionBanners = [
      {
        'image': 'assets/images/salonbk/salon1.jpg',
        'title': 'Special Discount'.tr,
        'description': '20% off on all services this week'.tr
      },
      {
        'image': 'assets/images/salonbk/salon2.jpg',
        'title': 'New Stylists'.tr,
        'description': 'Meet our talented new team members'.tr
      },
      {
        'image': 'assets/images/salonbk/salon4.jpg',
        'title': 'Premium Experience'.tr,
        'description': 'Try our luxury treatments today'.tr
      },
    ];

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showExitConfirmationDialog(context);
        return shouldPop ?? false;
      },
      child: SafeArea(
        child: GetBuilder<HomeControllerImp>(
          builder: (controller) {
            return RefreshIndicator(
              onRefresh: () async {
                await controller.getData();
              },
              color: AppColor.selectedColor,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Enhanced Header Section
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 15.h,
                      ),
                      child: HeaderMainView(
                        name: controller.name,
                        image: controller.image,
                      ),
                    ),

                    // Enhanced Search Bar
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: CustomButtonSearch(
                          onPressed: () {
                            Get.toNamed(AppRoute.enhancedSearch);
                          },
                          prefixIcon: AppImageAsset.search,
                          hintText: "Search for a salon...".tr,
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Enhanced Promotional Banners with Overlay Text
                    HandlingDataView(
                      statusRequest: controller.statusRequest,
                      widget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Enhanced Carousel with Text Overlay
                          Container(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 180.h,
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                      aspectRatio: 16/9,
                                      viewportFraction: 0.92,
                                      enlargeCenterPage: true,
                                      enableInfiniteScroll: true,
                                      autoPlay: true,
                                      autoPlayAnimationDuration: Durations.long1,
                                      onPageChanged: (index, reason) {
                                        controllerX.updateIndex(index);
                                      },
                                    ),
                                    items: promotionBanners.map((banner) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12.r),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.1),
                                                  spreadRadius: 1,
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Stack(
                                              children: [
                                                // Banner Image
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(12.r),
                                                  child: Image.asset(
                                                    banner['image'],
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                ),
                                                // Gradient Overlay
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12.r),
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                      colors: [
                                                        Colors.transparent,
                                                        Colors.black.withOpacity(0.7),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                // Text Overlay
                                                Positioned(
                                                  bottom: 20.h,
                                                  left: 20.w,
                                                  right: 20.w,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        banner['title'],
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20.sp,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(height: 4.h),
                                                      Text(
                                                        banner['description'],
                                                        style: TextStyle(
                                                          color: Colors.white.withOpacity(0.9),
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                // Enhanced Carousel Indicators
                                Obx(
                                      () => Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      promotionBanners.length,
                                          (index) {
                                        return AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          width: controllerX.currentIndex.value == index ? 20.w : 8.w,
                                          height: 8.h,
                                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                                          decoration: BoxDecoration(
                                            color: controllerX.currentIndex.value == index
                                                ? AppColor.selectedColor
                                                : AppColor.backgroundicons2,
                                            borderRadius: BorderRadius.circular(4.r),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Category Chips Section
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Categories'.tr,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                SizedBox(
                                  height: 40.h,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      _buildCategoryChip(
                                        text: 'All'.tr,
                                        isSelected: controller.currentClassification.value == "all",
                                        onTap: () => controller.filterByClassification("all"),
                                      ),
                                      _buildCategoryChip(
                                        text: 'Luxury'.tr,
                                        isSelected: controller.currentClassification.value == "luxury",
                                        onTap: () => controller.filterByClassification("luxury"),
                                      ),
                                      _buildCategoryChip(
                                        text: 'Standard'.tr,
                                        isSelected: controller.currentClassification.value == "standard",
                                        onTap: () => controller.filterByClassification("standard"),
                                      ),
                                      _buildCategoryChip(
                                        text: 'Economic'.tr,
                                        isSelected: controller.currentClassification.value == "economic",
                                        onTap: () => controller.filterByClassification("economic"),
                                      ),
                                      _buildCategoryChip(
                                        text: 'Men Only'.tr,
                                        isSelected: controller.currentClassification.value == "men",
                                        onTap: () => controller.filterByClassification("men"),
                                      ),
                                      _buildCategoryChip(
                                        text: 'Women Only'.tr,
                                        isSelected: controller.currentClassification.value == "women",
                                        onTap: () => controller.filterByClassification("women"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20.h),

                          // Popular Salons Section
                          controller.popSalons.isEmpty
                              ? const SizedBox.shrink()
                              : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Featured Salons'.tr,
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Show all featured salons
                                      },
                                      child: Text(
                                        'See All'.tr,
                                        style: TextStyle(
                                          color: AppColor.selectedColor,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8.h),
                              SlidingPopularSalons(
                                popularSalon: controller.popSalons,
                              ),
                            ],
                          ),

                          SizedBox(height: 20.h),

                          // Nearby Salons Section
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Near You'.tr,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Show all nearby salons
                                  },
                                  child: Text(
                                    'See All'.tr,
                                    style: TextStyle(
                                      color: AppColor.selectedColor,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: SmallText(
                              maxline: 1,
                              text: "Don't waste your time and book at your preference".tr,
                              color: AppColor.titleColor,
                              size: 14.sp,
                            ),
                          ),

                          SizedBox(height: 12.h),

                          // Nearby Salons List
                          controller.isLoggedIn
                              ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: controller.nearSalons.isEmpty
                                ? _buildEmptyStateCard("No nearby salons found".tr)
                                : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.nearSalons.length,
                              itemBuilder: (context, index) {
                                return GuestNewestsalonitem(
                                  salon: controller.nearSalons[index],
                                );
                              },
                            ),
                          )
                              : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: controller.nearSalons.isEmpty
                                ? _buildEmptyStateCard("No nearby salons found".tr)
                                : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.nearSalons.length,
                              itemBuilder: (context, index) {
                                return NewestSalonItem(
                                  salon: controller.nearSalons[index],
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 20.h),

                          // New Salons Section
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'New Salons'.tr,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Show all new salons
                                  },
                                  child: Text(
                                    'See All'.tr,
                                    style: TextStyle(
                                      color: AppColor.selectedColor,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 12.h),

                          // New Salons List
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: controller.newSalons.isEmpty
                                ? _buildEmptyStateCard("No new salons available".tr)
                                : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.newSalons.length,
                              itemBuilder: (context, index) {
                                return controller.isLoggedIn
                                    ? GuestNewestsalonitem(
                                  salon: controller.newSalons[index],
                                )
                                    : NewestSalonItem(
                                  salon: controller.newSalons[index],
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 20.h),
                        ],
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

  // Helper method to build category chips
  Widget _buildCategoryChip({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.selectedColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: AppColor.selectedColor.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  // Helper method to build empty state card
  Widget _buildEmptyStateCard(String message) {
    return Container(
      height: 120.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.store_outlined,
              size: 40.r,
              color: Colors.grey,
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}