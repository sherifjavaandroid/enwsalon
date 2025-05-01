import 'package:easycut/core/class/crud.dart';
import 'package:easycut/linkapi.dart';

class SalonSearchData {
  Crud crud;

  SalonSearchData(this.crud);

  Future<dynamic> searchSalons(String query) async {
    var response = await crud.getData(
      "${AppLink.salonSearch}?search=${Uri.encodeComponent(query)}",
    );

    return response.fold((l) => l, (r) => r);
  }
}