class SearchsalonModel {
  int? id;
  String? name;
  String? email;
  String? password;
  String? gender;
  String? phone;
  int? rate;
  int? chairs;
  int? categoryId;
  int? subscription;
  String? image;
  int? approve;
  String? country;
  String? city;
  String? address;
  String? createdAt;
  String? updatedAt;

  SearchsalonModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.gender,
    this.phone,
    this.rate,
    this.chairs,
    this.categoryId,
    this.subscription,
    this.image,
    this.approve,
    this.country,
    this.city,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  // Ensure that the data from the API is properly handled even if it is missing
  SearchsalonModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"] ?? "Unknown";
    email = json["email"];
    password = json["password"];
    gender = json["gender"];
    phone = json["phone"];
    rate = json["rate"] ?? 0;
    chairs = json["chairs"] ?? 0;
    categoryId = json["category_id"];
    subscription = json["subscription"];
    image = json["image"];
    approve = json["approve"];
    country = json["country"];
    city = json["city"];
    address = json["address"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["email"] = email;
    data["password"] = password;
    data["gender"] = gender;
    data["phone"] = phone;
    data["rate"] = rate;
    data["chairs"] = chairs;
    data["category_id"] = categoryId;
    data["subscription"] = subscription;
    data["image"] = image;
    data["approve"] = approve;
    data["country"] = country;
    data["city"] = city;
    data["address"] = address;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    return data;
  }

  static List<SearchsalonModel> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => SearchsalonModel.fromJson(map)).toList();
  }
}
