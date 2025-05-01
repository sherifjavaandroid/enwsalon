import 'package:easycut/controller/booking/booking_management_controller.dart';
import 'package:easycut/core/class/handling_data_view.dart';
import 'package:easycut/core/constant/color.dart';
import 'package:easycut/core/shared/widgets/big_text.dart';
import 'package:easycut/core/shared/widgets/small_text.dart';
import 'package:easycut/linkapi.dart';
import 'package:easycut/view/screen/rating/detailed_rating_view.dart';
import 'package:easycut/view/widget/auth/custom_button_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingDetailsView extends StatelessWidget {
  final String bookingId;

  const BookingDetailsView({Key? key, required this.bookingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BookingManagementController());

    return GetBuilder<BookingManagementController>(
      initState: (_) {
        Get.find<BookingManagementController>().getBookingDetails(bookingId);
      },
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Booking Details'.tr,
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
          body: HandlingDataView(
            statusRequest: controller.statusRequest,
            widget: controller.bookingDetails == null
                ? Center(child: Text('No booking details available'.tr))
                : _buildBookingDetails(controller, context),
          ),
          bottomNavigationBar: controller.bookingDetails == null
              ? null
              : _buildBottomButtons(controller, context),
        );
      },
    );
  }

  Widget _buildBookingDetails(BookingManagementController controller, BuildContext context) {
    final booking = controller.bookingDetails!;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Booking Status Card
          _buildStatusCard(booking),

          SizedBox(height: 20.h),

          // Salon Details
          if (booking.salon != null) _buildSalonCard(booking),

          SizedBox(height: 20.h),

          // Booking Details
          _buildDetailsCard(booking),

          SizedBox(height: 20.h),

          // Services List
          _buildServicesCard(controller),

          SizedBox(height: 20.h),

          // Rescheduling Form (only shown when rescheduling)
          if (controller.isRescheduling) _buildReschedulingForm(controller, context),
        ],
      ),
    );
  }

  Widget _buildSalonCard(dynamic booking) {
    final salon = booking.salon;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Salon Image
          Container(
            height: 150.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
              image: DecorationImage(
                image: salon.image != null
                    ? NetworkImage("${AppLink.imageSalons}${salon.image}")
                    : const AssetImage('assets/images/salonbk/salon1.jpg') as ImageProvider,
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
                  salon.name ?? 'Unknown Salon', // Display 'Unknown Salon' if the name is null
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                _buildInfoRow(Icons.phone, salon.phone ?? 'N/A'),
                SizedBox(height: 4.h),
                _buildInfoRow(Icons.location_on, salon.address ?? 'N/A'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(dynamic booking) {
    String statusText = 'Unknown';
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.help_outline;

    // Determine status text, color and icon based on approve value
    switch (booking.approve) {
      case "0":
        statusText = 'Waiting for Confirmation'.tr;
        statusColor = Colors.orange;
        statusIcon = Icons.access_time;
        break;
      case "1":
        statusText = 'Confirmed'.tr;
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_outline;
        break;
      case "2":
        statusText = 'Denied'.tr;
        statusColor = Colors.red;
        statusIcon = Icons.cancel_outlined;
        break;
      case "3":
        statusText = 'Canceled'.tr;
        statusColor = Colors.grey;
        statusIcon = Icons.block;
        break;
      case "4":
        statusText = 'Completed'.tr;
        statusColor = Colors.blue;
        statusIcon = Icons.task_alt;
        break;
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: statusColor.withOpacity(0.5), width: 1.5),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            Container(
              height: 50.r,
              width: 50.r,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(statusIcon, color: statusColor, size: 30.r),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Booking Status'.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
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


  Widget _buildDetailsCard(dynamic booking) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BigText(
              text: 'Booking Details'.tr,
              size: 18.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 16.h),
            _buildDetailRow('Booking ID'.tr, '#${booking.id}'),
            _buildDetailRow('Date'.tr, booking.day ?? 'N/A'),
            _buildDetailRow('Time'.tr, booking.time ?? 'N/A'),
            _buildDetailRow('Chair'.tr, booking.chair != null ? 'Chair ${booking.chair}' : 'N/A'),
            _buildDetailRow('Total Amount'.tr, booking.total != null ? '\${booking.total}' : 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesCard(BookingManagementController controller) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BigText(
              text: 'Services'.tr,
              size: 18.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 16.h),
            controller.bookingServices.isEmpty
                ? Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Text(
                  'No services found for this booking'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
                : Column(
              children: controller.bookingServices.map((service) {
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: service.image != null
                        ? Image.network(
                      "${AppLink.imageServices}${service.image}",
                      width: 50.r,
                      height: 50.r,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      width: 50.r,
                      height: 50.r,
                      color: Colors.grey[300],
                      child: Icon(Icons.cut, color: Colors.grey[600]),
                    ),
                  ),
                  title: Text(
                    service.name ?? 'Unknown Service',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${service.time} min',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                  trailing: Text(
                    '\${service.price}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReschedulingForm(BookingManagementController controller, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BigText(
              text: 'Reschedule Booking'.tr,
              size: 18.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 16.h),

            // Date Picker
            ListTile(
              leading: Icon(Icons.calendar_today, color: AppColor.primaryColor),
              title: Text('Select Date'.tr),
              subtitle: Text(
                DateFormat('yyyy-MM-dd').format(controller.selectedDate),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: controller.selectedDate,
                  firstDate: controller.firstDate,
                  lastDate: controller.lastDate,
                );
                if (picked != null && picked != controller.selectedDate) {
                  controller.updateSelectedDate(picked);
                }
              },
            ),

            SizedBox(height: 8.h),

            // Time Picker
            ListTile(
              leading: Icon(Icons.access_time, color: AppColor.primaryColor),
              title: Text('Select Time'.tr),
              subtitle: Text(
                controller.selectedTime.format(context),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: controller.selectedTime,
                );
                if (picked != null && picked != controller.selectedTime) {
                  controller.updateSelectedTime(picked);
                }
              },
            ),

            SizedBox(height: 16.h),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => controller.cancelRescheduling(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: BorderSide(color: AppColor.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Cancel'.tr,
                      style: TextStyle(
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.rescheduleBooking(bookingId),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      backgroundColor: AppColor.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text('Confirm'.tr),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// Inside _BookingViewState class, add this method


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


  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BookingManagementController controller, BuildContext context) {
    final booking = controller.bookingDetails!;

    // Don't show action buttons for completed, denied or canceled bookings
    if (booking.approve == "2" || booking.approve == "3" || booking.approve == "4") {
      return Padding(
        padding: EdgeInsets.all(16.r),
        child: CustomButtonAuth(
          onPressed: () => Get.to(() => DetailedRatingView(bookingId: bookingId)),
          text: 'Rate This Booking'.tr,
        ),
      );
    }

    // Show rescheduling controls if in rescheduling mode
    if (controller.isRescheduling) {
      // Return an empty container instead of null
      return SizedBox(height: 0); // or Container()
    }

    // Show regular action buttons for pending or confirmed bookings
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showCancelConfirmation(context, controller),
              icon: const Icon(Icons.cancel_outlined, color: Colors.white),
              label: Text('Cancel Booking'.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => controller.startReschedule(),
              icon: const Icon(Icons.event, color: Colors.white),
              label: Text('Reschedule'.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.selectedColor,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _showCancelConfirmation(BuildContext context, BookingManagementController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Booking'.tr),
        content: Text('Are you sure you want to cancel this booking?'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('No'.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.cancelBooking(bookingId);
            },
            child: Text(
              'Yes'.tr,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}