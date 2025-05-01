import 'package:easycut/core/class/crud.dart';
import 'package:easycut/linkapi.dart';

class ProfileUpdateData {
  Crud crud;

  ProfileUpdateData(this.crud);

  Future<dynamic> updateProfile({
    required String userId,
    required String name,
    String? email,
    String? phone,
    String? address,
    String? password,
  }) async {
    var response = await crud.postData(AppLink.profileUpdate, {
      "user_id": userId,
      "name": name,
      if (email != null) "email": email,
      if (phone != null) "phone": phone,
      if (address != null) "address": address,
      if (password != null) "password": password,
    });

    return response.fold((l) => l, (r) => r);
  }
}