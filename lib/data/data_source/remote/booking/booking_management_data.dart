import 'package:easycut/core/class/crud.dart';
import 'package:easycut/linkapi.dart';

class BookingManagementData {
  Crud crud;

  BookingManagementData(this.crud);

  // Get detailed information about a specific booking
  Future<dynamic> getBookingDetails(String bookingId, String userId) async {
    var response = await crud.getData(
      "${AppLink.bookingDetails}?bookingId=$bookingId&user_id=$userId",
    );

    return response.fold((l) => l, (r) => r);
  }

  // Get services associated with a booking
  Future<dynamic> getBookingServices(String bookingId, String userId) async {
    var response = await crud.getData(
      "${AppLink.bookingServices}?bookingId=$bookingId&user_id=$userId",
    );

    return response.fold((l) => l, (r) => r);
  }

  // Cancel a booking
  Future<dynamic> cancelBooking(String bookingId, String userId) async {
    var response = await crud.postData(AppLink.cancelBooking, {
      "bookingId": bookingId,
      "user_id": userId,
    });

    return response.fold((l) => l, (r) => r);
  }

  // Reschedule a booking
  Future<dynamic> rescheduleBooking(
      String bookingId, String userId, String newDate, String newTime) async {
    var response = await crud.postData(AppLink.rescheduleBooking, {
      "bookingId": bookingId,
      "user_id": userId,
      "newDate": newDate,
      "newTime": newTime,
    });

    return response.fold((l) => l, (r) => r);
  }
}