import 'package:easycut/core/class/crud.dart';
import 'package:easycut/linkapi.dart';

class RatingData {
  Crud crud;

  RatingData(this.crud);

  // Submit salon feedback (simple rating)
  Future<dynamic> submitSalonFeedback(String salonId, String userId, String rating) async {
    var response = await crud.postData(AppLink.salonFeedback, {
      "salon_id": salonId,
      "user_id": userId,
      "rating": rating,
    });

    return response.fold((l) => l, (r) => r);
  }

  // Submit detailed rating with multiple categories
  Future<dynamic> submitDetailedRating({
    required String bookingId,
    required String userId,
    required int serviceQuality,
    required int cleanliness,
    required int customerService,
    String? comment,
  }) async {
    var response = await crud.postData(AppLink.submitRating, {
      "bookingId": bookingId,
      "user_id": userId,
      "serviceQuality": serviceQuality.toString(),
      "cleanliness": cleanliness.toString(),
      "customerService": customerService.toString(),
      if (comment != null) "comment": comment,
    });

    return response.fold((l) => l, (r) => r);
  }

  // Check if a booking has been rated already
  Future<dynamic> checkRating(String bookingId, String userId) async {
    var response = await crud.getData(
      "${AppLink.checkRating}?bookingId=$bookingId&user_id=$userId",
    );

    return response.fold((l) => l, (r) => r);
  }

  // Get salon ratings summary
  Future<dynamic> getSalonRatings(String salonId, String userId) async {
    var response = await crud.getData(
      "${AppLink.salonRatings}/$salonId?user_id=$userId",
    );

    return response.fold((l) => l, (r) => r);
  }
}