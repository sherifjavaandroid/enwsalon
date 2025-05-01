import 'package:easycut/core/class/status_request.dart';
import 'package:easycut/core/functions/handling_data_controller.dart';
import 'package:easycut/core/services/services.dart';
import 'package:easycut/data/data_source/remote/rating/rating_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RatingController extends GetxController {
  // Simple Rating
  var currentRating = 0.0.obs;

  // Detailed Rating
  var serviceQualityRating = 3.0.obs;
  var cleanlinessRating = 3.0.obs;
  var customerServiceRating = 3.0.obs;
  late TextEditingController commentController;

  // Rating Summary
  var averageRating = 0.0.obs;
  var totalRatings = 0.obs;
  var categoryRatings = {
    'serviceQuality': 0.0,
    'cleanliness': 0.0,
    'customerService': 0.0
  }.obs;

  StatusRequest statusRequest = StatusRequest.success;
  RatingData ratingData = RatingData(Get.find());
  MyServices myServices = Get.find();

  bool hasRated = false;
  String? bookingId;
  String? salonId;

  // Set the simple rating value
  void setRating(double rating) {
    currentRating.value = rating;
    update();
  }

  // Set detailed rating values
  void setServiceQualityRating(double rating) {
    serviceQualityRating.value = rating;
    update();
  }

  void setCleanlinessRating(double rating) {
    cleanlinessRating.value = rating;
    update();
  }

  void setCustomerServiceRating(double rating) {
    customerServiceRating.value = rating;
    update();
  }

  // Submit a simple rating for a salon
  Future<void> submitSalonFeedback() async {
    if (salonId == null) {
      Get.snackbar("Error".tr, "Salon ID is required".tr, colorText: Colors.red);
      return;
    }

    statusRequest = StatusRequest.loading;
    update();

    try {
      String userId = myServices.sharedPreferences.getInt('id').toString();
      String ratingValue = currentRating.value.round().toString();

      var response = await ratingData.submitSalonFeedback(
        salonId!,
        userId,
        ratingValue,
      );

      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        if (response['message'] == 'success') {
          Get.snackbar(
            "Success".tr,
            "Rating submitted successfully".tr,
            colorText: Colors.green,
          );
          hasRated = true;
        } else {
          Get.snackbar(
            "Error".tr,
            response['message'] ?? "Failed to submit rating".tr,
            colorText: Colors.red,
          );
          statusRequest = StatusRequest.failure;
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "An error occurred while submitting rating".tr,
        colorText: Colors.red,
      );
      statusRequest = StatusRequest.serverException;
    } finally {
      update();
    }
  }

  // Submit detailed rating for a booking
  Future<void> submitDetailedRating() async {
    if (bookingId == null) {
      Get.snackbar("Error".tr, "Booking ID is required".tr, colorText: Colors.red);
      return;
    }

    statusRequest = StatusRequest.loading;
    update();

    try {
      String userId = myServices.sharedPreferences.getInt('id').toString();

      var response = await ratingData.submitDetailedRating(
        bookingId: bookingId!,
        userId: userId,
        serviceQuality: serviceQualityRating.value.round(),
        cleanliness: cleanlinessRating.value.round(),
        customerService: customerServiceRating.value.round(),
        comment: commentController.text.isNotEmpty ? commentController.text : null,
      );

      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        if (response['status'] == 'success') {
          Get.snackbar(
            "Success".tr,
            "Rating submitted successfully".tr,
            colorText: Colors.green,
          );
          hasRated = true;
          Get.back(); // Return to previous screen
        } else {
          Get.snackbar(
            "Error".tr,
            response['message'] ?? "Failed to submit rating".tr,
            colorText: Colors.red,
          );
          statusRequest = StatusRequest.failure;
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "An error occurred while submitting rating".tr,
        colorText: Colors.red,
      );
      statusRequest = StatusRequest.serverException;
    } finally {
      update();
    }
  }

  // Check if user has already rated this booking
  Future<void> checkRating() async {
    if (bookingId == null) return;

    try {
      String userId = myServices.sharedPreferences.getInt('id').toString();

      var response = await ratingData.checkRating(bookingId!, userId);

      if (response['status'] == 'success' && response['message'].contains('already been rated')) {
        hasRated = true;

        // If rating details are available, populate the form
        if (response['rating'] != null) {
          var rating = response['rating'];
          if (rating['serviceQuality'] != null) {
            serviceQualityRating.value = double.parse(rating['serviceQuality'].toString());
          }
          if (rating['cleanliness'] != null) {
            cleanlinessRating.value = double.parse(rating['cleanliness'].toString());
          }
          if (rating['customerService'] != null) {
            customerServiceRating.value = double.parse(rating['customerService'].toString());
          }
          if (rating['comment'] != null) {
            commentController.text = rating['comment'];
          }
        }
      } else {
        hasRated = false;
      }
    } catch (e) {
      print("Error checking rating: $e");
    } finally {
      update();
    }
  }

  // Get salon ratings summary
  Future<void> getSalonRatings() async {
    if (salonId == null) return;

    statusRequest = StatusRequest.loading;
    update();

    try {
      String userId = myServices.sharedPreferences.getInt('id').toString();

      var response = await ratingData.getSalonRatings(salonId!, userId);

      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success && response['status'] == 'success') {
        var data = response['data'];

        averageRating.value = double.parse(data['averageRating'].toString());
        totalRatings.value = int.parse(data['totalRatings'].toString());

        if (data['categoryRatings'] != null) {
          categoryRatings.value = {
            'serviceQuality': double.parse(data['categoryRatings']['serviceQuality'].toString()),
            'cleanliness': double.parse(data['categoryRatings']['cleanliness'].toString()),
            'customerService': double.parse(data['categoryRatings']['customerService'].toString()),
          };
        }
      }
    } catch (e) {
      print("Error getting salon ratings: $e");
      statusRequest = StatusRequest.serverException;
    } finally {
      update();
    }
  }

  // Initialize controller with booking or salon ID
  void init({String? newBookingId, String? newSalonId}) {
    if (newBookingId != null) bookingId = newBookingId;
    if (newSalonId != null) salonId = newSalonId;

    if (bookingId != null) checkRating();
    if (salonId != null) getSalonRatings();

    update();
  }

  @override
  void onInit() {
    super.onInit();
    commentController = TextEditingController();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
}