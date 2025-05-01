import 'package:easycut/core/class/status_request.dart';
import 'package:easycut/core/functions/handling_data_controller.dart';
import 'package:easycut/core/services/services.dart';
import 'package:easycut/data/data_source/remote/booking/booking_management_data.dart';
import 'package:easycut/data/model/booking_model.dart';
import 'package:easycut/data/model/services_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingManagementController extends GetxController {
  BookingManagementData bookingManagementData = BookingManagementData(Get.find());
  MyServices myServices = Get.find();

  StatusRequest statusRequest = StatusRequest.success;

  // Booking details
  BookingModel? bookingDetails;
  List<ServiceModel> bookingServices = [];

  // Rescheduling data
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  bool isRescheduling = false;

  // For date picker
  DateTime firstDate = DateTime.now();
  DateTime lastDate = DateTime.now().add(const Duration(days: 90));

  // Get detailed information about a specific booking
  Future<void> getBookingDetails(String bookingId) async {
    statusRequest = StatusRequest.loading;
    update();

    try {
      String userId = myServices.sharedPreferences.getInt('id').toString();

      var response = await bookingManagementData.getBookingDetails(bookingId, userId);

      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        if (response['status'] == 'success') {
          // Convert response to BookingModel
          bookingDetails = BookingModel.fromJson(response['data']);

          // Get booking services
          await getBookingServices(bookingId);
        } else {
          Get.snackbar(
            "Error".tr,
            response['message'] ?? "Failed to get booking details".tr,
            colorText: Colors.red,
          );
          statusRequest = StatusRequest.failure;
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "An error occurred while fetching booking details".tr,
        colorText: Colors.red,
      );
      statusRequest = StatusRequest.serverException;
    } finally {
      update();
    }
  }

  // Get services associated with a booking
  Future<void> getBookingServices(String bookingId) async {
    try {
      String userId = myServices.sharedPreferences.getInt('id').toString();

      var response = await bookingManagementData.getBookingServices(bookingId, userId);

      if (response['status'] == 'success') {
        bookingServices = [];
        if (response['services'] != null && response['services'] is List) {
          for (var service in response['services']) {
            bookingServices.add(ServiceModel.fromJson(service));
          }
        }
      }
    } catch (e) {
      print("Error fetching booking services: $e");
    } finally {
      update();
    }
  }

  // Cancel a booking
  Future<void> cancelBooking(String bookingId) async {
    statusRequest = StatusRequest.loading;
    update();

    try {
      String userId = myServices.sharedPreferences.getInt('id').toString();

      var response = await bookingManagementData.cancelBooking(bookingId, userId);

      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        if (response['status'] == 'success') {
          Get.snackbar(
            "Success".tr,
            "Booking cancelled successfully".tr,
            colorText: Colors.green,
          );

          // Update local booking status to reflect cancellation
          if (bookingDetails != null) {
            bookingDetails!.approve = "3"; // Assuming 3 is the code for cancelled
            bookingDetails!.status = "Canceled";
          }

          // Navigate back after successful cancellation
          Get.back();
        } else {
          Get.snackbar(
            "Error".tr,
            response['message'] ?? "Failed to cancel booking".tr,
            colorText: Colors.red,
          );
          statusRequest = StatusRequest.failure;
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "An error occurred while cancelling booking".tr,
        colorText: Colors.red,
      );
      statusRequest = StatusRequest.serverException;
    } finally {
      update();
    }
  }

  // Start rescheduling process
  void startReschedule() {
    isRescheduling = true;

    // Initialize with current booking date and time if available
    if (bookingDetails != null && bookingDetails!.day != null) {
      try {
        selectedDate = DateTime.parse(bookingDetails!.day!);
      } catch (e) {
        selectedDate = DateTime.now().add(const Duration(days: 1));
      }

      if (bookingDetails!.time != null) {
        List<String> timeParts = bookingDetails!.time!.split(':');
        if (timeParts.length == 2) {
          selectedTime = TimeOfDay(
            hour: int.parse(timeParts[0]),
            minute: int.parse(timeParts[1]),
          );
        } else {
          selectedTime = TimeOfDay.now();
        }
      } else {
        selectedTime = TimeOfDay.now();
      }
    } else {
      selectedDate = DateTime.now().add(const Duration(days: 1));
      selectedTime = TimeOfDay.now();
    }

    update();
  }

  // Update selected date
  void updateSelectedDate(DateTime date) {
    selectedDate = date;
    update();
  }

  // Update selected time
  void updateSelectedTime(TimeOfDay time) {
    selectedTime = time;
    update();
  }

  // Reschedule a booking
  Future<void> rescheduleBooking(String bookingId) async {
    statusRequest = StatusRequest.loading;
    update();

    try {
      String userId = myServices.sharedPreferences.getInt('id').toString();
      String newDate = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
      String newTime = "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";

      var response = await bookingManagementData.rescheduleBooking(
        bookingId,
        userId,
        newDate,
        newTime,
      );

      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        if (response['status'] == 'success') {
          Get.snackbar(
            "Success".tr,
            "Booking rescheduled successfully".tr,
            colorText: Colors.green,
          );

          // Update local booking data
          if (bookingDetails != null) {
            bookingDetails!.day = newDate;
            bookingDetails!.time = newTime;
          }

          // Reset rescheduling state
          isRescheduling = false;

          // Refresh booking details
          await getBookingDetails(bookingId);
        } else {
          Get.snackbar(
            "Error".tr,
            response['message'] ?? "Failed to reschedule booking".tr,
            colorText: Colors.red,
          );
          statusRequest = StatusRequest.failure;
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "An error occurred while rescheduling booking".tr,
        colorText: Colors.red,
      );
      statusRequest = StatusRequest.serverException;
    } finally {
      update();
    }
  }

  // Cancel rescheduling mode
  void cancelRescheduling() {
    isRescheduling = false;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    selectedDate = DateTime.now().add(const Duration(days: 1));
    selectedTime = TimeOfDay.now();
  }
}