import 'package:easycut/controller/search/salon_search_controller.dart';
import 'package:easycut/core/constant/color.dart';
import 'package:easycut/core/constant/routes.dart';
import 'package:easycut/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EnhancedSalonSearchView extends StatelessWidget {
  const EnhancedSalonSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SalonSearchController());

    return GetBuilder<SalonSearchController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // Search header
                _buildSearchHeader(controller),

                // Search results
                Expanded(
                  child: controller.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildSearchResults(controller),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchHeader(SalonSearchController controller) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Back button and title
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 24.r,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              SizedBox(width: 16.w),
              Text(
                'Find Your Perfect Salon'.tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Search field
          TextField(
            controller: controller.searchController,
            autofocus: true,
            onChanged: (value) {
              controller.performSearch(value);
            },
            decoration: InputDecoration(
              fillColor: Colors.grey.shade100,
              filled: true,
              hintText: 'Search salon name, location...'.tr,
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: controller.searchController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  controller.clearSearch();
                },
              )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 12.h),
            ),
          ),

          // Filter options
          if (controller.searchResults.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Row(
                children: [
                  // Filter by rating
                  _buildFilterChip(
                    label: 'Top Rated'.tr,
                    isSelected: controller.filterByRating,
                    onTap: () {
                      controller.toggleRatingFilter();
                    },
                  ),

                  SizedBox(width: 8.w),

                  // Filter by gender
                  _buildFilterChip(
                    label: 'Men Only'.tr,
                    isSelected: controller.filterByGender == 'men',
                    onTap: () {
                      controller.setGenderFilter('men');
                    },
                  ),

                  SizedBox(width: 8.w),

                  _buildFilterChip(
                    label: 'Women Only'.tr,
                    isSelected: controller.filterByGender == 'women',
                    onTap: () {
                      controller.setGenderFilter('women');
                    },
                  ),

                  const Spacer(),

                  // Results count
                  Text(
                    '${controller.searchResults.length} ${controller.searchResults.length == 1 ? "result".tr : "results".tr}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.selectedColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(SalonSearchController controller) {
    if (controller.searchController.text.isEmpty) {
      return _buildSearchSuggestions();
    }

    if (controller.searchResults.isEmpty) {
      return _buildNoResultsFound();
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: controller.searchResults.length,
      itemBuilder: (context, index) {
        final salon = controller.searchResults[index];
        return _buildSalonCard(salon, controller);
      },
    );
  }

  Widget _buildSearchSuggestions() {
    final popularSearches = [
      'Haircut',
      'Barber',
      'Beauty Salon',
      'Hair Styling',
      'Shaving',
      'Hair Color',
      'Hair Treatment',
      'Spa'
    ];

    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Searches'.tr,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: popularSearches.map((search) {
              return GestureDetector(
                onTap: () {
                  final controller = Get.find<SalonSearchController>();
                  controller.searchController.text = search;
                  controller.performSearch(search);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    search,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 24.h),

          Text(
            'Recent Searches'.tr,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),

          // In a real app, this would be populated from saved preferences
          ListTile(
            leading: const Icon(Icons.history, color: Colors.grey),
            title: Text('Hair Salon near me'),
            contentPadding: EdgeInsets.zero,
            onTap: () {
              final controller = Get.find<SalonSearchController>();
              controller.searchController.text = 'Hair Salon near me';
              controller.performSearch('Hair Salon near me');
            },
          ),

          ListTile(
            leading: const Icon(Icons.history, color: Colors.grey),
            title: Text('Easy Cut'),
            contentPadding: EdgeInsets.zero,
            onTap: () {
              final controller = Get.find<SalonSearchController>();
              controller.searchController.text = 'Easy Cut';
              controller.performSearch('Easy Cut');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64.r,
            color: Colors.grey,
          ),
          SizedBox(height: 16.h),
          Text(
            'No results found'.tr,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try a different search term'.tr,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalonCard(dynamic salon, SalonSearchController controller) {
    // Get salon rating if available
    double rating = 0;
    if (controller.salonRatings.containsKey(salon.id)) {
      rating = controller.salonRatings[salon.id] ?? 0;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoute.salonDetails, arguments: {"salonid": salon.id});
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Salon image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                  child: Image.network(
                    "${AppLink.imageSalons}${salon.image}",
                    height: 150.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150.h,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 50.r,
                        ),
                      );
                    },
                  ),
                ),

                // Gender tag
                if (salon.gender != null)
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: salon.gender == 'men' ? Colors.blue.withOpacity(0.8) : Colors.pink.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        salon.gender == 'men' ? 'Men'.tr : 'Women'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                // Favorite button placeholder (would be implemented with actual logic)
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    height: 32.r,
                    width: 32.r,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                      size: 18.r,
                    ),
                  ),
                ),
              ],
            ),

            // Salon details
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          salon.name ?? 'Unknown Salon',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      if (rating > 0)
                        Row(
                          children: [
                            RatingBar.builder(
                              initialRating: rating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 16.r,
                              ignoreGestures: true,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (_) {},
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16.r,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          '${salon.city ?? ''}, ${salon.country ?? ''}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Address
                  Row(
                    children: [
                      Icon(
                        Icons.home,
                        size: 16.r,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          salon.address ?? 'No address available',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Book now button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(AppRoute.salonDetails, arguments: {"salonid": salon.id});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.selectedColor,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Book Now'.tr,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}