import 'package:easycut/core/class/crud.dart';
import 'package:easycut/linkapi.dart';

class HomeData {
  final Crud crud;

  HomeData(this.crud);

  Future<dynamic> viewSalons() async {
    var response = await crud.getData(
      AppLink.home,
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> feedbackSalonRating(
      int salonId, String rating, int? userId) async {
    if (userId == null) {
      return {"status": "error", "message": "User not logged in"};
    }

    const String url = AppLink.feedbackSalonRates;
    var response = await crud.postData(url, {
      "salon_id": salonId.toString(),
      "rating": rating,
      "user_id": userId.toString(),
    });

    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> getsalonRating(int salonId) async {
    var response = await crud.getData(
      "${AppLink.viewSalonRates}/$salonId",
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> searchSalon(String search, int userid) async {
    var response = await crud
        .getData("${AppLink.searchSalon}?user_id=$userid&query=$search");
    return response.fold((l) => l, (r) => r);
  }
}
