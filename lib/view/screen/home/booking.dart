import 'package:easycut/controller/home/booking_screen_controller.dart';
import 'package:easycut/core/constant/color.dart';
import 'package:easycut/core/constant/dimensions.dart';
import 'package:easycut/core/constant/routes.dart';
import 'package:easycut/core/services/services.dart';
import 'package:easycut/core/shared/widgets/big_text.dart';
import 'package:easycut/core/shared/widgets/small_text.dart';
import 'package:easycut/linkapi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/class/handling_data_view.dart';

class BookingView extends StatefulWidget {
  const BookingView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BookingViewState createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> with WidgetsBindingObserver {
  late BookingScreenControllerImp controller;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  final Map<String, int?> _previousStatuses = {};
  MyServices myServices = Get.find();

  @override
  void initState() {
    super.initState();
    controller = Get.find<BookingScreenControllerImp>();
    WidgetsBinding.instance.addObserver(this);

    _setupRealTimeUpdates();
  }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   // Dispose of any listeners or streams related to the controller.
  //   controller.dispose();
  //   super.dispose();
  // }

  void _setupRealTimeUpdates() {
    // Retrieve userId from shared preferences
    // String? userId = MyServices.sharedPreferences!.getString('userId'); // Make sure MyServices is correctly defined
    dynamic? userId = myServices.sharedPreferences!.getInt('id');
    if (kDebugMode) {
      print(userId);
    }
    // Check if userId is not null or empty before fetching bookings

    controller.fetchBookingsFromApi();

    if (kDebugMode) {
      print('User ID is not available.');
    }
  }

  bool _hasFetchedData = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_hasFetchedData) {
      _hasFetchedData = true;
      controller.update();
    }
  }

  // Define the notification function
  Future<void> _sendNotification(String approveStatus) async {
    String title = "Booking Status Update";
    String body;

    // Determine the notification message based on the approval status
    switch (approveStatus) {
      case '1':
        body = "Congratulations! Your booking has been accepted by the admin.";
        break;
      case '2':
        body = "We're sorry, but your booking was refused by the admin.";
        break;
      default:
        body = "Your booking status has been updated.";
    }

    // Create Android notification details
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'booking_channel', // Channel ID
      'Booking Status', // Channel Name
      channelDescription: 'Shows updates for booking status',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      color: Color(0xFF123456),
      styleInformation: BigTextStyleInformation(''),
      enableLights: true,
      enableVibration: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Show the notification
    await flutterLocalNotificationsPlugin?.show(
      0, // Notification ID (can be unique for each notification)
      title, // Notification title
      body, // Notification body
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Prevent stack duplication by pushing only one instance of the home screen.
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoute.home,
          (Route<dynamic> route) => false,
        );
        return false;
      },
      child: SafeArea(
        child: Obx(() {
          return HandlingDataView(
            statusRequest: controller.statusRequest.value,
            widget: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width10.w),
              child: Column(
                children: [
                  SizedBox(
                    height: 45.h,
                    width: double.infinity.w,
                    child: Center(
                      child: SmallText(
                        text: "All Bookings".tr,
                        size: 24.sp,
                      ),
                    ),
                  ),
                  Expanded(
                    child: controller.bookings.isEmpty
                        ? Center(
                            child: BigText(
                              // Check if the user is in guest mode
                              text: myServices.sharedPreferences.getInt('id') ==
                                      null
                                  ? "Please login to make a booking."
                                      .tr // Guest mode prompt
                                  : "No bookings available"
                                      .tr, // Standard message for logged-in users with no bookings
                              color: AppColor.primaryColor,
                            ),
                          )
                        : ListView.separated(
                            itemBuilder: (context, index) {
                              final booking = controller.bookings[index];

                              // Inside your booking card, after the status indicator:
// Find where you're building each booking item
                              return SizedBox(
                                height: 260.h,
                                width: 294.w,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  child: Card(
                                    // Existing card content
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Existing code...

                                        // Add these buttons at the bottom of the card
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              // Only show rate button for accepted or completed bookings
                                              if (booking.approve == "1" || booking.approve == "4")
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.toNamed(
                                                      AppRoute.detailedRating,
                                                      arguments: {"bookingId": booking.id},
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                                    decoration: BoxDecoration(
                                                      color: AppColor.selectedColor.withOpacity(0.2),
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons.star,
                                                          size: 16.r,
                                                          color: AppColor.selectedColor,
                                                        ),
                                                        SizedBox(width: 4.w),
                                                        SmallText(
                                                          text: "Rate".tr,
                                                          color: AppColor.selectedColor,
                                                          size: 12.sp,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              SizedBox(width: 8.w),
                                              // Add details button for all bookings
                                              GestureDetector(
                                                onTap: () {
                                                  Get.toNamed(
                                                    AppRoute.bookingDetails,
                                                    arguments: {"bookingId": booking.id},
                                                  );
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.withOpacity(0.2),
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons.info_outline,
                                                        size: 16.r,
                                                        color: AppColor.backgroundicons,
                                                      ),
                                                      SizedBox(width: 4.w),
                                                      SmallText(
                                                        text: "Details".tr,
                                                        color: AppColor.backgroundicons,
                                                        size: 12.sp,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 5.h);
                            },
                            itemCount: controller.bookings.length,
                          ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildInfoRow(String? label, String? value, String? icon) {
    return Row(
      children: [
        if (icon != null) ...[
          ImageIcon(
            AssetImage(icon),
          ),
          SizedBox(width: Dimensions.width5.w),
        ],
        SmallText(
          text: label ?? '',
          size: Dimensions.font16.sp,
        ),
        SmallText(
          text: value ?? '',
          size: 16.sp,
          color: AppColor.backgroundicons,
        ),
      ],
    );
  }

  // Build a status indicator
  // Modify this part inside your _buildStatusIndicator method:
  // Modify this part inside your _buildStatusIndicator method:
  Widget _buildStatusIndicator(String? approve, {String? imagePath}) {
    final status = int.tryParse(approve ?? '0') ?? 0; // Default to 0 (Waiting)

    // Check the previous status, default to 0 (Waiting)
    final previousStatus = _previousStatuses[approve] ?? 0;

    // Notify if status changes from 0 (Waiting) to 1 (Accepted) or 2 (Refused)
    if (previousStatus == 0 && status != 0) {
      if (status == 1) {
        _sendNotification('1'); // Booking accepted
      } else if (status == 2) {
        _sendNotification('2'); // Booking refused
      }
      _previousStatuses[approve!] = status; // Update previous status
    }

    // Determine status text and color
    String statusText;
    Color statusColor;

    switch (status) {
      case 1:
        statusText = "Accepted".tr;
        statusColor = Colors.green;
        break;
      case 2:
        statusText = "Refused".tr;
        statusColor = Colors.red;
        break;
      default:
        statusText = "Waiting".tr;
        statusColor = Colors.orange;
    }

    return _buildStatus(statusText, statusColor, imagePath);
  }

  Widget _buildStatus(String status, Color color, String? imagePath) {
    return Container(
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imagePath != null)
            Padding(
              padding: const EdgeInsets.only(right: 10.0, left: 10),
              child: Image.asset(
                imagePath,
                width: 18,
                height: 18,
                color: color,
              ),
            ),
          Text(
            status,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w500, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
