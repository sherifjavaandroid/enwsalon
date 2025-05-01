class SalonModel {
  int? id;
  String? name;
  String? email;
  String? password;
  String? phone;
  int? rate;
  String? description;
  int? chairs;
  int? categoryId;
  String? image;
  String? verifycode;
  dynamic? approve;
  String? country;
  String? city;
  String? address;
  String? createdAt;
  String? updatedAt;

  SalonModel(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.phone,
      this.rate,
      this.description,
      this.chairs,
      this.categoryId,
      this.image,
      this.verifycode,
      this.approve,
      this.country,
      this.city,
      this.address,
      this.createdAt,
      this.updatedAt});

  SalonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    rate = json['rate'];
    description = json['description'];
    chairs = json['chairs'];
    categoryId = json['category_id'];
    image = json['image'];
    verifycode = json['verifycode'];
    approve = json['approve'];
    country = json['country'];
    city = json['city'];
    address = json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
