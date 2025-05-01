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
import '../../../data/model/booking_model.dart';

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

  void _setupRealTimeUpdates() {
    dynamic? userId = myServices.sharedPreferences!.getInt('id');
    if (kDebugMode) {
      print(userId);
    }

    controller.fetchBookingsFromApi();
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

    await flutterLocalNotificationsPlugin?.show(
      0, // Notification ID (can be unique for each notification)
      title, // Notification title
      body, // Notification body
      platformChannelSpecifics,
    );
  }

  // Salon Card for Booking
  Widget _buildSalonCard(BookingModel booking) {
    final salon = booking.salon;

    return GestureDetector(
      onTap: () {
        // Navigate to BookingDetailsView
        Get.toNamed(AppRoute.bookingDetails, arguments: {'bookingId': booking.id});
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Salon Image
            Container(
              height: 150.h, // Set a fixed height for the image
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
                image: DecorationImage(
                  image: salon?.image != null
                      ? NetworkImage("${AppLink.imageSalons}${salon!.image}")
                      : const AssetImage('assets/images/default_salon_image.jpg') as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Salon Info
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    salon?.name ?? 'Unknown Salon',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _buildInfoRow(Icons.phone, salon?.phone ?? 'N/A'),
                  SizedBox(height: 4.h),
                  _buildInfoRow(Icons.location_on, salon?.address ?? 'N/A'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build info rows
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16.r, color: Colors.grey),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
                        text: myServices.sharedPreferences.getInt('id') == null
                            ? "Please login to make a booking."
                            : "No bookings available",
                        color: AppColor.primaryColor,
                      ),
                    )
                        : ListView.separated(
                      itemBuilder: (context, index) {
                        final booking = controller.bookings[index];
                        return SizedBox(
                          height: 260.h,
                          width: 294.w,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Call the _buildSalonCard method to show salon details
                                  _buildSalonCard(booking),

                                  // Add other booking details if needed
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Booking ID: #${booking.id}'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Date: ${booking.day}'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Time: ${booking.time}'),
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

  // Build a status indicator for booking status
  Widget _buildStatusIndicator(String? approve, {String? imagePath}) {
    final status = int.tryParse(approve ?? '0') ?? 0;
    final previousStatus = _previousStatuses[approve] ?? 0;

    if (previousStatus == 0 && status != 0) {
      if (status == 1) {
        _sendNotification('1'); // Booking accepted
      } else if (status == 2) {
        _sendNotification('2'); // Booking refused
      }
      _previousStatuses[approve!] = status; // Update previous status
    }

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
        borderRadius: BorderRadius.circular(25),
      ),
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
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
