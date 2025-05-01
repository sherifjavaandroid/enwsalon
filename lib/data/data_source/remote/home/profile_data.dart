import 'package:easycut/core/class/crud.dart';
import 'package:easycut/linkapi.dart';

class ProfileData {
  Crud crud;

  ProfileData(this.crud);

  postData(String id) async {
    var response = await crud.postData(AppLink.userInfo, {
      "id": id,
    });
    return response.fold((l) => l, (r) => r);
  }

  deleteData(String id, String image) async {
    var response = await crud.postData(AppLink.userDelete, {
      "id": id,
      "imageold": image,
    });
    return response.fold((l) => l, (r) => r);
  }
}
