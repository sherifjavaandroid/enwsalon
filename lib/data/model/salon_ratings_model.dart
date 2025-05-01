class SalonRatingsModel {
  String? status;
  RatingsData? data;

  SalonRatingsModel({this.status, this.data});

  SalonRatingsModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    data = json["data"] == null ? null : RatingsData.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    if (this.data != null) {
      data["data"] = this.data?.toJson();
    }
    return data;
  }
}

class RatingsData {
  double? averageRating;
  int? totalRatings;
  CategoryRatings? categoryRatings;

  RatingsData({this.averageRating, this.totalRatings, this.categoryRatings});

  RatingsData.fromJson(Map<String, dynamic> json) {
    averageRating = json["averageRating"] is int
        ? (json["averageRating"] as int).toDouble()
        : json["averageRating"]?.toDouble();
    totalRatings = json["totalRatings"];
    categoryRatings = json["categoryRatings"] == null ? null : CategoryRatings.fromJson(json["categoryRatings"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["averageRating"] = averageRating;
    data["totalRatings"] = totalRatings;
    if (categoryRatings != null) {
      data["categoryRatings"] = categoryRatings?.toJson();
    }
    return data;
  }
}

class CategoryRatings {
  double? serviceQuality;
  double? cleanliness;
  double? customerService;

  CategoryRatings({this.serviceQuality, this.cleanliness, this.customerService});

  CategoryRatings.fromJson(Map<String, dynamic> json) {
    serviceQuality = json["serviceQuality"] is int
        ? (json["serviceQuality"] as int).toDouble()
        : json["serviceQuality"]?.toDouble();
    cleanliness = json["cleanliness"] is int
        ? (json["cleanliness"] as int).toDouble()
        : json["cleanliness"]?.toDouble();
    customerService = json["customerService"] is int
        ? (json["customerService"] as int).toDouble()
        : json["customerService"]?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["serviceQuality"] = serviceQuality;
    data["cleanliness"] = cleanliness;
    data["customerService"] = customerService;
    return data;
  }
}