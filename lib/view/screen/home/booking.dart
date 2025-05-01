import 'package:easycut/controller/home/booking_screen_controller.dart';
import 'package:easycut/core/class/handling_data_view.dart';
import 'package:easycut/core/constant/color.dart';
import 'package:easycut/core/constant/dimensions.dart';
import 'package:easycut/core/constant/routes.dart';
import 'package:easycut/core/services/services.dart';
import 'package:easycut/core/shared/widgets/big_text.dart';
import 'package:easycut/core/shared/widgets/small_text.dart';
import 'package:easycut/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/model/booking_model.dart';

class BookingView extends StatefulWidget {
  const BookingView({super.key});

  @override
  _BookingViewState createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> with TickerProviderStateMixin {
  late BookingScreenControllerImp controller;
  late TabController _tabController;
  MyServices myServices = Get.find();

  @override
  void initState() {
    super.initState();
    controller = Get.find<BookingScreenControllerImp>();
    _tabController = TabController(length: 3, vsync: this);
    controller.fetchBookingsFromApi();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'My Bookings'.tr,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.h),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1.0,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColor.selectedColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColor.selectedColor,
              indicatorWeight: 3,
              tabs: [
                Tab(text: 'Upcoming'.tr),
                Tab(text: 'Completed'.tr),
                Tab(text: 'Cancelled'.tr),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() {
        return HandlingDataView(
          statusRequest: controller.statusRequest.value,
          widget: controller.bookings.isEmpty
              ? _buildEmptyState()
              : TabBarView(
            controller: _tabController,
            children: [
              // Upcoming bookings
              _buildBookingsList(controller.bookings.where((booking) =>
              booking.approve == "0" || booking.approve == "1").toList()),

              // Completed bookings
              _buildBookingsList(controller.bookings.where((booking) =>
              booking.approve == "4").toList()),

              // Cancelled bookings
              _buildBookingsList(controller.bookings.where((booking) =>
              booking.approve == "2" || booking.approve == "3").toList()),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.selectedColor,
        onPressed: () {
          controller.fetchBookingsFromApi();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Refreshing bookings...'.tr),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: const Icon(Icons.refresh, color: Colors.black),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 80.r,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 16.h),
          BigText(
            text: myServices.sharedPreferences.getInt('id') == null
                ? "Please login to see your bookings".tr
                : "No bookings available".tr,
            color: Colors.grey.shade600,
          ),
          SizedBox(height: 8.h),
          if (myServices.sharedPreferences.getInt('id') == null)
            ElevatedButton(
              onPressed: () => Get.offAllNamed(AppRoute.login),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.selectedColor,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Login'.tr,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(List<BookingModel> bookings) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 60.r,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 16.h),
            Text(
              'No bookings in this category'.tr,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildBookingCard(booking);
      },
    );
  }

  Widget _buildBookingCard(BookingModel booking) {
    // Format date
    String formattedDate = '';
    try {
      final DateTime bookingDate = DateTime.parse(booking.day ?? '');
      formattedDate = DateFormat('EEE, MMM d, yyyy').format(bookingDate);
    } catch (e) {
      formattedDate = booking.day ?? 'Unknown date';
    }

    // Determine status color and icon
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (booking.approve) {
      case "0":
        statusColor = Colors.orange;
        statusIcon = Icons.access_time;
        statusText = 'Pending'.tr;
        break;
      case "1":
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Confirmed'.tr;
        break;
      case "2":
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = 'Declined'.tr;
        break;
      case "3":
        statusColor = Colors.grey;
        statusIcon = Icons.not_interested;
        statusText = 'Cancelled'.tr;
        break;
      case "4":
        statusColor = Colors.blue;
        statusIcon = Icons.done_all;
        statusText = 'Completed'.tr;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
        statusText = 'Unknown'.tr;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to booking details
          Get.toNamed(AppRoute.bookingDetails, arguments: {'bookingId': booking.id});
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          children: [
            // Status bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
              ),
              child: Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 18.r),
                  SizedBox(width: 8.w),
                  Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${booking.time ?? ''}'.tr,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),

            // Booking content
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Salon image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: booking.salon?.image != null
                        ? Image.network(
                      "${AppLink.imageSalons}${booking.salon!.image}",
                      width: 80.r,
                      height: 80.r,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80.r,
                          height: 80.r,
                          color: Colors.grey.shade200,
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey,
                            size: 30.r,
                          ),
                        );
                      },
                    )
                        : Container(
                      width: 80.r,
                      height: 80.r,
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.store_outlined,
                        color: Colors.grey,
                        size: 30.r,
                      ),
                    ),
                  ),

                  SizedBox(width: 16.w),

                  // Booking details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.salon?.name ?? 'Unknown Salon',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.chair_outlined,
                              size: 16.r,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Chair ${booking.chair ?? 'N/A'}'.tr,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${booking.total ?? '0'}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColor.selectedColor,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16.r,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ],
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